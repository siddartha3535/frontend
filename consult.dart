import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Consult extends StatefulWidget {
  @override
  _ConsultState createState() => _ConsultState();
}

class _ConsultState extends State<Consult> {
  String? doctorName;
  String? doctorMobile;

  @override
  void initState() {
    super.initState();
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    final response = await http.get(Uri.parse('http://192.168.47.82/pulmonary/whatsapp.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          doctorName = data[0]['doctorname'];
          doctorMobile = data[0]['mobile'];
        });
      } else {
        setState(() {
          doctorName = 'No doctor found';
          doctorMobile = '';
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch doctor data.")),
      );
    }
  }

  bool isValidIndianNumber(String phoneNumber) {
    final regex = RegExp(r"^[7-9][0-9]{9}$");
    return regex.hasMatch(phoneNumber);
  }

  void handleOpenWhatsApp() async {
    if (doctorMobile != null && doctorMobile!.isNotEmpty) {
      final String phoneNumber = doctorMobile!.replaceAll(RegExp(r'[^0-9]'), '');

      if (isValidIndianNumber(phoneNumber)) {
        final String message = "Hello, I am your patient. I am facing certain issues.";
        final String url = "whatsapp://send?phone=$phoneNumber&text=$message";
        final String fallbackUrl = "https://wa.me/$phoneNumber?text=$message";

        if (await canLaunch(url)) {
          await launch(url);
        } else if (await canLaunch(fallbackUrl)) {
          await launch(fallbackUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("WhatsApp is not installed on this device.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid Indian phone number.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = arguments['PatientId'];
    final username = arguments['username'];

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Consult a Doctor"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.05),
        child: Column(
          children: [
            if (patientId != null)
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: Text(
                  "Patient ID: $patientId",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (username != null)
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: Text(
                  "Username: $username",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Center(
              child: Container(
                width: width * 0.4,
                height: width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://img.freepik.com/premium-vector/bell-button-icon-notification-bell-red-circle-template-bell-web-symbol-app-ui-logo-vector_799714-64.jpg?w=360',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            if (doctorName != null && doctorMobile != null)
              Text(
                'Consult Dr. $doctorName\nMobile: $doctorMobile',
                style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.13),
              child: ElevatedButton.icon(
                onPressed: handleOpenWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.015,
                    horizontal: width * 0.06,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  'Chat on WhatsApp',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

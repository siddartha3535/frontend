import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'edit_doctor_screen.dart'; // Import the EditDoctorScreen

class DoctorProfile extends StatefulWidget {
  final String doctorId;

  const DoctorProfile({required this.doctorId});

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  Map<String, dynamic>? doctorDetails;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    final apiUrl = 'http://192.168.47.82/pulmonary/displaydoctorprofile.php?doctorId=${widget.doctorId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] != null) {
          setState(() {
            error = data['error'];
            isLoading = false;
          });
        } else {
          setState(() {
            doctorDetails = data;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to fetch data. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Doctor Profile'),
          backgroundColor: Color(0xFFA4A4A4),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Doctor Profile'),
          backgroundColor: Color(0xFFA4A4A4),
        ),
        body: Center(
          child: Text(
            error!,
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        backgroundColor: Color(0xFFA4A4A4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: doctorDetails!['image'] != null
                    ? NetworkImage(doctorDetails!['image'])
                    : null,
                backgroundColor: Colors.grey[300],
                child: doctorDetails!['image'] == null
                    ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                    : null,
              ),
            ),
            SizedBox(height: 20),
            buildInfoRow("Doctor ID:", doctorDetails!['doctorId'].toString()),
            buildInfoRow("Name:", doctorDetails!['doctorname'] ?? 'N/A'),
            buildInfoRow("Specialization:", doctorDetails!['specialization'] ?? 'N/A'),
            buildInfoRow("Experience:", doctorDetails!['experience'].toString()),
            buildInfoRow("Age:", doctorDetails!['age'].toString()),
            buildInfoRow("Mobile:", doctorDetails!['mobile'].toString()),
            buildInfoRow("Email:", doctorDetails!['gmail'] ?? 'N/A'),
            buildInfoRow("Gender:", doctorDetails!['gender'] ?? 'N/A'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to EditDoctorScreen and pass doctor details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDoctorDetails(
                          doctorDetails: doctorDetails!,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade500,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                  child: Text('Edit', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade500,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                  child: Text('Back', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

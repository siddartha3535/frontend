import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  late String patientId;
  Map<String, dynamic>? patientData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    patientId = arguments['PatientId'];
    fetchPatientDetails(patientId);
  }

  Future<void> fetchPatientDetails(String id) async {
    final String baseUrl = 'http://192.168.47.82/pulmonary';
    final url = Uri.parse('$baseUrl/patdash.php?PatientId=$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['status'] == 'success') {
          setState(() {
            patientData = responseBody['data'];
            errorMessage = '';
          });
        } else {
          setState(() {
            errorMessage = responseBody['message'] ?? 'An error occurred.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      )
          : patientData == null
          ? Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.teal.shade100,
                backgroundImage: patientData!['image_url'] != null
                    ? NetworkImage(patientData!['image_url'])
                    : null,
                child: patientData!['image_url'] == null
                    ? Icon(Icons.person, size: 75, color: Colors.grey)
                    : null,
              ),
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.only(top: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailRow(Icons.person, 'Name', patientData!['username']),
                      detailRow(Icons.cake, 'Age', patientData!['age'].toString()),
                      detailRow(Icons.transgender, 'Gender', patientData!['gender']),
                      detailRow(Icons.phone, 'Phone', patientData!['phonenumber']),
                      detailRow(Icons.email, 'Email', patientData!['emailid']),
                      detailRow(Icons.home, 'Address', patientData!['Address']),
                      detailRow(Icons.local_drink, 'Alcoholic', patientData!['alcoholic']),
                      detailRow(Icons.smoking_rooms, 'Smoker', patientData!['smoker']),
                      detailRow(Icons.warning, 'Tobacco User', patientData!['tobacco']),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/editpatient',
                    arguments: {'patientDetails': patientData},
                  );
                },
                icon: Icon(Icons.edit),
                label: Text('Edit Patient Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

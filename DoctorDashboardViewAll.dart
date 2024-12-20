import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorDashboardViewAll extends StatefulWidget {
  final String doctorId;

  const DoctorDashboardViewAll({Key? key, required this.doctorId}) : super(key: key);

  @override
  _DoctorDashboardViewAllState createState() => _DoctorDashboardViewAllState();
}

class _DoctorDashboardViewAllState extends State<DoctorDashboardViewAll> {
  List patients = [];
  bool isLoading = true;
  bool showAllPatients = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final url = Uri.parse('http://192.168.47.82/pulmonary/View.php?doctorId=${widget.doctorId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          patients = json.decode(response.body);
          isLoading = false;
        });
      } else {
        showError();
      }
    } catch (error) {
      showError();
    }
  }

  void showError() {
    setState(() {
      isLoading = false;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to fetch patient data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Patients'),
        backgroundColor: Color(0xFFA4A4A4),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFD20202)))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search by name or ID...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: showAllPatients ? patients.length : (patients.length < 5 ? patients.length : 5),
              itemBuilder: (context, index) {
                final patient = patients[index];
                if (!patient['username'].toLowerCase().contains(searchQuery.toLowerCase()) &&
                    !patient['PatientId'].toString().contains(searchQuery)) {
                  return Container();
                }
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(patient['image'] ?? ''),
                    ),
                    title: Text(patient['username'] ?? 'Unknown'),
                    subtitle: Text('Patient ID: ${patient['PatientId']}'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/Details',
                        arguments: {
                          'patientId': patient['PatientId'],
                          'doctorId': widget.doctorId,
                          'profileImage': patient['image'] ?? '',
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (patients.length > 5)
            TextButton(
              onPressed: () {
                setState(() {
                  showAllPatients = !showAllPatients;
                });
              },
              child: Text(showAllPatients ? 'See less' : 'See more'),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Details extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String profileImage;

  const Details({
    Key? key,
    required this.doctorId,
    required this.patientId,
    required this.profileImage,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<Map<String, dynamic>> _patientDetailsFuture;
  String selectedWalkTest = 'walk1';
  bool walk1Saved = false;
  bool walk2Saved = false;
  bool walk3Saved = false;

  TextEditingController walk1Controller = TextEditingController();
  TextEditingController walk2Controller = TextEditingController();
  TextEditingController walk3Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _patientDetailsFuture = fetchPatientDetails();
  }

  Future<Map<String, dynamic>> fetchPatientDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.47.82/pulmonary/GetPatientDetails.php?patientId=${widget.patientId}'));
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'error') {
          Fluttertoast.showToast(msg: data['message']);
          return {};
        } else {
          setState(() {
            walk1Saved = data['walk1'] != null && data['walk1'].isNotEmpty;
            walk2Saved = data['walk2'] != null && data['walk2'].isNotEmpty;
            walk3Saved = data['walk3'] != null && data['walk3'].isNotEmpty;
            walk1Controller.text = data['walk1'] ?? '';
            walk2Controller.text = data['walk2'] ?? '';
            walk3Controller.text = data['walk3'] ?? '';
          });
          return data;
        }
      } else {
        throw Exception('Failed to load patient details');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'An error occurred while fetching details.');
      return {};
    }
  }

  Future<void> handleSave() async {
    final body = {
      'patientId': widget.patientId,
    };

    // Add walk data to the request body based on the selected test
    if (selectedWalkTest == 'walk1' && !walk1Saved) {
      body['walk1'] = walk1Controller.text;
    } else if (selectedWalkTest == 'walk2' && walk1Saved && !walk2Saved) {
      body['walk2'] = walk2Controller.text;
    } else if (selectedWalkTest == 'walk3' && walk1Saved && walk2Saved && !walk3Saved) {
      body['walk3'] = walk3Controller.text;
    } else {
      Fluttertoast.showToast(msg: 'Please save previous fields first.');
      return;
    }

    // Prevent saving if any walk is already saved
    if (selectedWalkTest == 'walk1' && walk1Saved) {
      Fluttertoast.showToast(msg: 'Walk 1 has already been filled.');
      return;
    } else if (selectedWalkTest == 'walk2' && walk2Saved) {
      Fluttertoast.showToast(msg: 'Walk 2 has already been filled.');
      return;
    } else if (selectedWalkTest == 'walk3' && walk3Saved) {
      Fluttertoast.showToast(msg: 'Walk 3 has already been filled.');
      return;
    }

    // Send the data to the PHP endpoint to save the details
    final response = await http.post(
      Uri.parse('http://192.168.47.82/pulmonary/SavePatientDetails.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    final data = json.decode(response.body);

    // Handle the response based on the success or failure
    if (data['status'] == 'success') {
      setState(() {
        if (selectedWalkTest == 'walk1') walk1Saved = true;
        if (selectedWalkTest == 'walk2') walk2Saved = true;
        if (selectedWalkTest == 'walk3') walk3Saved = true;
      });
      Fluttertoast.showToast(msg: '${selectedWalkTest.toUpperCase()} updated successfully.');
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _patientDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data ?? {};
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.network(widget.profileImage),
                        Text('Doctor ID: ${widget.doctorId}'),
                        Text('Patient ID: ${widget.patientId}'),
                        SizedBox(height: 20.0),
                        Text('Username: ${data['username'] ?? 'N/A'}'),
                        Text('Age: ${data['age'] ?? 'N/A'}'),
                        Text('Gender: ${data['gender'] ?? 'N/A'}'),
                        Text('Alcoholic: ${data['alcoholic'] ?? 'N/A'}'),
                        Text('Smoker: ${data['smoker'] ?? 'N/A'}'),
                        Text('Tobacco: ${data['tobacco'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  DropdownButton<String>(
                    value: selectedWalkTest,
                    items: [
                      DropdownMenuItem(value: 'walk1', child: Text('Walk 1')),
                      DropdownMenuItem(value: 'walk2', child: Text('Walk 2')),
                      DropdownMenuItem(value: 'walk3', child: Text('Walk 3')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedWalkTest = value!;
                      });
                    },
                  ),
                  TextFormField(
                    controller: walk1Controller,
                    decoration: InputDecoration(labelText: 'Walk 1'),
                    enabled: !walk1Saved,
                  ),
                  TextFormField(
                    controller: walk2Controller,
                    decoration: InputDecoration(labelText: 'Walk 2'),
                    enabled: !walk2Saved && walk1Saved,
                  ),
                  TextFormField(
                    controller: walk3Controller,
                    decoration: InputDecoration(labelText: 'Walk 3'),
                    enabled: !walk3Saved && walk2Saved,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: handleSave,
                    child: Text('Save'),
                  ),
                  // Add buttons to navigate to the Requirement and Pefr screens
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Requirement screen and pass the patientId
                      Navigator.pushNamed(
                        context,
                        '/requirement', // Ensure you have this route in your navigation setup
                        arguments: widget.patientId,
                      );
                    },
                    child: Text('Patient Requirement'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Pefr screen and pass the patientId
                      Navigator.pushNamed(
                        context,
                        '/pefr', // Ensure you have this route in your navigation setup
                        arguments: widget.patientId,
                      );
                    },
                    child: Text('PEFR'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

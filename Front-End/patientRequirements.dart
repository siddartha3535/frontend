import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PatientRequirements extends StatefulWidget {
  @override
  _PatientRequirementsState createState() => _PatientRequirementsState();
}

class _PatientRequirementsState extends State<PatientRequirements> {
  String patientId = 'Unknown';
  List<Map<String, dynamic>> requirements = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch arguments
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    patientId = arguments['PatientId'] ?? 'Unknown';

    // Fetch requirements
    fetchRequirements(patientId);
  }

  Future<void> fetchRequirements(String patientId) async {
    final url = Uri.parse('http://192.168.47.82/pulmonary/prequire.php?PatientId=$patientId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          setState(() {
            requirements = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Patient Requirements',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(
          child: Text(
            'Error: $errorMessage',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        )
            : requirements.isEmpty
            ? Center(
          child: Text(
            'No requirements found for Patient ID: $patientId',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: requirements.length,
          itemBuilder: (context, index) {
            final requirement = requirements[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  'Requirement ${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                subtitle: Text(
                  requirement['requirement1'] ?? 'No details available',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

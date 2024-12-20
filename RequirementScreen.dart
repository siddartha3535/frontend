import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequirementScreen extends StatefulWidget {
  @override
  _RequirementScreenState createState() => _RequirementScreenState();
}

class _RequirementScreenState extends State<RequirementScreen> {
  final TextEditingController _requirementController = TextEditingController();

  final String apiBaseUrl = 'http://192.168.47.82/pulmonary'; // Corrected API Base URL

  Future<void> _saveRequirement(String patientId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/require.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'patientId': patientId,
          'requirement1': _requirementController.text,
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Requirement saved successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save requirement.')),
        );
      }
    } catch (error) {
      print('Error saving requirement: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving requirement.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String patientId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Patient Requirement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Patient ID: $patientId',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _requirementController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Enter patient requirement...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveRequirement(patientId),
              child: Text('Save Requirement'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _requirementController.dispose();
    super.dispose();
  }
}

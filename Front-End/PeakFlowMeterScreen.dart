import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Peak Flow Meter Screen
class PeakFlowMeterScreen extends StatefulWidget {
  @override
  _PeakFlowMeterScreenState createState() => _PeakFlowMeterScreenState();
}

class _PeakFlowMeterScreenState extends State<PeakFlowMeterScreen> {
  final TextEditingController _pefrController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = arguments['PatientId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Peak Flow Meter'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title
              Text(
                'Patient ID: $patientId',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),

              // Date Picker Section
              Text(
                'Select Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_selectedDate.toLocal()}'.split(' ')[0],
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Select'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Time Picker Section
              Text(
                'Select Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedTime.format(context),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null && pickedTime != _selectedTime) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Select'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // PEFR Value Input
              TextField(
                controller: _pefrController,
                decoration: InputDecoration(
                  labelText: 'PEFR Value',
                  labelStyle: TextStyle(color: Colors.teal),
                  hintText: 'Enter the PEFR value',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    final data = {
                      'PatientId': patientId,
                      'pefr': _pefrController.text,
                      'date': _selectedDate.toIso8601String().split('T')[0], // Date in ISO format
                      'time': '${_selectedTime.hour}:${_selectedTime.minute}', // Time format HH:MM
                    };

                    // Send POST request to PHP endpoint (Replace with your URL)
                    final response = await http.post(
                      Uri.parse('http://192.168.47.82/pulmonary/peak.php'), // Replace with actual URL
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode(data),
                    );

                    if (response.statusCode == 200) {
                      final responseData = json.decode(response.body);
                      if (responseData['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Data submitted successfully!'),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error: ${responseData['message']}'),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to submit data!'),
                      ));
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

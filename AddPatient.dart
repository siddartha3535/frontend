import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPatient extends StatefulWidget {
  final String doctorId;

  const AddPatient({required this.doctorId});

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? _image;
  String patientId = '';
  String name = '';
  String phoneNumber = '';
  String age = '';
  String gender = '';
  String address = '';
  String email = '';
  String password = '';
  bool alcoholic = false;
  bool smoker = false;
  bool tobacco = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.47.82/pulmonary/addpatient.php'),
      );

      // Add the form fields
      request.fields['patientId'] = patientId;
      request.fields['name'] = name;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['age'] = age;
      request.fields['gender'] = gender;
      request.fields['address'] = address;
      request.fields['emailid'] = email;
      request.fields['password'] = password;
      request.fields['alcoholic'] = alcoholic.toString();
      request.fields['smoker'] = smoker.toString();
      request.fields['tobacco'] = tobacco.toString();
      request.fields['doctorId'] = widget.doctorId;

      // Attach the image if selected
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      // Send the request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = json.decode(responseData);

        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Patient added successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Failed to add patient.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Unable to add patient.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Patient')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Patient ID', (value) => patientId = value),
              _buildTextField('Name', (value) => name = value),
              _buildTextField('Phone Number', (value) => phoneNumber = value, isNumeric: true),
              _buildTextField('Age', (value) => age = value, isNumeric: true),
              _buildTextField('Gender', (value) => gender = value),
              _buildTextField('Address', (value) => address = value),
              _buildTextField('Email', (value) => email = value),
              _buildTextField('Password', (value) => password = value, obscureText: true),
              SwitchListTile(
                title: Text('Alcoholic'),
                value: alcoholic,
                onChanged: (value) => setState(() => alcoholic = value),
              ),
              SwitchListTile(
                title: Text('Smoker'),
                value: smoker,
                onChanged: (value) => setState(() => smoker = value),
              ),
              SwitchListTile(
                title: Text('Tobacco'),
                value: tobacco,
                onChanged: (value) => setState(() => tobacco = value),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved,
      {bool isNumeric = false, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }
}

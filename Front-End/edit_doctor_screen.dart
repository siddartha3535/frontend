import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class EditDoctorDetails extends StatefulWidget {
  final Map<String, dynamic> doctorDetails;

  EditDoctorDetails({required this.doctorDetails});

  @override
  _EditDoctorDetailsState createState() => _EditDoctorDetailsState();
}

class _EditDoctorDetailsState extends State<EditDoctorDetails> {
  late Map<String, dynamic> doctor;
  late TextEditingController doctorNameController;
  late TextEditingController specializationController;
  late TextEditingController experienceController;
  late TextEditingController ageController;
  late TextEditingController mobileController;
  late TextEditingController genderController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    doctor = widget.doctorDetails;
    doctorNameController = TextEditingController(text: doctor['doctorname']);
    specializationController = TextEditingController(text: doctor['specialization']);
    experienceController = TextEditingController(text: doctor['experience'].toString());
    ageController = TextEditingController(text: doctor['age'].toString());
    mobileController = TextEditingController(text: doctor['mobile']);
    genderController = TextEditingController(text: doctor['gender']);
    emailController = TextEditingController(text: doctor['gmail']);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Future<void> handleSubmit() async {
    final uri = Uri.parse('http://192.168.47.82/pulmonary/updatedoctorprofile.php');
    final request = http.MultipartRequest('POST', uri);

    request.fields['doctorId'] = doctor['doctorId'].toString();
    request.fields['doctorname'] = doctorNameController.text;
    request.fields['specialization'] = specializationController.text;
    request.fields['experience'] = experienceController.text;
    request.fields['age'] = ageController.text;
    request.fields['mobile'] = mobileController.text;
    request.fields['gender'] = genderController.text;
    request.fields['gmail'] = emailController.text;
    request.fields['password'] = passwordController.text;
    request.fields['confirmpassword'] = confirmPasswordController.text;

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath!));
    } else if (doctor['image'] != null) {
      request.fields['image'] = doctor['image'];
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Details updated successfully')));

      // Update the local doctor map with the new details
      doctor['doctorname'] = doctorNameController.text;
      doctor['specialization'] = specializationController.text;
      doctor['experience'] = int.parse(experienceController.text);
      doctor['age'] = int.parse(ageController.text);
      doctor['mobile'] = mobileController.text;
      doctor['gender'] = genderController.text;
      doctor['gmail'] = emailController.text;

      // Navigate back with the updated doctor details
      Navigator.pop(context, doctor);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update details')));
    }
  }

  Widget buildInputField(String label, TextEditingController controller, {TextInputType? keyboardType, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Doctor Details'),
        backgroundColor: Colors.grey[500],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imagePath != null
                      ? FileImage(File(imagePath!))
                      : (doctor['image'] != null ? NetworkImage(doctor['image']) : null),
                  backgroundColor: Colors.grey[300],
                  child: (imagePath == null && doctor['image'] == null)
                      ? Icon(Icons.image, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              buildInputField("Name:", doctorNameController),
              buildInputField("Specialization:", specializationController),
              buildInputField("Experience:", experienceController, keyboardType: TextInputType.number),
              buildInputField("Age:", ageController, keyboardType: TextInputType.number),
              buildInputField("Mobile:", mobileController, keyboardType: TextInputType.phone),
              buildInputField("Gender:", genderController),
              buildInputField("Email:", emailController, keyboardType: TextInputType.emailAddress),
              buildInputField("Password:", passwordController, obscureText: true),
              buildInputField("Confirm Password:", confirmPasswordController, obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[500],
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                child: Text('Update Details', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back without returning any updated details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[500],
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                child: Text('Back', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

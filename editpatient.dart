import 'package:flutter/material.dart';

class editpatient extends StatefulWidget {
  @override
  _editpatientState createState() => _editpatientState();
}

class _editpatientState extends State<editpatient> {
  late Map<String, dynamic> patientDetails;
  String? imageUrl; // Make it nullable

  // Controllers for form fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _alcoholController = TextEditingController();
  TextEditingController _smokerController = TextEditingController();
  TextEditingController _tobaccoController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Receiving patient data passed from the Profile screen
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    patientDetails = arguments['patientDetails'];

    // Initialize controllers with patient data
    _nameController.text = patientDetails['username'];
    _ageController.text = patientDetails['age'].toString();
    _genderController.text = patientDetails['gender'];
    _phoneController.text = patientDetails['phonenumber'];
    _emailController.text = patientDetails['emailid'];
    _addressController.text = patientDetails['Address'];
    _alcoholController.text = patientDetails['alcoholic'];
    _smokerController.text = patientDetails['smoker'];
    _tobaccoController.text = patientDetails['tobacco'];

    // Initialize imageUrl to the URL returned from your backend or set null if not available
    imageUrl = patientDetails['image_url'] ?? null; // Default to null if no image
  }

  @override
  void dispose() {
    // Dispose of controllers when screen is disposed
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _alcoholController.dispose();
    _smokerController.dispose();
    _tobaccoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Patient Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Display the patient image if available
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                imageUrl!,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Image is loaded
                  } else {
                    return Center(child: CircularProgressIndicator()); // Show loading indicator
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/placeholder.jpg'); // Fallback image in case of error
                },
              ),
            // Name TextField
            buildTextField(_nameController, 'Name'),
            // Age TextField
            buildTextField(_ageController, 'Age'),
            // Gender TextField
            buildTextField(_genderController, 'Gender'),
            // Phone TextField
            buildTextField(_phoneController, 'Phone'),
            // Email TextField
            buildTextField(_emailController, 'Email'),
            // Address TextField
            buildTextField(_addressController, 'Address'),
            // Alcoholic TextField
            buildTextField(_alcoholController, 'Alcoholic'),
            // Smoker TextField
            buildTextField(_smokerController, 'Smoker'),
            // Tobacco TextField
            buildTextField(_tobaccoController, 'Tobacco User'),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle Save action (e.g., update patient details)
                // Here you can call an API to save the updated data or just print the details
                print('Updated Patient Details:');
                print({
                  'name': _nameController.text,
                  'age': _ageController.text,
                  'gender': _genderController.text,
                  'phone': _phoneController.text,
                  'email': _emailController.text,
                  'address': _addressController.text,
                  'alcoholic': _alcoholController.text,
                  'smoker': _smokerController.text,
                  'tobacco': _tobaccoController.text,
                });
              },
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build TextFields for the form
  Widget buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

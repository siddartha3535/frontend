import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Doctor Image
              CircleAvatar(
                radius: width * 0.2,
                backgroundImage: NetworkImage(
                    'https://img.freepik.com/premium-photo/animated-female-doctor-character_982269-293.jpg'),
              ),
              SizedBox(height: height * 0.02),

              // Doctor Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/DoctorLogin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD74444),
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.02, horizontal: width * 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                ),
                child: Text(
                  'Doctor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              // Patient Image
              CircleAvatar(
                radius: width * 0.2,
                backgroundImage: NetworkImage(
                    'https://img.freepik.com/premium-photo/animated-female-doctor-character_982269-293.jpg'),
              ),
              SizedBox(height: height * 0.02),

              // Patient Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/PatientLogin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD74444),
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.02, horizontal: width * 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                ),
                child: Text(
                  'Patient',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold,
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

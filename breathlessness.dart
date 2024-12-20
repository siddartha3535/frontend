import 'package:flutter/material.dart';

class Breathlessness extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments from the navigation route
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = arguments['PatientId']; // Extract the PatientId
    final username = arguments['username']; // Extract the username

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.05),
        child: Column(
          children: [
            Header(title: "Patient ID: $patientId"), // Display PatientId in the header
            SizedBox(height: height * 0.05),
            Center(
              child: CircleAvatar(
                radius: width * 0.2,
                backgroundImage: NetworkImage(
                  'https://thumbs.dreamstime.com/z/shortness-breath-person-breathing-problem-asthma-shortness-breath-person-breathing-problem-asthma-disease-symptom-160462759.jpg',
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Are You Suffering From Breathlessness?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width * 0.05),
              ),
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Questionaries', arguments: {
                      'PatientId': patientId, // Pass PatientId to next screen
                      'username': username,  // Pass username to next screen
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF239E27),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08,
                      vertical: height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/ChestPain', arguments: {
                      'PatientId': patientId, // Pass PatientId to Chest Pain screen
                      'username': username,  // Pass username to Chest Pain screen
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD20202),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08,
                      vertical: height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;

  Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

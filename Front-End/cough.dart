import 'package:flutter/material.dart';

class Cough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the PatientId from the navigation arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = arguments['PatientId']; // Extract PatientId
    final username = arguments['username']; // Extract the username

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.05),
        child: Column(
          children: [
            Header(title: "Cough - Patient ID: $patientId"),
            SizedBox(height: height * 0.05),
            Center(
              child: CircleAvatar(
                radius: width * 0.2,
                backgroundImage: NetworkImage(
                  'https://t3.ftcdn.net/jpg/03/10/11/70/360_F_310117075_pn44xY7Mk8y6Qn5DGEY3OD3oBG4maFzG.jpg',
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
                'Are You Suffering From Cough?',
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
                    print("Navigating to Cough1 screen");
                    Navigator.pushNamed(
                      context,
                      '/Cough1',
                      arguments: {
                        'PatientId': patientId,
                        'username': username, // Pass username as well
// Pass PatientId to Cough1 screen
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF239E27),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.015,
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
                    print("Navigating to Fever screen");
                    Navigator.pushNamed(
                      context,
                      '/Fever',
                      arguments: {
                        'PatientId': patientId,
                        'username': username, // Pass username as well
// Pass PatientId to Fever screen
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD20202),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.015,
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

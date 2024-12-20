import 'package:flutter/material.dart';

class ChestPain extends StatelessWidget {
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
            Header(title: "Chest Pain - Patient ID: $patientId"),
            SizedBox(height: height * 0.05),
            Center(
              child: CircleAvatar(
                radius: width * 0.2,
                backgroundImage: NetworkImage(
                  'https://img.freepik.com/premium-vector/young-man-feeling-chest-pain-heart-attack-colorful-flat-illustration-isolated-white-background_276366-397.jpg',
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
                'Are You Suffering Chest Pain?',
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
                    print("Navigating to Cough screen");
                    Navigator.pushNamed(
                      context,
                      '/Cough',
                      arguments: {
                        'PatientId': patientId,
                        'username': username, // Pass username as well
// Pass PatientId to Cough screen
                      },
                    );
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

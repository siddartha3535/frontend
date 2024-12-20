import 'package:flutter/material.dart';

class Fever extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve PatientId and username from navigation arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = arguments['PatientId']; // Extract PatientId
    final username = arguments['username']; // Extract username

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.05),
        child: Column(
          children: [
            // Header displaying PatientId and username
            Container(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: Text(
                "Patient ID: $patientId\nUsername: $username",
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Image Container
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.025),
              child: Center(
                child: CircleAvatar(
                  radius: width * 0.2,
                  backgroundImage: NetworkImage(
                    'https://png.pngtree.com/png-clipart/20210829/original/pngtree-sick-hand-drawn-cartoon-elements-png-image_6676984.jpg',
                  ),
                ),
              ),
            ),

            // Question Container
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.02,
                  ),
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  child: Text(
                    "Are You Suffering From Fever?",
                    style: TextStyle(
                      fontSize: width * 0.05,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Button Container
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF239E27),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.015,
                          horizontal: width * 0.07,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to the Consult screen and pass PatientId and username
                        Navigator.pushNamed(
                          context,
                          '/Consult',
                          arguments: {
                            'PatientId': patientId,
                            'username': username,
                          },
                        );
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD20202),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.015,
                          horizontal: width * 0.07,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Navigate back to the main menu and pass PatientId and username
                        Navigator.pushNamed(
                          context,
                          '/BackMainMenu',
                          arguments: {
                            'PatientId': patientId,
                            'username': username,
                          },
                        );
                      },
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


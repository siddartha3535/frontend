import 'package:flutter/material.dart';

class BloodStained extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed during navigation
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final patientId = arguments['PatientId'] ?? 'Unknown';
    final username = arguments['username'] ?? 'Guest'; // Extract username

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Blood Stained",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Image Container
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 25),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://media.istockphoto.com/id/1429520725/vector/woman-with-coughing-blood-in-flat-design-bleeding-cough-concept-vector-illustration.jpg?s=612x612&w=0&k=20&c=6mTsr04JP6UzCpjkcyzJcMoJ3_BXY3sryBbuS3yxa6A=',
                    ),
                  ),
                ),
              ),
            ),

            // Question Container
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Blood Stained",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF239E27), // Green
                          padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: MediaQuery.of(context).size.width * 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
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
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD20202), // Red
                          padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: MediaQuery.of(context).size.width * 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/Fever',
                            arguments: {
                              'PatientId': patientId,
                              'username': username,
                            },
                          );
                        },
                        child: Text(
                          "No",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

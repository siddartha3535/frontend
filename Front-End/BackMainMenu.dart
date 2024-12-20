import 'package:flutter/material.dart';

class BackMainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed during navigation
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final patientId = arguments['PatientId'] ?? 'Unknown';
    final username = arguments['username'] ?? 'Guest'; // Extract username

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Back Main Menu"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.05),
        child: Column(
          children: [
            // Circular Image Container
            Center(
              child: Container(
                width: width * 0.45,
                height: width * 0.45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://www.directivegroup.com/wp-content/uploads/2017/03/smile-9047-9380-hd-wallpapers-1.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Patient ID Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Patient ID: $patientId',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            // Username Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Welcome, $username!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Text Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'You don’t have any symptoms. You can continue with your exercises.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.045,
                  ),
                ),
              ),
            ),

            SizedBox(height: 80),

            // Button Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/PatientDashboard',
                    arguments: {
                      'PatientId': patientId,
                      'username': username, // Pass username to the next screen
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD20202),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Back To Mainmenu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

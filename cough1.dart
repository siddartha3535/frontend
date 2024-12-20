import 'package:flutter/material.dart';

class Cough1 extends StatelessWidget {
  const Cough1({Key? key}) : super(key: key);

  void handleDoctorPress(BuildContext context, String patientId, String username) {
    print('Wet Cough button pressed');
    // Navigate to Fever page and pass PatientId and username
    Navigator.pushNamed(
      context,
      '/Fever',
      arguments: {'PatientId': patientId, 'username': username},
    );
  }

  void handlePatientPress(BuildContext context, String patientId, String username) {
    print('Dry Cough button pressed');
    // Navigate to Fever page and pass PatientId and username
    Navigator.pushNamed(
      context,
      '/Fever',
      arguments: {'PatientId': patientId, 'username': username},
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve PatientId and username from navigation arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = arguments['PatientId']; // Extract PatientId
    final username = arguments['username']; // Extract the username

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cough Symptoms - Patient ID: $patientId'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.07),
            Center(
              child: Column(
                children: [
                  Container(
                    width: width * 0.4,
                    height: width * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://buzzrx.s3.amazonaws.com/ed0af48f-36d6-40fb-a2b1-fb78a796ba17/DryCoughRemediesYouNeedToKnow.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(width * 0.4 / 2),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => handleDoctorPress(context, patientId, username),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.016, horizontal: width * 0.09),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD20202),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      child: Text(
                        'Wet Cough',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.4,
                    height: width * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://cms.buzzrx.com/globalassets/buzzrx/blogs/wet-cough-vs-dry-cough--what-to-know.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(width * 0.4 / 2),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => handlePatientPress(context, patientId, username),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.016, horizontal: width * 0.09),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD20202),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      child: Text(
                        'Dry Cough',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                '/BloodStained',
                arguments: {'PatientId': patientId, 'username': username}, // Pass PatientId and username
              ),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.01),
                child: Text(
                  'Phlegm?',
                  style: TextStyle(
                    fontSize: width * 0.045,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
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

import 'package:flutter/material.dart';

class PatientDashboardViewAll extends StatelessWidget {
  void handleButtonPress(BuildContext context, int buttonIndex) {
    switch (buttonIndex) {
      case 1:
        Navigator.pushNamed(context, '/V1');
        break;
      case 2:
        Navigator.pushNamed(context, '/V2');
        break;
      case 3:
        Navigator.pushNamed(context, '/V3');
        break;
      case 4:
        Navigator.pushNamed(context, '/V4');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
        backgroundColor: Color(0xFF2196F3),  // AppBar color
        elevation: 4.0,  // Subtle shadow effect for AppBar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: Column(
          children: [
            _buildImageCard(
              context,
              'https://static.vecteezy.com/system/resources/previews/004/568/588/original/gym-exercise-semi-flat-color-character-set-posing-figures-full-body-people-on-white-fitness-isolated-modern-cartoon-style-illustration-for-graphic-design-and-animation-collection-vector.jpg',
              'Exercise set-1',
              1,
            ),
            _buildImageCard(
              context,
              'https://us.123rf.com/450wm/yupiramos/yupiramos1912/yupiramos191200437/134572770-women-training-yoga-meditation-position-with-bushes-plants-vector-illustration.jpg?ver=6',
              'Exercise set-2',
              2,
            ),
            _buildImageCard(
              context,
              'https://img.freepik.com/free-vector/set-women-training-bodies-gym-girls-exercising-with-ball_1262-19943.jpg?w=360',
              'Exercise set-3',
              3,
            ),
            _buildImageCard(
              context,
              'https://img.freepik.com/free-vector/young-women-exercising-flat-illustration-set_107791-14287.jpg?size=626&ext=jpg&ga=GA1.1.1700460183.1713225600&semt=sph',
              'Exercise set-4',
              4,
            ),
          ],
        ),
      ),
    );
  }

  // Refined image card with smooth corners, shadows, and modern design
  Widget _buildImageCard(BuildContext context, String imageUrl, String buttonText, int buttonIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.022),
      child: Column(
        children: [
          // Image with rounded corners and subtle shadow
          ClipRRect(
            borderRadius: BorderRadius.circular(16),  // Smooth corners for the image
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width * 0.999,  // Slight margin for better spacing
              height: MediaQuery.of(context).size.height * 0.25,  // Adjusted height for better aspect ratio
              fit: BoxFit.contain,  // Ensures the image covers the area without distortion
            ),
          ),
          // Button Container with improved design and shadows
          GestureDetector(
            onTap: () => handleButtonPress(context, buttonIndex),
            child: Container(
              margin: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Color(0xFFD74444),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

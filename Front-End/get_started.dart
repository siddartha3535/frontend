import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetStartedContent(),
    );
  }
}

class GetStartedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Container(
            margin: EdgeInsets.only(bottom: height * 0.1),
            child: Text(
              'Optimizing Pulmonary Recovery For Pneumonia',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Circular container with image
          Container(
            width: width * 0.5,
            height: width * 0.5,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(width * 0.25),
            ),
            margin: EdgeInsets.only(bottom: height * 0.1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(width * 0.25),
              child: Image.network(
                'https://static.vecteezy.com/system/resources/previews/015/601/345/non_2x/human-internal-organ-with-lungs-cartoon-flat-icon-illustration-isolated-on-white-background-free-vector.jpg',
                fit: BoxFit.cover,
                width: width * 0.45,
                height: width * 0.45,
              ),
            ),
          ),
          // Get Started Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/main');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD74444),
              padding: EdgeInsets.symmetric(
                vertical: height * 0.02,
                horizontal: width * 0.1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
            ),
            child: Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

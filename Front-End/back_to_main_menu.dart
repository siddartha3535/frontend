import 'package:flutter/material.dart';

class BackMainMenu extends StatelessWidget {
  final Function(String) navigateTo;

  const BackMainMenu({Key? key, required this.navigateTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              const Header(title: " "),  // Header with no title

              // Image Container
              Container(
                margin: const EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.network(
                    'https://www.directivegroup.com/wp-content/uploads/2017/03/smile-9047-9380-hd-wallpapers-1.jpg',
                    width: width * 0.45,
                    height: width * 0.45,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: width * 0.45,
                        height: width * 0.45,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      width: width * 0.45,
                      height: width * 0.45,
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              ),

              // Text Container
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: width * 0.9,
                child: Text(
                  "You don’t have any symptoms you can continue with your exercises",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.045,
                  ),
                ),
              ),

              // Button Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD20202),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Pass the route to the navigateTo function
                    navigateTo('PatientDashboard');  // Modify this line as needed
                  },
                  child: Text(
                    "Back To Mainmenu",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: Colors.white,
                    ),
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

class Header extends StatelessWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

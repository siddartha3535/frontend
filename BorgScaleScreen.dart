import 'package:flutter/material.dart';

class BorgScaleScreen extends StatefulWidget {
  @override
  _BorgScaleScreenState createState() => _BorgScaleScreenState();
}

class _BorgScaleScreenState extends State<BorgScaleScreen> {
  String? selectedButton;
  late String patientId;
  late String username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    patientId = arguments?['PatientId'] ?? 'Unknown';
    username = arguments?['username'] ?? 'Guest';  // Extract username
  }

  final List<Map<String, dynamic>> buttons = [
    {'label': 'Rest', 'color': Color(0xFF0BC1C1)},
    {'label': 'Really Easy', 'color': Color(0xFF18D6B4)},
    {'label': 'Easy', 'color': Color(0xFF29C3D8)},
    {'label': 'Little Easy', 'color': Color(0xFF239E27)},
    {'label': 'Moderate', 'color': Color(0xFF30C423)},
    {'label': 'Sort of Hard', 'color': Color(0xFF239E27)},
    {'label': 'Hard', 'color': Color(0xFFC3C62E)},
    {'label': 'Really Hard', 'color': Color(0xFFEB7A73)},
    {'label': 'Really Very Hard', 'color': Color(0xFFF83B00)},
    {'label': 'Critical', 'color': Color(0xFFD20202)},
  ];

  void handleButtonClick(String label) {
    setState(() {
      selectedButton = label;
    });
  }

  void handleSubmit() {
    if (selectedButton == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a Borg scale option.')),
      );
      return;
    }

    if (['Hard', 'Really Hard', 'Really Very Hard', 'Critical'].contains(selectedButton)) {
      Navigator.pushNamed(context, '/Consult', arguments: {'PatientId': patientId, 'username': username});
    } else {
      Navigator.pushNamed(context, '/BackMainMenu', arguments: {'PatientId': patientId, 'username': username});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Borg Scale of Exertion'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Borg Scale of Exertion',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Display username
            Text(
              'Welcome, $username!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Borg Buttons
            Expanded(
              child: ListView.builder(
                itemCount: buttons.length,
                itemBuilder: (context, index) {
                  final button = buttons[index];
                  return GestureDetector(
                    onTap: () => handleButtonClick(button['label']),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: screenSize.height * 0.07,
                      decoration: BoxDecoration(
                        color: button['color'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          button['label'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Selected Button Text
            if (selectedButton != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Selected: $selectedButton',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            // Submit Button
            GestureDetector(
              onTap: handleSubmit,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

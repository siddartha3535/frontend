import 'package:flutter/material.dart';

class Questionaries extends StatefulWidget {
  @override
  _QuestionariesState createState() => _QuestionariesState();
}

class _QuestionariesState extends State<Questionaries> {
  final List<Map<String, dynamic>> questions = [
    {'text': 'No breathlessness except on strenuous exercise?', 'score': 0},
    {
      'text': 'Breathlessness when hurrying on the level or walking up a slight hill?',
      'score': 0
    },
    {
      'text': 'Walks slower than people of the same age on the level because of breathlessness?',
      'score': 0
    },
    {
      'text': 'Too breathless to leave the house, or breathless when dressing or undressing?',
      'score': 0
    },
    {
      'text': 'Stops for breath after walking ∼100 m or after a few minutes on the level plane?',
      'score': 0
    },
  ];

  void handleAnswer(int index, String answer) {
    setState(() {
      questions[index]['score'] = answer == 'Yes' ? 1 : 0;
    });
  }

  int get totalScore =>
      questions.fold<int>(0, (int sum, question) {
        return sum +
            (question['score'] as int); // Ensure score is treated as int
      });

  void handleNext(BuildContext context, String patientId, String username) {
    if (totalScore <= 2) {
      Navigator.pushNamed(context, '/ChestPain', arguments: {
        'PatientId': patientId, // Pass PatientId to Chest Pain screen
        'username': username, // Pass username as well
      });
    } else if (totalScore >= 3) {
      Navigator.pushNamed(context, '/Consult', arguments: {
        'PatientId': patientId, // Pass PatientId to Consult screen
        'username': username, // Pass username as well
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the PatientId and username from the navigation arguments
    final arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    final patientId = arguments['PatientId']; // Extract PatientId
    final username = arguments['username']; // Extract the username

    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Questionaries - Patient ID: $patientId'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Answer the following questions:',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                padding: EdgeInsets.all(width * 0.03),
                child: Column(
                  children: questions
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> question = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.04),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(width * 0.02),
                            ),
                            child: Text(
                              question['text'],
                              style: TextStyle(
                                fontSize: width * 0.04,
                                height: height * 0.0025,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        width * 0.02),
                                  ),
                                ),
                                onPressed: () => handleAnswer(index, 'Yes'),
                                child: Text('Yes',
                                    style: TextStyle(fontSize: width * 0.04)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        width * 0.02),
                                  ),
                                ),
                                onPressed: () => handleAnswer(index, 'No'),
                                child: Text('No',
                                    style: TextStyle(fontSize: width * 0.04)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Total Score: $totalScore',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.02),
              ElevatedButton(
                onPressed: () => handleNext(context, patientId, username),
                child: Text('Next', style: TextStyle(fontSize: width * 0.04)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'get_started.dart';            // Import GetStarted screen
import 'main_screen.dart' as main_screen;  // Import MainScreen
import 'patient_login.dart';         // Import PatientLogin screen
import 'doctor_login.dart';          // Import DoctorLogin screen
import 'patient_dashboard.dart';     // Import PatientDashboard screen
import 'doctor_dashboard.dart';      // Import DoctorDashboard screen
import 'breathlessness.dart';        // Import Breathlessness screen
import 'questionaries.dart';         // Import Questionaries screen
import 'chestpain.dart';             // Import ChestPain screen
import 'cough.dart';                 // Import Cough screen
import 'cough1.dart';                // Import Cough1 screen
import 'blood_stained.dart';         // Import BloodStained screen
import 'fever.dart';                 // Import Fever screen
import 'DoctorProfile.dart';         // Import DoctorProfile screen
import 'DoctorDashboardViewAll.dart';  // Import DoctorDashboardViewAll screen
import 'AddPatient.dart';            // Import AddPatient screen
import 'Details.dart';               // Import Details screen
import 'RequirementScreen.dart';     // Import RequirementScreen screen
import 'PefrScreen.dart';            // Import PefrScreen screen
import 'AddVideoScreen.dart';        // Import AddVideoScreen screen
import 'VideoListScreen.dart';       // Import VideoListScreen screen
import 'Consult.dart';       // Import VideoListScreen screen
import 'BackMainMenu.dart';       // Import VideoListScreen screen
import 'patientRequirements.dart';       // Import VideoListScreen screen
import 'BorgScaleScreen.dart';       // Import VideoListScreen screen
import 'PeakFlowMeterScreen.dart';       // Import VideoListScreen screen
import 'V1.dart';       // Import VideoListScreen screen
import 'V2.dart';       // Import VideoListScreen screen
import 'V3.dart';       // Import VideoListScreen screen
import 'V4.dart';       // Import VideoListScreen screen
import 'PatientDashboardViewAll.dart';       // Import VideoListScreen screen
import 'profile.dart';       // Import VideoListScreen screen
import 'editpatient.dart';       // Import VideoListScreen screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulmocare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,  // Remove the debug banner
      initialRoute: '/',  // Starting screen
      routes: {
        '/': (context) => GetStarted(),  // Home screen (e.g., Introduction or splash)
        '/main': (context) => main_screen.MainScreen(),  // Main screen (e.g., after splash)
        '/PatientLogin': (context) => PatientLogin(),  // Patient login screen
        '/DoctorLogin': (context) => DoctorLogin(),    // Doctor login screen
        '/PatientDashboard': (context) => PatientDashboard(), // Patient dashboard
        '/BorgScaleScreen': (context) => BorgScaleScreen(), // Patient dashboard

        '/Details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return Details(
            doctorId: args['doctorId'] ?? 'Unknown',
            patientId: args['patientId'] ?? 'Unknown',
            profileImage: args['profileImage'] ?? '',
          );
        },
        '/AddPatient': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AddPatient(
            doctorId: (args['doctorId'] ?? 'Unknown').toString(), // Convert and ensure String type
          );
        },
        '/DoctorDashboard': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DoctorDashboard(
            doctorId: args['doctorId'] ?? 'Unknown',  // Provide default if null
            doctorName: args['doctorName'] ?? 'Unknown',  // Provide default if null
          );
        },
        '/Breathlessness': (context) => Breathlessness(),  // Breathlessness screen
        '/Questionaries': (context) => Questionaries(),  // Questionaries screen
        '/ChestPain': (context) => ChestPain(),  // ChestPain screen
        '/Cough': (context) => Cough(),        // Cough screen
        '/Cough1': (context) => Cough1(),      // Cough1 screen
        '/BloodStained': (context) => BloodStained(),  // BloodStained screen
        '/Fever': (context) => Fever(),
        '/DoctorDashboardViewAll': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DoctorDashboardViewAll(
            doctorId: (args['doctorId'] ?? 'Unknown').toString(), // Convert and ensure String type
          );
        },
        '/DoctorProfile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DoctorProfile(
            doctorId: (args['doctorId'] ?? 'Unknown').toString(), // Convert and ensure String type
          );
        },
        '/requirement': (context) => RequirementScreen(),
        '/pefr': (context) => PefrScreen(),
        '/VideoListScreen': (context) => VideoListScreen(),
        '/Consult': (context) =>Consult(),
        '/BackMainMenu': (context) =>BackMainMenu(),
        '/PeakFlowMeterScreen': (context) =>PeakFlowMeterScreen(),
        '/patientRequirements': (context) =>PatientRequirements(),
        '/V1': (context) =>V1(),
        '/V2': (context) =>V2(),
        '/V3': (context) =>V3(),
        '/V4': (context) =>V4(),
        '/PatientDashboardViewAll': (context) =>PatientDashboardViewAll(),
        '/profile': (context) =>profile(),
        '/editpatient': (context) =>editpatient(),

      },
    );
  }
}

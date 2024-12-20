import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorDashboard extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  DoctorDashboard({required this.doctorId, required this.doctorName});

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  late List<dynamic> patients;
  bool modalVisible = false;

  @override
  void initState() {
    super.initState();
    patients = [];
    fetchPatients(); // Fetch patients data only once when the widget is initialized.
  }

  fetchPatients() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.47.82/pulmonary/DoctorDashboard.php?doctorId=${widget.doctorId}'),
      );
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          patients = data['data'];
        });
      } else {
        showError('Failed to fetch patients');
      }
    } catch (error) {
      showError('Failed to fetch patients');
    }
  }

  showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleLogoutPress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),  // Close the dialog
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                // Pop all routes from the stack and go to the login screen
                Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }



  void handleMenuPress(BuildContext context) {
    if (!modalVisible) { // Only open the drawer if it's not already open.
      setState(() {});
      Scaffold.of(context).openDrawer(); // Open the drawer
    }
  }

  void handleModalOptionPress(String screen) {
    setState(() {
      modalVisible = false; // Close the menu after selection
    });
    Navigator.pushNamed(context, screen, arguments: {'doctorId': widget.doctorId});
  }

  void handlePatientPress(String patientId, String profileImage) {
    Navigator.pushNamed(
      context,
      '/Details',
      arguments: {
        'patientId': patientId ?? 'Unknown Patient',
        'doctorId': widget.doctorId ?? 'Unknown Doctor',
        'profileImage': profileImage ?? 'https://example.com/default-image.jpg',
      },
    );
  }



  void handleVideoPress() {
    Navigator.pushNamed(context, '/VideoListScreen', arguments: {'doctorId': widget.doctorId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer (Left Side Menu)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Hello, ${widget.doctorName}',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFA4A4A4), // Custom red color for the drawer header
              ),
            ),
            ListTile(
              title: Text('Doctor Profile'),
              onTap: () => handleModalOptionPress('/DoctorProfile'),
            ),
            ListTile(
              title: Text('View All Patients'),
              onTap: () => handleModalOptionPress('/DoctorDashboardViewAll'),
            ),
            ListTile(
              title: Text('Add New Patient'),
              onTap: () => handleModalOptionPress('/AddPatient'),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: handleLogoutPress,
            ),
            ListTile(
              title: Text('Close Menu'),
              onTap: () {
                setState(() {
                  modalVisible = false; // Close the menu
                });
              },
            ),
          ],
        ),
      ),

      // AppBar (Header)
      appBar: AppBar(
        title: Text('Welcome, ${widget.doctorName}', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => handleMenuPress(context), // Open the menu
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: handleLogoutPress,
          ),
        ],
        backgroundColor: Color(0xFFA4A4A4), // Custom red color for the AppBar
      ),

      body: GestureDetector(
        // This gesture detector ensures no interaction happens when the menu is open
        onTap: () {
          if (modalVisible) {
            setState(() {
              modalVisible = false;
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Placeholder Image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  'https://cdni.iconscout.com/illustration/premium/thumb/doctor-checking-lungs-10746067-8705923.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ),

              // View All Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA4A4A4),  // Custom red color for the button
                      foregroundColor: Colors.white,       // Text color (onPrimary has been replaced with this)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => handleModalOptionPress('/DoctorDashboardViewAll'),
                    child: Text('View All', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),

              // Patients List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: patients.length > 8 ? 8 : patients.length, // Limit to 8 patients
                itemBuilder: (context, index) {
                  var patient = patients[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => handlePatientPress(patient['PatientId'].toString(), patient['image_path']),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(patient['image_path']),
                      ),
                      title: Text(patient['username'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Patient ID: ${patient['PatientId']}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Floating Action Buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/AddPatient', arguments: {'doctorId': widget.doctorId}),
            child: Icon(FontAwesomeIcons.plus),
            backgroundColor: Color(0xFFA4A4A4), // Custom red color for the button
          ),
          SizedBox(width: 20),
          FloatingActionButton(
            onPressed: handleVideoPress,
            child: Icon(FontAwesomeIcons.video),
            backgroundColor: Color(0xFFA4A4A4), // Custom red color for the button
          ),
          SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/DoctorProfile', arguments: {'doctorId': widget.doctorId}),
            child: Icon(FontAwesomeIcons.user),
            backgroundColor: Color(0xFFA4A4A4), // Custom red color for the button
          ),
        ],
      ),

      // Bottom Sheet Modal
      bottomSheet: modalVisible
          ? Container(
        color: Color(0xFFA4A4A4), // Custom red color for the bottom sheet
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextButton(
              onPressed: () => handleModalOptionPress('/DoctorProfile'),
              child: Text('Doctor Profile', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            TextButton(
              onPressed: () => handleModalOptionPress('/DoctorDashboardViewAll'),
              child: Text('View All Patients', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            TextButton(
              onPressed: () => handleModalOptionPress('/DoctorAddPatient'),
              child: Text('Add New Patient', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            TextButton(
              onPressed: handleLogoutPress,
              child: Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  modalVisible = false; // Close the modal
                });
              },
              child: Text('Close Menu', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      )
          : null,
    );
  }
}

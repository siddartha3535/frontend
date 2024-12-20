import 'package:flutter/material.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  late String patientId;
  late String username;

  // Centralized function to prepare arguments
  Map<String, dynamic> prepareArguments(String route) {
    return {
      'PatientId': patientId,
      'username': username,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Safely retrieve arguments from the route
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Safely assign values or provide default values
    patientId = arguments?['PatientId'] ?? 'Unknown';
    username = arguments?['username'] ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile', arguments: prepareArguments('/profile'));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Peak Flow Meter'),
              onTap: () {
                Navigator.pushNamed(context, '/PeakFlowMeterScreen', arguments: prepareArguments('/peakFlowMeter'));
              },
            ),
            ListTile(
              title: Text('Consult'),
              onTap: () {
                Navigator.pushNamed(context, '/Consult', arguments: prepareArguments('/consult'));
              },
            ),
            ListTile(
              title: Text('All Videos'),
              onTap: () {
                Navigator.pushNamed(context, '/PatientDashboardViewAll', arguments: prepareArguments('/PatientDashboardViewAll'));
              },
            ),
            ListTile(
              title: Text('Log out'),
              onTap: () {
                Navigator.pushNamed(context, '/main', arguments: prepareArguments('/main'));
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          // Scrollable Image View
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Image.network('https://i0.wp.com/www.biosciencetoday.co.uk/wp-content/uploads/2023/04/AdobeStock_575225072.jpeg?fit=1000%2C466&ssl=1'),
                Image.network('https://i0.wp.com/www.biosciencetoday.co.uk/wp-content/uploads/2023/04/AdobeStock_575225072.jpeg?fit=1000%2C466&ssl=1'),
                Image.network('https://i0.wp.com/www.biosciencetoday.co.uk/wp-content/uploads/2023/04/AdobeStock_575225072.jpeg?fit=1000%2C466&ssl=1'),
              ],
            ),
          ),

          // Feature Buttons Grid with individual ElevatedButtons
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              _featureButton('Patient Assessment', 'https://img.freepik.com/premium-photo/animated-female-doctor-character_982269-293.jpg', '/Breathlessness'),
              _featureButton('Patient Requirement', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnKpRzcXdVP0mA3CKHozvIIWM_WMMfuDCQdw&s', '/patientRequirements'),
              _featureButton('Borg\'s Scale of Excursion', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSJCkJiqnv3ohBxW-JBv4byOklATwBn1IpHQ&s', '/BorgScaleScreen'),
              _featureButton('Peak Flow Meter', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQ48_zT-RngOHLOETzKv__M6oLJ5VPVZosDw&usqp=CAU', '/PeakFlowMeterScreen'),
            ],
          ),

          // Horizontal Scroll View for Video Thumbnails
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _videoThumbnail('https://t3.ftcdn.net/jpg/01/13/70/66/360_F_113706683_00nZyz61rv79dWXqkOEAmfcJo5YS5xhw.jpg', '/V1'),
                _videoThumbnail('https://t3.ftcdn.net/jpg/01/13/70/66/360_F_113706683_00nZyz61rv79dWXqkOEAmfcJo5YS5xhw.jpg', '/V2'),
                _videoThumbnail('https://t3.ftcdn.net/jpg/01/13/70/66/360_F_113706683_00nZyz61rv79dWXqkOEAmfcJo5YS5xhw.jpg', '/V3'),
                _videoThumbnail('https://t3.ftcdn.net/jpg/01/13/70/66/360_F_113706683_00nZyz61rv79dWXqkOEAmfcJo5YS5xhw.jpg', '/V4'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/PatientDashboardViewAll', arguments: prepareArguments('/PatientDashboardViewAll'));
        },
        child: Text('View All'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // General feature button widget
  Widget _featureButton(String text, String imageUrl, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route, arguments: prepareArguments(route));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, height: 60, width: 60),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // Video thumbnail widget (updated to navigate to proper screens without passing arguments dynamically)
  Widget _videoThumbnail(String imageUrl, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route, arguments: prepareArguments(route));
        },
        child: Image.network(imageUrl),
      ),
    );
  }
}

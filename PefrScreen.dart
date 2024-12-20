import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PefrScreen extends StatefulWidget {
  @override
  _PefrScreenState createState() => _PefrScreenState();
}

class _PefrScreenState extends State<PefrScreen> {
  bool isLoading = true;
  List<dynamic> peakFlowData = [];
  String patientId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    patientId = ModalRoute.of(context)?.settings.arguments as String;
    fetchPeakFlowData();
  }

  // Function to fetch PEFR data
  Future<void> fetchPeakFlowData() async {
    setState(() {
      isLoading = true;
    });

    try {
      print('Fetching data for Patient ID: $patientId');
      final response = await http.get(Uri.parse('http://192.168.47.82/pulmonary/pefr1.php?patientId=$patientId'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          peakFlowData = json.decode(response.body);
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching peak flow data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathlessness - Patient ID: $patientId'),
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Loading...', style: TextStyle(fontSize: 18)),
          ],
        ),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: peakFlowData.length,
          itemBuilder: (ctx, index) {
            var item = peakFlowData[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['Date']),
                    SizedBox(height: 8),
                    Text('Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['Time']),
                    SizedBox(height: 8),
                    Text('PEFR:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['PEFR']),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

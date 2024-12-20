import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // For picking files
import 'package:video_player/video_player.dart'; // For playing video files
import 'dart:io'; // For file handling
import 'package:http/http.dart' as http; // For making HTTP requests

class AddVideoScreen extends StatefulWidget {
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  File? video;
  String introduction = '';
  String customFileName = '';
  VideoPlayerController? _videoPlayerController;

  // Function to pick a video
  Future<void> pickVideo() async {
    // Use FilePicker to select video files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video, // Restrict file picker to video files only
    );

    if (result != null) {
      setState(() {
        video = File(result.files.single.path!);
        _videoPlayerController = VideoPlayerController.file(video!)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController!.play(); // Autoplay the video after picking
          });
      });
    } else {
      print("No video selected");
    }
  }

  // Function to upload the selected video
  Future<void> uploadVideo() async {
    if (video == null) {
      // Alert if no video is selected
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No video selected'),
          content: Text('Please select a video to upload.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      var uri = Uri.parse('http://192.168.47.82/pulmonary/adddoctorvideo.php');
      var request = http.MultipartRequest('POST', uri);

      // Add the video file to the request
      var videoFile = await http.MultipartFile.fromPath('video_file', video!.path);
      request.files.add(videoFile);

      // Add additional fields to the request
      request.fields['introduction'] = introduction;
      request.fields['custom_file_name'] = customFileName;

      // Send the HTTP request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Video uploaded successfully.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        // Clear fields after successful upload
        setState(() {
          video = null;
          introduction = '';
          customFileName = '';
        });
      } else {
        throw Exception('Failed to upload video');
      }
    } catch (e) {
      // Error dialog
      print('Error uploading video: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to upload video.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Video'),
        backgroundColor: Color(0xFFA4A4A4),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Automatically resize when the keyboard appears
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Color(0xFFFAFAFA), // Set the overall background to #FAFAFA
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video picker area
                GestureDetector(
                  onTap: pickVideo,
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFA4A4A4), width: 2),
                    ),
                    child: video == null
                        ? Center(
                      child: Icon(
                        Icons.videocam,
                        color: Colors.grey,
                        size: 100,
                      ),
                    )
                        : AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Text field for introduction
                TextField(
                  onChanged: (text) => setState(() => introduction = text),
                  decoration: InputDecoration(
                    labelText: 'Introduction',
                    filled: true,
                    fillColor: Color(0xFFFAFAFA), // Set background color to #FAFAFA
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Text field for custom file name
                TextField(
                  onChanged: (text) => setState(() => customFileName = text),
                  decoration: InputDecoration(
                    labelText: 'Custom File Name',
                    filled: true,
                    fillColor: Color(0xFFFAFAFA), // Set background color to #FAFAFA
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Upload button
                ElevatedButton(
                  onPressed: uploadVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA4A4A4),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      'Upload Video',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

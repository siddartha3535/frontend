import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class EditVideoScreen extends StatefulWidget {
  final dynamic video;

  EditVideoScreen({required this.video});

  @override
  _EditVideoScreenState createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _videoPath;  // To store the path of the selected video
  bool _isVideoSelected = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current video details
    _nameController.text = widget.video['video_name'];
    _descriptionController.text = widget.video['introduction'];
  }

  Future<void> _pickVideo() async {
    // Use file_picker to allow the user to pick a video file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video, // Limit to video files only
    );

    if (result != null) {
      setState(() {
        _videoPath = result.files.single.path;
        _isVideoSelected = true;
      });
    }
  }

  Future<void> _updateVideoDetails() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    // Prepare data to send to the server
    var videoData = {
      'id': widget.video['id'],  // Send the ID
      'introduction': _descriptionController.text,
      'custom_file_name': _nameController.text,  // Assuming custom file name is based on the video name
    };

    // If a new video is selected, include it in the request body
    if (_isVideoSelected && _videoPath != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.47.82/pulmonary/updatevideo.php')
      );

      request.fields['introduction'] = _descriptionController.text;
      request.fields['custom_file_name'] = _nameController.text;
      request.fields['id'] = widget.video['id'].toString();

      // Add the video file if selected
      var videoFile = await http.MultipartFile.fromPath(
          'video_file', _videoPath!
      );
      request.files.add(videoFile);

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          // On success, return the updated video details
          Navigator.pop(context, {
            'video_name': _nameController.text,
            'introduction': _descriptionController.text,
            'video_path': _videoPath,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update video details.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      // No new video selected, just update other fields
      var response = await http.post(
        Uri.parse('http://192.168.47.82/pulmonary/updatevideo.php'),
        body: {
          'id': widget.video['id'].toString(),
          'introduction': _descriptionController.text,
          'custom_file_name': _nameController.text,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, {
          'video_name': _nameController.text,
          'introduction': _descriptionController.text,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update video details.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Edit Video'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Video Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text(_isVideoSelected ? 'Change Video' : 'Select Video'),
            ),
            SizedBox(height: 16),
            if (_isVideoSelected)
              Text('Selected Video: ${_videoPath!.split('/').last}', style: TextStyle(fontSize: 16)),
            Spacer(),
            ElevatedButton(
              onPressed: _updateVideoDetails,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

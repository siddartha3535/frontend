import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'AddVideoScreen.dart';
import 'EditVideoScreen.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool isLoading = true;
  String error = '';
  List<dynamic> videos = [];
  VideoPlayerController? _controller;
  bool isPlaying = false;
  String? selectedScreen;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.47.82/pulmonary/displayvideos.php'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Parsed result: $result');
        if (result['success']) {
          setState(() {
            videos = result['data'].map((video) => {...video, 'selected': false}).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            error = result['message'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'HTTP error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void playVideo(String videoUrl) {
    if (_controller != null) {
      _controller!.dispose();
    }

    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          isPlaying = true;
        });
        _controller!.play();
      });
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  void _onPlusButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddVideoScreen()),
    );
  }

  void _storeVideos() async {
    if (selectedScreen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a storage screen (V1, V2, V3, V4).')),
      );
      return;
    }

    final selectedVideos = videos.where((video) => video['selected'] == true).toList();

    if (selectedVideos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one video.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.47.82/pulmonary/addvideos.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'screen': selectedScreen,
          'videos': selectedVideos,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Videos stored successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to store videos: ${responseData['message']}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending data to server.')),
      );
    }
  }

  void _showSelectScreenDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Screen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('V1'),
                value: 'V1',
                groupValue: selectedScreen,
                onChanged: (value) {
                  setState(() {
                    selectedScreen = value;
                  });
                  Navigator.of(context).pop();
                  _storeVideos();
                },
              ),
              RadioListTile<String>(
                title: Text('V2'),
                value: 'V2',
                groupValue: selectedScreen,
                onChanged: (value) {
                  setState(() {
                    selectedScreen = value;
                  });
                  Navigator.of(context).pop();
                  _storeVideos();
                },
              ),
              RadioListTile<String>(
                title: Text('V3'),
                value: 'V3',
                groupValue: selectedScreen,
                onChanged: (value) {
                  setState(() {
                    selectedScreen = value;
                  });
                  Navigator.of(context).pop();
                  _storeVideos();
                },
              ),
              RadioListTile<String>(
                title: Text('V4'),
                value: 'V4',
                groupValue: selectedScreen,
                onChanged: (value) {
                  setState(() {
                    selectedScreen = value;
                  });
                  Navigator.of(context).pop();
                  _storeVideos();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onVideoEdit(dynamic video) async {
    final updatedVideo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditVideoScreen(video: video),
      ),
    );

    if (updatedVideo != null) {
      setState(() {
        final index = videos.indexOf(video);
        if (index != -1) {
          videos[index] = updatedVideo;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA4A4A4),
        title: Text(
          'Videos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _showSelectScreenDialog,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text('Error: $error', style: TextStyle(color: Colors.red, fontSize: 18)))
          : Column(
        children: [
          if (isPlaying && _controller != null)
            Container(
              margin: EdgeInsets.all(16),
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: VideoPlayer(_controller!),
              ),
            ),
          if (_controller != null && _controller!.value.isInitialized)
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 50,

                color:  Color(0xFFA4A4A4),
              ),
              onPressed: () {
                setState(() {
                  if (isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                  isPlaying = !isPlaying;
                });
              },
            ),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFA4A4A4),
                      child: Icon(Icons.video_library, color: Colors.white),
                    ),
                    title: Text(
                      video['video_name'] ?? 'No Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(video['introduction'] ?? 'No Description'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: video['selected'] ?? false,  // Set default value to false if it's null
                          onChanged: (bool? value) {
                            setState(() {
                              video['selected'] = value ?? false;
                            });
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _onVideoEdit(video),  // Edit button
                        ),
                      ],
                    ),
                    onTap: () => playVideo(video['video_path']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPlusButtonPressed,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFA4A4A4),
        elevation: 5,
      ),
    );
  }
}

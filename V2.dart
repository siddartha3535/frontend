import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class V2 extends StatefulWidget {
  @override
  _V2State createState() => _V2State();
}

class _V2State extends State<V2> {
  bool isLoading = true;
  List<dynamic> videos = [];

  // Fetch video data from PHP API
  Future<void> fetchVideos() async {
    final url = 'http://192.168.47.82/pulmonary/patientvideos1.php'; // Replace with your actual PHP endpoint
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success']) {
          setState(() {
            videos = data['data']; // Store the fetched videos
            isLoading = false;
          });
        } else {
          // Handle the case when no videos are found
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('No Videos Found'),
              content: Text(data['message'] ?? 'No videos available'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle server errors
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch video data: $error'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVideos(); // Fetch videos when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Screen')),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : ListView.builder(
        itemCount: videos.length,
        itemBuilder: (ctx, index) {
          final video = videos[index];
          return ListTile(
            leading: video['video_name'].endsWith('mp4')
                ? Icon(Icons.video_library)
                : Icon(Icons.image),
            title: Text(video['video_name']),
            subtitle: Text(video['introduction'] ?? 'No description'),
            onTap: () {
              // Check if video URL is not null before navigating
              if (video['video_path'] != null && video['video_path'].isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => VideoPlayerScreen(videoUrl: video['video_path']),
                  ),
                );
              } else {
                // Handle case where video URL is null or empty
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Error'),
                    content: Text('No video URL available for this video.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false; // Track fullscreen state

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true); // Set video to loop if desired
    _controller.play(); // Auto-play the video
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      // Fullscreen mode (hide system UI)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Hide status bar
        systemNavigationBarColor: Colors.transparent, // Hide navigation bar
      ));
    } else {
      // Normal mode (show system UI)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: null, // Default status bar
        systemNavigationBarColor: null, // Default navigation bar
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_controller),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        icon: Icon(
                          _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                          color: Colors.white,
                        ),
                        onPressed: _toggleFullScreen,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

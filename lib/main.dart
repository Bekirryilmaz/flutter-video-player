import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoPlayerApp());
}

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isLooping = false;
  bool _isMuted = false;
  double _previousVolume = 1.0;


  final String _videoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl));


    _initializeVideoPlayerFuture = _controller.initialize();


    _controller.addListener(() {

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }



  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _controller.setVolume(_previousVolume);
        _isMuted = false;
      } else {
        _previousVolume = _controller.value.volume;
        _controller.setVolume(0.0);
        _isMuted = true;
      }
    });
  }

  void _toggleLoop() {
    setState(() {
      _isLooping = !_isLooping;
      _controller.setLooping(_isLooping);
    });
  }

  void _seekRelative(int seconds) async {
    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;

    Duration newPosition = currentPosition + Duration(seconds: seconds);


    if (newPosition < Duration.zero) {
      newPosition = Duration.zero;
    } else if (newPosition > duration) {
      newPosition = duration;
    }

    await _controller.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Oynatıcı'),
        backgroundColor: colorScheme.inversePrimary,
      ),

      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Video yüklenemedi. Lütfen internet bağlantınızı kontrol edin.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }


          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [

                Container(
                  color: Colors.black,
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_controller),

                        if (!_controller.value.isPlaying &&
                            _controller.value.position >=
                                _controller.value.duration &&
                            !_isLooping)
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.replay_circle_filled, size: 64, color: Colors.white70),
                              onPressed: () {
                                _controller.seekTo(Duration.zero);
                                _controller.play();
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(_controller.value.position)),
                          Text(_formatDuration(_controller.value.duration)),
                        ],
                      ),
                      Slider(
                        value: _controller.value.position.inSeconds.toDouble(),
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        activeColor: colorScheme.primary,
                        inactiveColor: colorScheme.primaryContainer,
                        onChanged: (value) {
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),


                Expanded(
                  child: Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [

                        IconButton.filledTonal(
                          onPressed: () => _seekRelative(-10),
                          icon: const Icon(Icons.replay_10),
                          tooltip: '10sn Geri',
                        ),


                        IconButton.filled(
                          onPressed: _togglePlayPause,
                          iconSize: 48,
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          tooltip: _controller.value.isPlaying ? 'Duraklat' : 'Oynat',
                        ),


                        IconButton.filledTonal(
                          onPressed: () => _seekRelative(10),
                          icon: const Icon(Icons.forward_10),
                          tooltip: '10sn İleri',
                        ),


                        IconButton.outlined(
                          onPressed: _toggleMute,
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: _isMuted ? Colors.red : colorScheme.primary,
                          ),
                          tooltip: 'Sesi Aç/Kapa',
                        ),


                        IconButton.outlined(
                          onPressed: _toggleLoop,
                          style: IconButton.styleFrom(
                            backgroundColor: _isLooping ? colorScheme.primaryContainer : null,
                          ),
                          icon: Icon(
                            Icons.loop,
                            color: _isLooping ? colorScheme.primary : Colors.grey,
                          ),
                          tooltip: 'Tekrarla',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
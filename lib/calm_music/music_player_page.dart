import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayerPage extends StatefulWidget {
  final List<Map<String, String>> songs;
  final int currentIndex;

  const MusicPlayerPage({
    super.key,
    required this.songs,
    required this.currentIndex,
  });

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer player;
  late int index;
  bool isPlaying = false;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    index = widget.currentIndex;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    player.onPlayerComplete.listen((event) {
      nextSong();
    });

    playCurrentSong();
  }

  void playCurrentSong() async {
    await player.stop();
    await player.play(AssetSource(widget.songs[index]['path']!));
    setState(() => isPlaying = true);
    controller.repeat();
  }

  void togglePlayPause() {
    setState(() {
      if (isPlaying) {
        player.pause();
        controller.stop();
      } else {
        player.resume();
        controller.repeat();
      }
      isPlaying = !isPlaying;
    });
  }

  void nextSong() {
    setState(() {
      index = (index + 1) % widget.songs.length;
      playCurrentSong();
    });
  }

  void previousSong() {
    setState(() {
      index = (index - 1 + widget.songs.length) % widget.songs.length;
      playCurrentSong();
    });
  }

  @override
  void dispose() {
    player.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.songs[index];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: controller.value * 2 * pi,
                    child: child,
                  );
                },
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.blueAccent],
                    ),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                song['title']!,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                song['artist']!,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 60,
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: previousSong,
                  ),
                  IconButton(
                    iconSize: 80,
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.white,
                    ),
                    onPressed: togglePlayPause,
                  ),
                  IconButton(
                    iconSize: 60,
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: nextSong,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

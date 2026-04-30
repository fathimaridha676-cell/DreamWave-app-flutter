import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:insomnia/calm_music/music_player_page.dart';

void main() {
  runApp(const MyApp());
}

/// 🌌 Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalmMusicPage(),
    );
  }
}

/// 🎶 Main Playlist Page
class CalmMusicPage extends StatefulWidget {
  const CalmMusicPage({super.key});

  @override
  State<CalmMusicPage> createState() => _CalmMusicPageState();
}

class _CalmMusicPageState extends State<CalmMusicPage> {
  List<bool> stars = List.generate(60, (_) => true);
  Timer? timer;
  Random random = Random();

  final List<Map<String, String>> songs = [
    {
      "title": "Calm Ocean",
      "artist": "Nature Sounds",
      "path": "music/musicword-small-waves-366809.mp3",
    },
    {
      "title": "Evening Jazz",
      "artist": "Smooth Beats",
      "path": "music/adiiswanto-calm-night-jazz-music-465315.mp3",
    },
    {
      "title": "Moonlight Sonata",
      "artist": "Beethoven",
      "path":
          "music/saturn-3-music-beethoven-moonlight-sonata-first-theme-piano-sonata-no-14-401567.mp3",
    },
    {
      "title": "Deep Space Ambient",
      "artist": "Synth Music",
      "path": "music/sigmamusicart-space-ambient-background-music-462074.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (!mounted || stars.isEmpty) return;
      setState(() {
        int index = random.nextInt(stars.length);
        stars[index] = !stars[index];
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget nightStars() {
    return Stack(
      children: List.generate(60, (index) {
        double left = random.nextDouble() * MediaQuery.of(context).size.width;
        double top = random.nextDouble() * MediaQuery.of(context).size.height;
        return Positioned(
          left: left,
          top: top,
          child: AnimatedOpacity(
            opacity: stars[index] ? 1 : 0.2,
            duration: const Duration(milliseconds: 600),
            child: const Icon(Icons.star, color: Colors.white70, size: 3),
          ),
        );
      }),
    );
  }

  Widget moon() {
    return Positioned(
      top: 80,
      right: 40,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1B1F3B),
                  Color(0xFF2C2F5C),
                  Color(0xFFFF8C42),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          nightStars(),
          moon(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFE0EFFF), Color(0xFF8AB6FF)],
                  ).createShader(bounds),
                  child: const Text(
                    "Calm Music",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.white38, blurRadius: 20)],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return musicCard(
                        song['title']!,
                        song['artist']!,
                        song['path']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget musicCard(String title, String artist, String assetPath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 36,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerPage(
                    songs: songs,
                    currentIndex: songs.indexWhere(
                      (s) => s['path'] == assetPath,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 🎧 Music Player Page (Separate)

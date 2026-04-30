import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:insomnia/sleep_sounds/sleepy_player.dart';

class SleepSoundsHome extends StatefulWidget {
  const SleepSoundsHome({super.key});

  @override
  State<SleepSoundsHome> createState() => _SleepSoundsHomeState();
}

class _SleepSoundsHomeState extends State<SleepSoundsHome> {
  final List<Map<String, String>> sleepSounds = const [
    {
      "title": "Rainy Night",
      "description": "Relax with the soothing sound of rain on your window.",
      "sound": "desifreemusic-rainy-london-night-lo-fi-beat-329258.mp3",
    },
    {
      "title": "Ocean Waves",
      "description": "Gentle ocean waves to help you drift into sleep.",
      "sound": "desifreemusic-ocean-wave-loops-377890.mp3",
    },
    {
      "title": "Forest Ambience",
      "description":
          "Hear the calming forest with birds and wind rustling leaves.",
      "sound": "mroneilovealot-moonlit-forest-410597.mp3",
    },
    {
      "title": "White Noise",
      "description": "A steady white noise to block distractions.",
      "sound":
          "purebinaural-purebinaural-40-hz-gamma-binaural-beats-with-white-noise-484861.mp3",
    },
    {
      "title": "Crackling Fire",
      "description": "Warm and cozy fireplace sounds for deep relaxation.",
      "sound":
          "trangiahung159-crackling-fireplace-and-soft-piano-music-378443.mp3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text("Sleep Sounds"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const _SleepStars(),
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sleepSounds.length,
            itemBuilder: (context, index) {
              final sound = sleepSounds[index];
              return _SleepSoundCard(
                title: sound["title"]!,
                description: sound["description"]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SleepyPlayer(
                        title: sound["title"]!,
                        soundFile: sound["sound"]!,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ✨ Twinkling stars background
class _SleepStars extends StatefulWidget {
  const _SleepStars({super.key});
  @override
  State<_SleepStars> createState() => _SleepStarsState();
}

class _SleepStarsState extends State<_SleepStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Random _random = Random();
  final List<double> _positions = List.generate(
    50,
    (_) => Random().nextDouble(),
  );
  final List<double> _sizes = List.generate(
    50,
    (_) => 1 + Random().nextDouble() * 2,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(50, (index) {
            return Positioned(
              left: _positions[index] * width,
              top: _positions[index] * height,
              child: Opacity(
                opacity: 0.3 + _controller.value * 0.7,
                child: Icon(
                  Icons.star,
                  color: Colors.white70,
                  size: _sizes[index],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// ✨ Sleep Sound Card
class _SleepSoundCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _SleepSoundCard({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  State<_SleepSoundCard> createState() => _SleepSoundCardState();
}

class _SleepSoundCardState extends State<_SleepSoundCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 2, end: 10).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.95);
  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    blurRadius: _glowAnimation.value,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.blueAccent.withOpacity(0.7),
                          blurRadius: _glowAnimation.value,
                        ),
                        const Shadow(color: Colors.white60, blurRadius: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: _glowAnimation.value / 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ✨ Music Player Page

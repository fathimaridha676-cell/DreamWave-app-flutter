import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationHome extends StatefulWidget {
  const MeditationHome({super.key});

  @override
  State<MeditationHome> createState() => _MeditationHomeState();
}

class _MeditationHomeState extends State<MeditationHome> {
  final List<Map<String, String>> meditations = const [
    {
      "title": "Morning Calm",
      "description": "Start your day with deep breathing and peace.",
      "sound": "morning_calm.mp3",
    },
    {
      "title": "Evening Relaxation",
      "description": "Wind down your mind and release tension.",
      "sound": "evening_relaxation.mp3",
    },
    {
      "title": "Focus Booster",
      "description": "Enhance concentration and clarity.",
      "sound": "focus_booster.mp3",
    },
    {
      "title": "Starlit Mind",
      "description": "Visualize the night sky and let thoughts float away.",
      "sound": "starlit_mind.mp3",
    },
    {
      "title": "Moonlight Serenity",
      "description": "Feel the calming energy of the moon guiding your breath.",
      "sound": "moonlight_serenity.mp3",
    },
    {
      "title": "Forest Whisper",
      "description": "Listen to imaginary forest sounds for deep relaxation.",
      "sound": "forest_whisper.mp3",
    },
    {
      "title": "Gentle Waves",
      "description": "Focus on the rhythm of ocean waves to ease stress.",
      "sound": "gentle_waves.mp3",
    },
    {
      "title": "Twilight Reflection",
      "description":
          "Reflect on your day while surrounded by a soft twilight glow.",
      "sound": "twilight_reflection.mp3",
    },
    {
      "title": "Celestial Calm",
      "description": "Let the stars and cosmic energy calm your mind and body.",
      "sound": "celestial_calm.mp3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1F3B),
      appBar: AppBar(
        title: const Text("Meditation"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const _AnimatedStars(),
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meditations.length,
            itemBuilder: (context, index) {
              final meditation = meditations[index];
              return _AnimatedMeditationCard(
                title: meditation["title"]!,
                description: meditation["description"]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeditationDetailPage(
                        title: meditation["title"]!,
                        description: meditation["description"]!,
                        soundFile: meditation["sound"]!,
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

// ⭐ Animated Stars Background
class _AnimatedStars extends StatefulWidget {
  const _AnimatedStars({super.key});
  @override
  State<_AnimatedStars> createState() => _AnimatedStarsState();
}

class _AnimatedStarsState extends State<_AnimatedStars>
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

// ✨ Animated Meditation Card
class _AnimatedMeditationCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AnimatedMeditationCard({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  State<_AnimatedMeditationCard> createState() =>
      _AnimatedMeditationCardState();
}

class _AnimatedMeditationCardState extends State<_AnimatedMeditationCard>
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

// 🌀 Meditation Detail Page with looping background audio
class MeditationDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String soundFile;

  const MeditationDetailPage({
    required this.title,
    required this.description,
    required this.soundFile,
    super.key,
  });

  @override
  State<MeditationDetailPage> createState() => _MeditationDetailPageState();
}

class _MeditationDetailPageState extends State<MeditationDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2, end: 8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _audioPlayer = AudioPlayer();
    _playAudio();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('music/${widget.soundFile}'));
    } catch (e) {
      print("Audio error: $e");
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1F3B),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Text(
                widget.description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  height: 1.6,
                  shadows: [
                    Shadow(
                      color: Colors.blueAccent.withOpacity(0.7),
                      blurRadius: _glowAnimation.value + 2,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: _glowAnimation.value,
                    ),
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

import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:insomnia/calm_music/calm_music_home.dart';
import 'package:insomnia/meditation/meditation_home.dart';
import 'package:insomnia/sleep_sounds/sleepy_home.dart';
import 'package:insomnia/story_telling/story_home.dart';
// <-- Import StoryPage

class HomePg extends StatefulWidget {
  const HomePg({super.key});

  @override
  State<HomePg> createState() => _HomePgState();
}

class _HomePgState extends State<HomePg> with SingleTickerProviderStateMixin {
  List<bool> twinkle = List.generate(30, (_) => true);
  late Timer timer;
  Random random = Random();

  // Example default story (so the card can navigate correctly)
  final Map<String, String> defaultStory = {
    "title": "The Enchanted Forest",
    "content":
        "Once upon a time, in a magical forest hidden from ordinary eyes...",
    "music": "music/musicword-small-waves-366809.mp3",
  };

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        int index = random.nextInt(twinkle.length);
        twinkle[index] = !twinkle[index];
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Twinkling stars
  Widget animatedStars() {
    return Stack(
      children: List.generate(30, (index) {
        double left = random.nextDouble() * MediaQuery.of(context).size.width;
        double top = random.nextDouble() * MediaQuery.of(context).size.height;
        return Positioned(
          left: left,
          top: top,
          child: AnimatedOpacity(
            opacity: twinkle[index] ? 1.0 : 0.2,
            duration: const Duration(milliseconds: 500),
            child: const Icon(Icons.star, color: Colors.white70, size: 2),
          ),
        );
      }),
    );
  }

  // Moon-themed gradient title
  Widget moonTitle(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFE0EFFF), Color(0xFF8AB6FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          shadows: [
            Shadow(color: Colors.white38, offset: Offset(0, 0), blurRadius: 12),
            Shadow(
              color: Colors.blueAccent,
              offset: Offset(0, 0),
              blurRadius: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget moonCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return _AnimatedMoonCard(icon: icon, title: title, page: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Container(color: Colors.black.withOpacity(0.55)),
          // Twinkling stars
          animatedStars(),
          // Main content
          Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Moon Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              moonTitle("Choose Your Escape"),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  crossAxisCount: 2,
                  children: [
                    moonCard(
                      context,
                      Icons.music_note,
                      "Calm Music",
                      const CalmMusicPage(),
                    ),
                    moonCard(
                      context,
                      Icons.menu_book,
                      "Storytelling",
                      const StoryHome(), // << This opens the list of stories
                    ),
                    moonCard(
                      context,
                      Icons.self_improvement,
                      "Meditation",
                      const MeditationHome(),
                    ),
                    moonCard(
                      context,
                      Icons.bedtime,
                      "Sleep Sounds",
                      const SleepSoundsHome(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Animated Moon Card with Tap Glow/Pulse
class _AnimatedMoonCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Widget page;

  const _AnimatedMoonCard({
    required this.icon,
    required this.title,
    required this.page,
    super.key,
  });

  @override
  State<_AnimatedMoonCard> createState() => _AnimatedMoonCardState();
}

class _AnimatedMoonCardState extends State<_AnimatedMoonCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeOut));
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
    _glowController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    _glowController.reverse();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.page),
    );
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
    _glowController.reverse();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

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
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: _glowAnimation.value,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 50,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
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

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// 🌌 Story Home Page
class StoryHome extends StatefulWidget {
  const StoryHome({super.key});

  @override
  State<StoryHome> createState() => _StoryHomeState();
}

class _StoryHomeState extends State<StoryHome> {
  List<bool> twinkle = List.generate(40, (_) => true);
  Timer? timer;
  Random random = Random();

  final List<Map<String, String>> stories = [
    {
      "title": "The Enchanted Forest",
      "content":
          """Once upon a time, in a magical forest hidden from the eyes of ordinary travelers, the trees whispered secrets to the wind. Every leaf shimmered under the moonlight, and the soft glow of fireflies lit the forest paths.

A young girl named Liora wandered into the forest one evening, guided by the gentle hum of the nocturnal creatures. She discovered a crystal-clear pond where water lilies floated gracefully, reflecting the stars above.

As she sat by the pond, a tiny fox with golden fur approached, bowing its head as if to greet her. “Welcome, traveler,” it seemed to say, “this forest will show you wonders if you listen closely.”

For hours, Liora explored the secret corners of the Enchanted Forest, each step revealing sparkling mushrooms, talking trees, and mystical streams. When dawn approached, she returned home, carrying with her a heart full of magic and a mind buzzing with dreams she would carry forever.""",
      "music": "music/musicword-small-waves-366809.mp3",
    },
    {
      "title": "Moonlight Adventure",
      "content":
          """Beneath the silver glow of the moon, a young explorer named Arin set out on a journey across the rolling hills and quiet rivers. The night was calm, and every shadow seemed alive, dancing to the rhythm of the gentle wind.

Arin followed the moon’s reflection in a small lake, where glowing fish swam lazily beneath the surface. Each ripple carried the soft laughter of night creatures, inviting him deeper into the world of nocturnal wonders.

As he climbed a hill, he discovered an ancient stone tower with vines curling around its walls. Inside, the spiral staircase led to a rooftop where he could see the entire valley bathed in silver light. He stayed until the first light of dawn, feeling the quiet power of the night and the adventures it held.""",
      "music": "music/musicword-small-waves-366809.mp3",
    },
    {
      "title": "The Sleepy Cat",
      "content":
          """In a quiet village tucked between rolling hills, there lived a small orange cat named Miso. Unlike other cats who chased mice or climbed trees, Miso loved to sleep — and dream.

Each night, he curled up by the window, gazing at the moon and twinkling stars. As he drifted to sleep, the dreams came alive: fields of dancing flowers, talking owls who told stories, and gentle rivers flowing with silver water.

One night, Miso dreamed he was flying above the village, guided by a glowing lantern. The wind whispered lullabies, and the stars followed him like friends. When he woke, the sun was rising, and he yawned happily, knowing another dreamy adventure awaited him that night.""",
      "music": "music/musicword-small-waves-366809.mp3",
    },
    {
      "title": "Starlit Journey",
      "content":
          """Among the infinite stars of the night sky, a small spaceship named Lumen traveled silently, carrying a crew of curious explorers. Each star they passed shimmered like a jewel, reflecting the excitement of the journey.

Captain Elara guided the ship gently through a field of glowing nebulae, where cosmic dust twinkled like golden sparks. The crew floated in zero gravity, mesmerized by the beauty of space and the quiet hum of the engines.

As they approached a distant planet, the stars seemed to form a path, guiding them to a hidden oasis of sparkling lakes and glowing forests. The crew spent the night observing the alien world, feeling the peaceful connection between the universe and their hearts.

When they departed at dawn, the starlit journey had left each explorer with a sense of wonder and a longing to return to the night skies again.""",
      "music": "music/musicword-small-waves-366809.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) return;
      setState(() {
        int index = random.nextInt(twinkle.length);
        twinkle[index] = !twinkle[index];
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 🌟 Stars in background
  Widget animatedStars() {
    return Stack(
      children: List.generate(40, (index) {
        double left = random.nextDouble() * MediaQuery.of(context).size.width;
        double top = random.nextDouble() * MediaQuery.of(context).size.height;
        return Positioned(
          left: left,
          top: top,
          child: AnimatedOpacity(
            opacity: twinkle[index] ? 1 : 0.2,
            duration: const Duration(milliseconds: 500),
            child: const Icon(Icons.star, color: Colors.white70, size: 2),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Evening → Night Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B1F3B), Color(0xFF2C2F5C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          animatedStars(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Storytelling",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryPage(
                                title: story['title']!,
                                content: story['content']!,
                                musicAsset: story['music']!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.menu_book,
                                color: Colors.white,
                                size: 36,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  story['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
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
}

/// 📖 Individual Story Page with Music & Animation
class StoryPage extends StatefulWidget {
  final String title;
  final String content;
  final String musicAsset;

  const StoryPage({
    super.key,
    required this.title,
    required this.content,
    required this.musicAsset,
  });

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _playMusic();
  }

  void _playMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(widget.musicAsset));
    setState(() => isPlaying = true);
    _fadeController.forward();
  }

  void _pauseMusic() async {
    await _audioPlayer.pause();
    setState(() => isPlaying = false);
    _fadeController.reverse();
  }

  void _toggleMusic() {
    if (isPlaying) {
      _pauseMusic();
    } else {
      _playMusic();
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1F3B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title),
        actions: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              ),
              iconSize: 32,
              onPressed: _toggleMusic,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Text(
              widget.content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

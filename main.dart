import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'summary_screen.dart';

void main() {
  runApp(PawsAndPreferences());
}

class PawsAndPreferences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paws & Preferences',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: CatSwipeScreen(),
    );
  }
}

class CatSwipeScreen extends StatefulWidget {
  @override
  _CatSwipeScreenState createState() => _CatSwipeScreenState();
}

class _CatSwipeScreenState extends State<CatSwipeScreen> with SingleTickerProviderStateMixin {
  List<String> catImages = [];
  List<String> likedCats = [];
  int currentIndex = 0;
  double _dx = 0;
  late AnimationController _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    generateCatImages();
    _backgroundAnimation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundAnimation.dispose();
    super.dispose();
  }

  void generateCatImages() {
    final random = Random();
    catImages = List.generate(10, (index) {
      return 'https://cataas.com/cat?unique=${random.nextInt(999999)}';
    });
  }

void handleSwipe(bool liked) {
  if (liked) {
    likedCats.add(catImages[currentIndex]);
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  } else {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  setState(() {
    _dx = 0;
    currentIndex++;
  });

  if (currentIndex >= catImages.length) {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(likedCats: likedCats),
        ),
      );
    });
  }
}


  Widget _buildSwipeOverlay() {
    if (_dx.abs() < 50) return SizedBox.shrink();

    return Positioned(
      top: 30,
      left: _dx > 0 ? 20 : null,
      right: _dx < 0 ? 20 : null,
      child: Opacity(
        opacity: min(_dx.abs() / 200, 1),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _dx > 0
                ? Colors.greenAccent.withOpacity(0.8)
                : Colors.redAccent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _dx > 0 ? Icons.favorite : Icons.close,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 8),
              Text(
                _dx > 0 ? 'Liked' : 'Disliked',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final imageHeight = screen.height * 0.55;
    final imageWidth = screen.width * 0.9;

    if (currentIndex >= catImages.length) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.pinkAccent,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.deepPurple.shade900,
                      Colors.pink.shade900,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CustomPaint(
                  painter: StarfieldPainter(_backgroundAnimation.value),
                  child: SizedBox.expand(),
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Paws & Preferences 🐾",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                      shadows: [
                        Shadow(color: Colors.pink, blurRadius: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _dx += details.delta.dx;
                        });
                      },
                      onPanEnd: (_) {
                        if (_dx > 150) {
                          handleSwipe(true);
                        } else if (_dx < -150) {
                          handleSwipe(false);
                        } else {
                          setState(() {
                            _dx = 0;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(_dx, 0),
                            child: Container(
                              height: imageHeight,
                              width: imageWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purpleAccent,
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  catImages[currentIndex],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          _buildSwipeOverlay(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _actionButton(Icons.close, Colors.redAccent, () {
                      handleSwipe(false);
                    }),
                    SizedBox(width: 40),
                    _actionButton(Icons.favorite, Colors.greenAccent, () {
                      handleSwipe(true);
                    }),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
        Feedback.forTap(context);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 32,
        ),
      ),
    );
  }
}

// 🎇 Optional: Starfield background painter for a cool effect
class StarfieldPainter extends CustomPainter {
  final double progress;
  final List<Offset> stars = List.generate(100, (i) => Offset(Random().nextDouble(), Random().nextDouble()));

  StarfieldPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white24;
    for (var star in stars) {
      final dx = (star.dx * size.width + progress * 20) % size.width;
      final dy = (star.dy * size.height + progress * 50) % size.height;
      canvas.drawCircle(Offset(dx, dy), 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) => true;
}

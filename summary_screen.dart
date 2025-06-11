import 'package:flutter/material.dart';
import 'dart:ui';

class SummaryScreen extends StatelessWidget {
  final List<String> likedCats;

  SummaryScreen({required this.likedCats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Blurred Glassmorphic Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Column(
                children: [
                  GlassHeader(text: 'Your Favourites 😻'),

                  const SizedBox(height: 10),

                  GlassCountCard(count: likedCats.length),

                  const SizedBox(height: 25),

                  Expanded(
                    child: likedCats.isEmpty
                        ? const Center(
                            child: Text(
                              "No cats liked 😿",
                              style: TextStyle(color: Colors.white70, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: likedCats.length,
                            itemBuilder: (context, index) {
                              return GlassCatCard(imageUrl: likedCats[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassHeader extends StatelessWidget {
  final String text;

  const GlassHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.2,
          shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class GlassCountCard extends StatelessWidget {
  final int count;

  const GlassCountCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        'You liked $count out of 10 cats!',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.pinkAccent,
        ),
      ),
    );
  }
}

class GlassCatCard extends StatelessWidget {
  final String imageUrl;

  const GlassCatCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 2,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 800),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loading) =>
                    loading == null
                        ? child
                        : Container(
                            color: Colors.black12,
                            child: Center(
                              child: Icon(Icons.pets, size: 50, color: Colors.white30),
                            ),
                          ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.4, sigmaY: 0.4),
              child: Container(
                color: Colors.black.withOpacity(0.02),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deck = context.watch<DeckProvider>();
    final theme = deck.themeManager;
    final serif = Theme.of(context).textTheme.titleLarge?.fontFamily ?? theme.fontFamily;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        title: Text(
          'Animalia Arcana',
          style: TextStyle(
            color: theme.secondary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: serif,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.5),
            radius: 1.2,
            colors: [
              theme.primary.withOpacity(0.12),
              theme.background,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories, size: 80, color: theme.secondary),
            const SizedBox(height: 20),
            Text(
              'Welcome to Animalia Arcana',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.secondary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: serif,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Discover the wisdom of animal spirits through tarot',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
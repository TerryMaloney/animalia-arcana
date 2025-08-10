import 'package:flutter/material.dart';

class ReadingsScreen extends StatelessWidget {
  const ReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarot Readings'),
      ),
      body: const Center(child: Text('Readings')), 
    );
  }
}
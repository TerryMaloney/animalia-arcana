import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleTestApp());
}

class SimpleTestApp extends StatelessWidget {
  const SimpleTestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter Web Test',
      theme: ThemeData.dark(),
      home: const SimpleTestScreen(),
    );
  }
}

class SimpleTestScreen extends StatefulWidget {
  const SimpleTestScreen({super.key});
  @override
  State<SimpleTestScreen> createState() => _SimpleTestScreenState();
}

class _SimpleTestScreenState extends State<SimpleTestScreen> {
  int counter = 0;

  void _incrementCounter() {
    debugPrint('🔄 Button clicked! Counter: $counter');
    setState(() {
      counter++;
    });
    debugPrint('✅ Counter updated to: $counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('SIMPLE TEST'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FLUTTER WEB TEST',
              style: TextStyle(
                fontSize: 32,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Counter: $counter',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text(
                'CLICK ME!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
              child: GestureDetector(
                onTap: () {
                  debugPrint('🔄 Red box tapped!');
                  setState(() {
                    counter += 10;
                  });
                  debugPrint('✅ Counter jumped to: $counter');
                },
                child: const Center(
                  child: Text(
                    'TAP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
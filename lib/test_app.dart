import 'package:flutter/material.dart';

void main() {
  runApp(SimpleTestApp());
}

class SimpleTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter Web Test',
      theme: ThemeData.dark(),
      home: SimpleTestScreen(),
    );
  }
}

class SimpleTestScreen extends StatefulWidget {
  @override
  _SimpleTestScreenState createState() => _SimpleTestScreenState();
}

class _SimpleTestScreenState extends State<SimpleTestScreen> {
  int counter = 0;

  void _incrementCounter() {
    print('🔄 Button clicked! Counter: $counter');
    setState(() {
      counter++;
    });
    print('✅ Counter updated to: $counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('SIMPLE TEST'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FLUTTER WEB TEST',
              style: TextStyle(
                fontSize: 32,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Counter: $counter',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'CLICK ME!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
              child: GestureDetector(
                onTap: () {
                  print('🔄 Red box tapped!');
                  setState(() {
                    counter += 10;
                  });
                  print('✅ Counter jumped to: $counter');
                },
                child: Center(
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
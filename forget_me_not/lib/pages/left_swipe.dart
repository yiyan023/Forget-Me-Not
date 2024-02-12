import 'package:flutter/material.dart';

class LeftSwipe extends StatelessWidget {
  // Add a named 'key' parameter to the constructor
  const LeftSwipe ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text('This is the Third Page'),
      ),
    );
  }
}
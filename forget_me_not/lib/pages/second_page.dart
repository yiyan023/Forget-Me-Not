import 'package:flutter/material.dart';


class SecondPage extends StatelessWidget {
  // Add a named 'key' parameter to the constructor
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, //button colour
                foregroundColor: Colors.white, //text colour 
              ),
              child: const Text('Elevated Button')
              ),
            
          ],
        ),
      ),
    );
  }
}
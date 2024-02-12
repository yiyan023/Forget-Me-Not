import 'package:flutter/material.dart';
import 'package:uofthacks/pages/map_page.dart';
import 'package:uofthacks/pages/ar_page.dart';
import 'package:uofthacks/services/location-service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage ({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  final LocationService locationService = LocationService(); // Create LocationService instance

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          image:DecorationImage(
            image: AssetImage('assets/landingpage.jpeg'),
            fit: BoxFit.cover
          ),
        ),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ARView(locationStream: locationService.locationStream)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 55.0, left: 20.0),
                  child: Image.asset(
                  'assets/leftarrow.jpeg', // Replace with the path to your image asset
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                ),
                ) 
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 775.0, right: 40.0),
                  child: Image.asset(
                  'assets/rightarrow.jpeg', // Replace with the path to your image asset
                  width: 150, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                ),
                ) 
              ),
          ],
        )
      ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/* class Swipe extends StatelessWidget {
  const Swipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Swipe Page'),
      ),
    );
  }
} */

class LeftSwipe extends StatelessWidget {
  const LeftSwipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: const Center(
        child: Text('Left Swipe Page'),
      ),
    );
  }
}
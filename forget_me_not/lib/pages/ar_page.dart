import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:uofthacks/services/ar_manager.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:location/location.dart';


class ARView extends StatefulWidget {

  final Stream<LatLng> locationStream;

  const ARView({
    super.key,
    required this.locationStream,
  });

  @override
  _ARViewState createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  late ARKitController arkitController;
  late StreamSubscription<List<MessageObject>> messageSubscription;
  late StreamSubscription<LatLng> locationSubscription;

  late LocationData _locationData;

  @override
  void initState() {
    super.initState();

    fetchCurrentLocation();

    // Subscribe to the ArManager message objects stream
    messageSubscription = ArManager.messageObjectsStream.listen((messageObjects) {
      removeAllNodes();
      ArManager.updateList2(messageObjects);
      instantiateNodes();
    });

    locationSubscription = widget.locationStream.listen(updateArObjectPosition);
  }

  Future<void> fetchCurrentLocation() async {
    _locationData = await getLocationaha();
    instantiateNodes();
  }

  Future<LocationData> getLocationaha() async {
    Location location = Location();
    return await location.getLocation();
  }


    // Inside _ARViewState
  void updateArObjectPosition(LatLng newLocation) {
    removeAllNodes();
    instantiateNodes();
  }

  Vector3 convertLatLongToArCoordinates(double userLat, double userLng, double targetLat, double targetLng) {
    const double earthRadius = 6371000; // Earth's radius in meters

    // Convert latitude and longitude from degrees to radians
    double userLatRad = radians(userLat);
    double userLngRad = radians(userLng);
    double targetLatRad = radians(targetLat);
    double targetLngRad = radians(targetLng);

    // Calculate differences
    double latDiff = targetLatRad - userLatRad;
    double lngDiff = targetLngRad - userLngRad;

    // Calculate distance using Haversine formula
    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(userLatRad) * cos(targetLatRad) * sin(lngDiff / 2) * sin(lngDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    // Calculate bearing
    double y = sin(lngDiff) * cos(targetLatRad);
    double xCalc = cos(userLatRad) * sin(targetLatRad) - 
                  sin(userLatRad) * cos(targetLatRad) * cos(lngDiff);
    double bearing = atan2(y, xCalc);

    // Convert distance and bearing to coordinates in ARKit's 3D space
    double z = -distance * cos(bearing); // Assuming north is -Z in ARKit
    double x = distance * sin(bearing);  // East is +X in ARKit

    return Vector3(x, 0, z); // Assuming y (altitude) is not used or set to 0
  }

  void instantiateNodes() {
  for (MessageObject obj in ArManager.getMessageObjects()) {
    final node = ARKitNode(
      geometry: ARKitBox(width: 0.6, height: 0.4, length: 0.1),
      position: convertLatLongToArCoordinates(
        _locationData.latitude!, 
        _locationData.longitude!, 
        obj.location[0], 
        obj.location[1]
      ),
      name: obj.objName, // Make sure this is unique for each object
    );
    arkitController.add(node);
    //print("made object " );
    //print(ArManager.getMessageObjects().length);
  }
}

  void removeAllNodes() {
    for (MessageObject obj in ArManager.getMessageObjects()) {
      arkitController.remove(obj.objName);
    }
    //print("removed all nodes");
  }


 @override
  void dispose() {
    // Cancel the stream subscription to prevent memory leaks
    messageSubscription.cancel();
    locationSubscription.cancel();
    // Call ArManager.dispose() when it's guaranteed not to be used anymore
    // ArManager.dispose();
    arkitController.dispose();
    super.dispose();
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    final node = ARKitNode(
        geometry: ARKitBox(width: 0.6, height: 0.4, length: 0.1),
        position: Vector3(0, 0, -0.5));
    // final node = ARKitReferenceNode(
    //   url: 'models.scnassets/Envelope.dae',
    //   scale: vector.Vector3.all(0.3),
    // );
    this.arkitController.add(node);
    //this.arkitController.onNodeTap = (nodes) => _onNodeTap(nodes);
  }

  Widget buildMessageWidget(MessageObject obj) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20), // Padding around the text
        color: Color.fromRGBO(7, 57, 60, 1), // Background color for highlight
        child: Text(
          obj.body, // Assuming you want to display the title
          style: const TextStyle(
            color: Color.fromRGBO(240, 237, 238, 1),
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  List<Widget> processMessageObjects() {
    List<Widget> widgets = [];

    for (MessageObject obj in ArManager.getMessageObjects()) {
      if (obj.isClicked) {
        print("tapped");
        widgets.add(buildMessageWidget(obj));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            ARKitSceneView(
              //showFeaturePoints: true,
              enableTapRecognizer: true,
              planeDetection: ARPlaneDetection.horizontal,
              onARKitViewCreated: onARKitViewCreated,
            ),
            ...processMessageObjects(),
          ],
        ),
      );
}
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  final Location location = Location();
  final StreamController<LatLng> locationUpdateController = StreamController<LatLng>.broadcast();

  LocationService() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      locationUpdateController.add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
    });
  }

  Stream<LatLng> get locationStream => locationUpdateController.stream;

  void dispose() {
    locationUpdateController.close();
  }
}

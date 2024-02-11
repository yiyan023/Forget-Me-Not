import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uofthacks/services/location-service.dart';
import 'package:uofthacks/pages/ar_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  late LocationService locationService;
  final LatLng _initialcameraposition = const LatLng(0.5937, 0.9629); // default position
  final bool _loadingInitialPosition = true;

  @override
  void initState() {
    super.initState();
    locationService = LocationService();
  }

  void _goToARView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ARView(
          locationStream: locationService.locationStream,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingInitialPosition) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialcameraposition, zoom: 17.0),
        mapType: MapType.normal,
        onMapCreated: (controller) => _controller = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}

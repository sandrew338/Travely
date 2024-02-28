import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(200.8415446, 24.0270487);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      body: GoogleMap(initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 16)),



    );
  }
}

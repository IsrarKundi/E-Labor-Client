import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/home_controller.dart';

class MapScreen extends StatelessWidget {
  final List<Coordinate> coordinates; // List of coordinates passed into the widget

  const MapScreen({Key? key, required this.coordinates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if coordinates are available and not empty
    if (coordinates.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Location Map'),
        ),
        body: Center(
          child: Text(
            'No coordinates available to display.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // Default center coordinates if the list is not empty
    final initialCenter = LatLng(
      coordinates.isNotEmpty ? coordinates.first.latitude : 0.0,
      coordinates.isNotEmpty ? coordinates.first.longitude : 0.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Location Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: initialCenter, // Change to 'center' instead of 'initialCenter'
          initialZoom: 13.0,
        ),
        children: [
          // TileLayer to display map tiles (e.g., OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            additionalOptions: {
              'accessToken': 'your-access-token-if-needed',
            },
          ),
          // MarkerLayer to display the coordinates as markers
          MarkerLayer(
            markers: coordinates
                .map(
                  (coordinate) => Marker(
                point: LatLng(coordinate.latitude, coordinate.longitude),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}

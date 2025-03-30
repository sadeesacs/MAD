import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color black = Colors.black;

class BookingDetailsMap extends StatelessWidget {
  final LatLng savedLocation;
  final Set<Marker> markers;

  const BookingDetailsMap({
    super.key,
    required this.savedLocation,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: savedLocation,
              zoom: 14,
            ),
            markers: markers,
          ),
        ),
      ],
    );
  }
}
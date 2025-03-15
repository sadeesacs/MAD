import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final double? lat;
  final double? lng;
  final bool isError;
  final Function(double, double) onLocationPicked;

  const LocationInput({
    super.key,
    this.lat,
    this.lng,
    required this.isError,
    required this.onLocationPicked,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If there's an existing lat/lng, show it
    if (widget.lat != null && widget.lng != null) {
      _controller.text = 'Lat: ${widget.lat}, Lng: ${widget.lng}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError ? Colors.red : Colors.black;

    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Click here to select location',
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Color(0xFF838383),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
      onTap: _openMapScreen,
    );
  }

  void _openMapScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(
          initialLat: widget.lat ?? 6.9271,  // Colombo defaults
          initialLng: widget.lng ?? 79.8612,
        ),
      ),
    );
    if (result != null) {
      final LatLng picked = result as LatLng;
      setState(() {
        _controller.text = 'Lat: ${picked.latitude}, Lng: ${picked.longitude}';
      });
      widget.onLocationPicked(picked.latitude, picked.longitude);
    }
  }
}

/// picking location on Google Map
class LocationPickerPage extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const LocationPickerPage({
    super.key,
    required this.initialLat,
    required this.initialLng,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(6.9271, 79.8612);

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.initialLat, widget.initialLng);
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialCamera = CameraPosition(
      target: _currentPosition,
      zoom: 12,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: const Color(0xFF027335),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCamera,
            onMapCreated: (controller) => _mapController = controller,
            markers: {
              Marker(
                markerId: const MarkerId('pickedLocation'),
                position: _currentPosition,
                draggable: true,
                onDragEnd: (LatLng newPosition) {
                  setState(() => _currentPosition = newPosition);
                },
              ),
            },
            onTap: (LatLng newPos) {
              setState(() => _currentPosition = newPos);
            },
          ),
          Positioned(
            bottom: 30,
            left: 25,
            right: 25,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF027335),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, _currentPosition);
              },
              child: const Text(
                'Confirm Location',
                style: TextStyle(
                  color: Colors.white, // explicitly white
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
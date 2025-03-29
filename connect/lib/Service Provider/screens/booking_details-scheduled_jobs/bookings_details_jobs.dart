import 'package:connect/Service%20Provider/screens/booking_details-scheduled_jobs/widgets/booking_details_content.dart';
import 'package:connect/Service%20Provider/screens/booking_details-scheduled_jobs/widgets/booking_details_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../scheduled_jobs/scheduled_job.dart';

const Color darkGreen = Color(0xFF027335);
const Color appBarColor = Color(0xFFF1FAF1);
const Color white = Colors.white;
const Color black = Colors.black;

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  // Map-related variables
  late GoogleMapController _mapController;
  final LatLng _savedLocation = const LatLng(6.9271, 79.8612); // Example: Colombo, Sri Lanka
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarker(); // Add marker for the saved location
  }

  void _addMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('savedLocation'),
          position: _savedLocation,
          infoWindow: const InfoWindow(title: 'Client Location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBarSP(), // Use the ConnectAppBar widget
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0), // Add 25 padding to the entire page
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ScheduledJobsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFE9E3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: darkGreen,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Booking ID: #9202828', // Replace with dynamic booking ID
                  style: TextStyle(color: darkGreen, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Booking Details Content
            const BookingDetailsContent(), // Use the BookingDetailsContent widget

            // Location (Map)
            BookingDetailsMap(
              savedLocation: _savedLocation,
              markers: _markers,
            ),
            const SizedBox(height: 24),

            // Cancel Booking Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Cancel Booking button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(color: white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BookingDetailsScreen(),
  ));
}
import 'package:flutter/material.dart';
import '../../../widgets/connect_app_bar.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Successful!',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w800, // ExtraBold
                  fontSize: 35,
                  color: Color(0xFF027335),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking ID - 565332',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your booking request has been sent!',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400, // Regular
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'The provider has up to 2 days to respond',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Big check icon inside a circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF027335),
                    width: 2,
                  ),
                  color: const Color(0xFFE8F5E8), // light greenish
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Color(0xFF027335),
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // "View upcoming bookings" button
              ElevatedButton(
                onPressed: () {
                  // Navigate to upcoming bookings screen (placeholder)
                  // For now, just pop to home or show a placeholder
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'View upcoming bookings',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

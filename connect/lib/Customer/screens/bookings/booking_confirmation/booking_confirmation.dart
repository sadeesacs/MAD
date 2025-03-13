import 'package:flutter/material.dart';
import '../../../widgets/connect_app_bar.dart';

class BookingConfirmation extends StatelessWidget {
  const BookingConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 20),
              const Text(
                'Booking ID - 565332',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your booking request has been sent!',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400, // Regular
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'The provider has up to 2 days to respond',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF027335), width: 2),
                  color: const Color(0xFFEFF8F3),
                ),
                child: const Icon(
                  Icons.check,
                  size: 100,
                  color: Color(0xFF027335),
                ),
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
                    fontSize: 20,
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
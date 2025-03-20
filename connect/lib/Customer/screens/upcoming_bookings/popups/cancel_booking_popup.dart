import 'package:flutter/material.dart';

class CancelBookingPopup extends StatelessWidget {
  final Map<String, dynamic> bookingInfo;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CancelBookingPopup({
    super.key,
    required this.bookingInfo,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
        'Are you sure you want to cancel this booking?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500, // Medium
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF027335)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF027335),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF027335),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

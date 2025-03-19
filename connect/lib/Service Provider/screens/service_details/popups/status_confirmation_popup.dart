import 'package:flutter/material.dart';

class StatusConfirmationPopup extends StatelessWidget {
  final bool isCurrentlyActive;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const StatusConfirmationPopup({
    super.key,
    required this.isCurrentlyActive,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final String question = isCurrentlyActive
        ? 'Are you sure you want to temporarily deactivate this Service?'
        : 'Are you sure you want to Activate this Service?';

    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text(
        question,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Roboto',
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

import 'package:flutter/material.dart';

class UpcomingHistoryToggle extends StatelessWidget {
  final bool isUpcomingSelected;
  final VoidCallback onUpcomingPressed;
  final VoidCallback onHistoryPressed;

  const UpcomingHistoryToggle({
    super.key,
    required this.isUpcomingSelected,
    required this.onUpcomingPressed,
    required this.onHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color upcomingFill = isUpcomingSelected
        ? const Color(0xFFDFE9E3)
        : const Color(0xFFF3F5F7);
    final Color historyFill = isUpcomingSelected
        ? const Color(0xFFF3F5F7)
        : const Color(0xFFDFE9E3);

    return Row(
      children: [
        // Upcoming Bookings Button
        Expanded(
          child: GestureDetector(
            onTap: onUpcomingPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: upcomingFill,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF027335)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Upcoming Bookings',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Booking History Button
        Expanded(
          child: GestureDetector(
            onTap: onHistoryPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: historyFill,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF027335)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Booking History',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
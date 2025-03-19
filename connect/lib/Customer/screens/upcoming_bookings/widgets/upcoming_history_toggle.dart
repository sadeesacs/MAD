// lib/Customer/screens/upcoming_bookings/widgets/upcoming_history_toggle.dart

import 'package:flutter/material.dart';
// Adjust these paths to your actual screen files:
import '../upcoming_bookings.dart';           // For "Upcoming Bookings"

class UpcomingHistoryToggle extends StatelessWidget {
  final bool isUpcomingSelected;

  const UpcomingHistoryToggle({
    Key? key,
    required this.isUpcomingSelected, required Null Function() onUpcomingPressed, required Null Function() onHistoryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If upcoming is selected, fill color => #DFE9E3, else #F3F5F7
    final upcomingFill = isUpcomingSelected
        ? const Color(0xFFDFE9E3)
        : const Color(0xFFF3F5F7);
    final historyFill = isUpcomingSelected
        ? const Color(0xFFF3F5F7)
        : const Color(0xFFDFE9E3);

    return Row(
      children: [
        // Upcoming Bookings Button
        Expanded(
          child: GestureDetector(
            onTap: () {
              // If not on upcoming, navigate to UpcomingBookingsScreen
              if (!isUpcomingSelected) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UpcomingBookingsScreen(),
                  ),
                );
              }
            },
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

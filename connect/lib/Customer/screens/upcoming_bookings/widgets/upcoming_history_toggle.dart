import 'package:flutter/material.dart';
import '../upcoming_bookings.dart';

class UpcomingHistoryToggle extends StatelessWidget {
  final bool isUpcomingSelected;

  const UpcomingHistoryToggle({
    super.key,
    required this.isUpcomingSelected,
  });

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

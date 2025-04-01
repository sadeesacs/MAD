import 'package:flutter/material.dart';

class ServiceStatusCards extends StatelessWidget {
  final int completedServices;
  final int upcomingServices;

  const ServiceStatusCards({
    super.key,
    required this.completedServices,
    required this.upcomingServices,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ServiceCard(
          title: 'Completed Services',
          count: completedServices,
          icon: Icons.check,
        ),

        // Upcoming Services Card
        _ServiceCard(
          title: 'Upcoming Services',
          count: upcomingServices,
          icon: Icons.error_outline,
        ),
      ],
    );
  }
}

// **Cards**
class _ServiceCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text Column (Title + Count)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500, // Medium
                    fontSize: 6,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600, // SemiBold
                    fontSize: 6,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
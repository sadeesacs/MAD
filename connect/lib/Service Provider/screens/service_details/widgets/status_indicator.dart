import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isActive;

  const StatusIndicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isActive ? const Color(0xFF027335) : Colors.red;
    final String letter = isActive ? 'A' : ' I '; // Active/Inactive

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8), // 10%
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}
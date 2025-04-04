import 'package:flutter/material.dart';

class ProfileLabel extends StatelessWidget {
  final String label;

  const ProfileLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }
}

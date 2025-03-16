import 'package:flutter/material.dart';

class ResetFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResetFiltersButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Reset Filters',
          style: TextStyle(color: Color(0xFF666666), fontSize: 16),
        ),
      ),
    );
  }
}
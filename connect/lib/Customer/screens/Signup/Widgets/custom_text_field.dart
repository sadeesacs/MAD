import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0), // Increased spacing between fields
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 50, // Adjusted height for more spacious input fields
            child: TextFormField(
              obscureText: isPassword,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15), // More padding inside the text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded edges as per design
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // Align the content to the center
        children: [
          const SizedBox(height: 80),  // Add more space above the title to make it lower
          const Text(
            "Register",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF027335), // Updated to #027335 color
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Create an Account",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

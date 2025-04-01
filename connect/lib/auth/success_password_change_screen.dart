import 'package:flutter/material.dart';
import 'login_screen.dart';

class SuccessPasswordChangeScreen extends StatelessWidget {
  const SuccessPasswordChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "Successful"
              const Text(
                'Successful',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Color(0xFF027335),
                ),
              ),
              const SizedBox(height: 10),

              // "Your Password changes successfully"
              const Text(
                'Your Password changes successfully',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Circle with check mark
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFDFE9E3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 100,
                  color: Color(0xFF027335),
                ),
              ),
              const SizedBox(height: 40),

              // "Return to Login" button
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF427E4E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Return to Login',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
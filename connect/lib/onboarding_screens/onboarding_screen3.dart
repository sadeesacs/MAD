import 'package:flutter/material.dart';
import 'package:connect/auth/register_screen.dart';

import '../role_selection/role_selection.dart'; // Import RegisterScreen

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    const Color titleColor = Color(0xFF427E4E);
    const Color dotBorderColor = Color(0xFF027335);
    const Color dotFillColor = Color(0xFFDFE9E3);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      // Title
                      const Text(
                        'Chat & Book with Confidence',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 100),
                      // Image
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Image.asset(
                          'assets/onboarding/screen3.png',
                          height: constraints.maxHeight * 0.35,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Description
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Communicate with providers, confirm\nbookings, and track your services easily.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildDot(false, Colors.transparent, dotBorderColor),
                          const SizedBox(width: 17),
                          buildDot(false, Colors.transparent, dotBorderColor),
                          const SizedBox(width: 17),
                          buildDot(true, dotFillColor, dotBorderColor),
                        ],
                      ),
                      const Spacer(),
                      // Get Started Button navigates to RegisterScreen
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: titleColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RoleSelectionScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget buildDot(bool isSelected, Color fillColor, Color borderColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isSelected ? 20 : 18,
      height: isSelected ? 20 : 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? fillColor : Colors.transparent,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
    );
  }
}

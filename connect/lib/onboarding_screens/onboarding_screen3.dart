import 'package:flutter/material.dart';
import 'package:connect/role_selection/role_selection.dart';

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
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Title
            const Text(
              'Chat & Book with Confidence',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,           // Increased for better visibility
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Center illustration
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Image.asset(
                  'assets/onboarding/screen3.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Communicate with providers, confirm\nbookings, and track your services easily.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.3,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 25),

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

            const SizedBox(height: 25),

            // "Get Started" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
    );
  }

  static Widget buildDot(bool isSelected, Color fillColor, Color borderColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isSelected ? 22 : 20,
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

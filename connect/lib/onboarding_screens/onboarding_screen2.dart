import 'package:flutter/material.dart';
import 'onboarding_screen3.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color titleColor = Color(0xFF427E4E);
    const Color dotBorderColor = Color(0xFF027335);
    const Color dotFillColor = Color(0xFFDFE9E3);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          // Distribute space in the vertical direction
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top spacing
            const SizedBox(height: 40),

            // Title
            const Text(
              'Smarter Work for Providers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Image
            Expanded(
              // Use Expanded for the image to flex and adapt to screen size
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(
                  'assets/onboarding/screen2.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Description text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Work Made Simple for Providers\nManage services, jobs, and schedules easily.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDot(false, dotFillColor, dotBorderColor),
                const SizedBox(width: 17),
                buildDot(true, dotFillColor, dotBorderColor),
                const SizedBox(width: 17),
                buildDot(false, Colors.transparent, dotBorderColor),
              ],
            ),

            // Bottom buttons row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Skipped to Role Selection"),
                        ),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Arrow
                  Container(
                    decoration: const BoxDecoration(
                      color: titleColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen3(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
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

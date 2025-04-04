import 'package:flutter/material.dart';
import '../role_selection/role_selection.dart';
import 'onboarding_screen2.dart';
import 'package:connect/auth/register_screen.dart'; // Import RegisterScreen

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                        'Find Skilled Experts Instantly',
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
                          'assets/onboarding/screen1.png',
                          height: constraints.maxHeight * 0.35,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Description
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Search, compare, and book trusted\nservice providers near you.',
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
                          buildDot(true, dotFillColor, dotBorderColor),
                          const SizedBox(width: 17),
                          buildDot(false, Colors.transparent, dotBorderColor),
                          const SizedBox(width: 17),
                          buildDot(false, Colors.transparent, dotBorderColor),
                        ],
                      ),
                      const Spacer(),
                      // Bottom Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Skip Button navigates to RegisterScreen
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RoleSelectionScreen(),
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
                            // Arrow Button navigates to OnboardingScreen2
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
                                      builder: (context) => const OnboardingScreen2(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward,
                                    color: Colors.white),
                              ),
                            ),
                          ],
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

  // Dot builder
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

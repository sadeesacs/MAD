import 'package:flutter/material.dart';
import 'onboarding_screen3.dart';


class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

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
                        'Smarter Work for Providers',
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
                          'assets/onboarding/screen2.png',
                          height: constraints.maxHeight * 0.35,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Description
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          ' Work Made Simple for Providers Manage services, jobs, and  schedules easily.',
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
                          buildDot(false, dotFillColor, dotBorderColor),
                          const SizedBox(width: 17),
                          buildDot(true, dotFillColor, dotBorderColor),
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
                            // Skip
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Skipped to Role Selection")),
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
                                      builder: (context) => const OnboardingScreen3(), // Make sure it's imported
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward, color: Colors.white),
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

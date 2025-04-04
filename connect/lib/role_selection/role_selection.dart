import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../auth/login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              children: [
                // Logo at the top center
                Image.asset(
                  'assets/images/logo/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // Title: "Welcome to Connect"
                const Text(
                  'Welcome to Connect',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xFF027335),
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle: "Let’s get started by choosing your user role"
                const Text(
                  "Let's get started by choosing your user role",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 50),

                // Role Selection Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Customer Role
                    _RoleCard(
                      label: 'Customer',
                      imagePath: 'assets/images/role_selection/customer.png',
                      onTap: () {
                        final storage = GetStorage();
                        storage.write('userRole', 'CUSTOMER');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(isServiceProvider: false),
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 40),

                    // Service Provider Role
                    _RoleCard(
                      label: 'Service Provider',
                      imagePath: 'assets/images/role_selection/service_provider.png',
                      onTap: () {
                        final storage = GetStorage();
                        storage.write('userRole', 'SERVICE_PROVIDER');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(isServiceProvider: true),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Role Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),

          // Role Label
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500, // Medium
              fontSize: 19,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../profile/customer_profile_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/upcoming_bookings/upcoming_bookings.dart';

// Adjust these imports to your actual screen files


class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.7;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: drawerWidth,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    // Wrap image + name in GestureDetector
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerProfileScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Profile Pic
                          ClipOval(
                            child: Image.asset(
                              'assets/images/profile_pic/leo_perera.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Name
                          const Text(
                            'Leo Perera',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Close Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // close the drawer
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFE9E3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF027335),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Separation line
              Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xFF027335),
              ),

              const SizedBox(height: 16),

              // Menu Items
              _buildMenuItem(
                icon: Icons.home_filled,
                label: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.construction,
                label: 'Services',
                onTap: () {

                },
              ),
              _buildMenuItem(
                icon: Icons.dashboard,
                label: 'Service Categories',
                onTap: () {

                },
              ),
              _buildMenuItem(
                icon: Icons.calendar_today_outlined,
                label: 'Bookings',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const UpcomingBookingsScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.message_outlined,
                label: 'Chats',
                onTap: () {
                },
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  // Placeholder
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                label: 'Support',
                onTap: () {
                  Navigator.pop(context);
                  // Placeholder
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  Navigator.pop(context);
                  // Placeholder
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF027335)),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500, // Medium
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

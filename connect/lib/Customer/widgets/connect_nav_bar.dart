import 'package:flutter/material.dart';
// Adjust these import paths to your actual screen files
import '../screens/customer_chats/customer_chat_list_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/service-detail/service_detail.dart';
import '../screens/upcoming_bookings/upcoming_bookings.dart';

class ConnectNavBar extends StatelessWidget {
  final bool isHomeSelected;
  final bool isConstructionSelected;
  final bool isUpcomingSelected;

  const ConnectNavBar({
    super.key,
    this.isHomeSelected = false,
    this.isUpcomingSelected = false,
    this.isConstructionSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [


              // Construction icon (Placeholder)
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ServiceDetailScreen(),
                    ),
                  );
                },
                child: _NavIcon(icon: Icons.construction, isActive: false),
              ),
              // Message icon (Placeholder)
              GestureDetector(
                onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerChatListScreen(),
                  ),
                );
                },
                child: _NavIcon(icon: Icons.message_outlined, isActive: false),
              ),
              // Home icon: navigates to HomeScreen
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                },
                child: _NavIcon(
                  icon: Icons.home_filled,
                  isActive: isHomeSelected,
                ),
              ),
              // Calendar icon: navigates to UpcomingBookingsScreen
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UpcomingBookingsScreen(),
                    ),
                  );
                },
                child: _NavIcon(
                  icon: Icons.calendar_today_outlined,
                  isActive: isUpcomingSelected,
                ),
              ),
              // Notifications icon (Placeholder)
              GestureDetector(
                onTap: () {
                  // Placeholder: navigation if needed
                },
                child: _NavIcon(
                  icon: Icons.notifications_outlined,
                  isActive: false,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _NavIcon({
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive
        ? const Color(0xFF027335)
        : const Color(0xFF027335).withOpacity(0.7);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF027335)),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(icon, color: iconColor, size: isActive ? 35 : 30),
    );
  }
}

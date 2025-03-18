import 'package:connect/Service%20Provider/screens/scheduled_jobs/scheduled_job.dart';
import 'package:flutter/material.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/service_listing/service_listing_screen.dart';

class ConnectNavBarSP extends StatelessWidget {
  final bool isHomeSelected;

  final bool isToolsSelected;

  final bool isCalenderSelected;

  const ConnectNavBarSP({
    super.key,
    this.isHomeSelected = false,
    this.isToolsSelected = false,
    this.isCalenderSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home icon
              GestureDetector(
                onTap: () {
                  // Navigate to Dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DashboardScreen(),
                    ),
                  );
                },
                child: _NavIcon(
                  icon: Icons.home_filled,
                  isActive: isHomeSelected,
                ),
              ),

              // Tools/Construction icon
              GestureDetector(
                onTap: () {
                  // Navigate to Service Listing
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ServiceListingScreen(),
                    ),
                  );
                },
                child: _NavIcon(
                  icon: Icons.construction,
                  isActive: isToolsSelected,
                ),
              ),

              GestureDetector(
                onTap: () {
                  // Navigate to Service Listing
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScheduledJobsScreen(),
                    ),
                  );
                },
                child: _NavIcon(
                  icon: Icons.calendar_today_outlined,
                  isActive: isCalenderSelected,
                ),
              ),


              // Messages icon
              _NavIcon(
                icon: Icons.message_outlined,
                isActive: false,
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
      child: Icon(
        icon,
        color: iconColor,
        size: isActive ? 30 : 26,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ConnectNavBarSP extends StatelessWidget {
  final bool isHomeSelected;
  const ConnectNavBarSP({super.key, this.isHomeSelected = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(40), // 40% rounded edges
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home
              _NavIcon(icon: Icons.home_filled, isActive: isHomeSelected),
              // Tools
              _NavIcon(icon: Icons.construction, isActive: false),
              // Calendar
              _NavIcon(icon: Icons.calendar_today_outlined, isActive: false),
              // Messages
              _NavIcon(icon: Icons.message_outlined, isActive: false),
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

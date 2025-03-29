import 'package:flutter/material.dart';

class ConnectAppBarSP extends StatelessWidget implements PreferredSizeWidget {
  const ConnectAppBarSP({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEDF9EB),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo + App Name
              Row(
                children: [
                  Image.asset(
                    'assets/images/other/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Connect',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: const Color(0xFF027335),
                    ),
                  ),
                ],
              ),

              // Notifications + Menu
              Row(
                children: [
                  _buildIconWithBackground(Icons.notifications),
                  const SizedBox(width: 8),
                  // Hamburger Menu Icon
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: _buildIconWithBackground(Icons.menu),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithBackground(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFDFE9E3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF027335),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SpecialOffersWidget extends StatelessWidget {
  const SpecialOffersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Offers',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600, // SemiBold
            fontSize: 24,
            color: Color(0xFF027335),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/images/special_offers/offer1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
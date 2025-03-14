import 'package:flutter/material.dart';

class TopRatedSPWidget extends StatelessWidget {
  const TopRatedSPWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final topRated = [
      {
        'title': 'Dry Cleaning Cloths',
        'provider': 'By You',
        'price': 'LKR 1500.00/h',
        'image': 'assets/images/jobs/dry_cleaning.png',
        'rating': '4.9',
      },
      {
        'title': 'House Cleaning',
        'provider': 'By You',
        'price': 'LKR 2000.00/h',
        'image': 'assets/images/jobs/house_cleaning.png',
        'rating': '3.5',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage My Services',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0xFF027335),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTopRatedCard(topRated[0])),
            const SizedBox(width: 16),
            Expanded(child: _buildTopRatedCard(topRated[1])),
          ],
        ),
      ],
    );
  }

  Widget _buildTopRatedCard(Map<String, String> service) {
    final double ratingValue = double.tryParse(service['rating']!) ?? 0.0;
    final int roundedRating = ratingValue.round();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF027335), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              service['image']!,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),

          // Service Title
          Text(
            service['title']!,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),

          // Service Provider
          Text(
            service['provider']!,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // 5 stars
          Row(
            children: [
              ...List.generate(5, (index) {
                if (index < roundedRating) {
                  return const Icon(
                    Icons.star,
                    color: Color(0xFFFFD700),
                    size: 16,
                  );
                } else {
                  return const Icon(
                    Icons.star_border,
                    color: Color(0xFFFFD700),
                    size: 16,
                  );
                }
              }),
              const SizedBox(width: 4),
              Text(
                service['rating']!,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Price
          Text(
            service['price']!,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
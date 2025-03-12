import 'package:flutter/material.dart';

class ServiceListingCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String provider;
  final String city;
  final String province;
  final double rating;
  final int reviewsCount;
  final double price;

  const ServiceListingCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.provider,
    required this.city,
    required this.province,
    required this.rating,
    required this.reviewsCount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 10% rounded edges, color: F6FAF8, with drop shadow
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF8),
        borderRadius: BorderRadius.circular(16), // ~10% of typical card size
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Cover image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 110,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Service details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Window Cleaning
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    fontWeight: FontWeight.w500, // "Medium"
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // By Mr. Richard Perera
                Text(
                  'By $provider',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Location:
                Row(
                  children: [
                    const Text(
                      'Location: ',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w500, // "Medium"
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '$city, $province',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Rating & Reviews
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xFFFFD700), // #FFD700
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1), // e.g. "4.9"
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w600, // "Semibold"
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      '$reviewsCount Reviews',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // LKR 500.00/h
                Row(
                  children: [
                    Text(
                      'LKR ${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '/h',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.grey[600], // #898A8D approx
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

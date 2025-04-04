// lib/Customer/screens/home/widgets/top_rated_widget.dart

import 'package:flutter/material.dart';
import '../../../../util/image_provider_helper.dart';

class TopRatedWidget extends StatelessWidget {
  final List<Map<String, dynamic>> services;

  const TopRatedWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Text(
        'Top Rated',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Color(0xFF027335),
        ),
      );
    }

    // For hard-coded data, we assume services already sorted.
    final topServices = services.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Rated',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0xFF027335),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: topServices.map((service) => _buildTopRatedCard(service)).toList(),
        ),
      ],
    );
  }

  Widget _buildTopRatedCard(Map<String, dynamic> service) {
    final double ratingValue = service['rating'] != null
        ? (service['rating'] as num).toDouble()
        : 0.0;
    final String imagePath = service['coverImage'] as String? ?? 'assets/images/monkey.png';
    final String title = service['serviceName'] as String? ?? 'Untitled';
    final String provider = service['serviceProviderName'] as String? ?? 'Unknown';
    final double hrRate = service['hourlyRate'] != null
        ? (service['hourlyRate'] as num).toDouble()
        : 0.0;

    return Container(
      width: 151,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF027335), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service image using the helper function.
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: getImageProvider(imagePath),
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          // Provider
          Text(
            'By $provider',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          // Stars row
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < ratingValue.round() ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 16,
                );
              }),
              const SizedBox(width: 4),
              Text(
                ratingValue.toStringAsFixed(1),
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
            'LKR ${hrRate.toStringAsFixed(2)}/h',
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

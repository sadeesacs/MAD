import 'package:flutter/material.dart';

import '../service_listing.dart';


class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Cover Image with 10% edge
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // Rounded corners
                image: DecorationImage(
                  image: AssetImage(service['image']),
                  fit: BoxFit.cover, // Fill the container
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Service Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Name
                  Text(
                    service['serviceName'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // Provider Name
                  Text(
                    'By ${service['providerName']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  // Location
                  Text(
                    'Location: ${service['location']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  // Ratings and Reviews
                  Row(
                    children: [
                      Text(
                        '${service['rating']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 34),
                      Text(
                        '${service['reviews']} Reviews',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  // Price
                  Text(
                    '${service['price']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
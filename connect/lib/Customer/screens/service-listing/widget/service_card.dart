// lib/Customer/screens/service-listing/widget/service_card.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../util/image_provider_helper.dart';

const Color cardBackgroundColor = Color(0xFFF6FAF8);

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceCard({super.key, required this.service});

  /// Fetches the provider's name by using the 'serviceProvider' reference
  /// from the service document and then reading the 'name' field from the user document.
  Future<String> _getProviderName() async {
    if (service.containsKey('serviceProvider') && service['serviceProvider'] is DocumentReference) {
      DocumentReference providerRef = service['serviceProvider'];
      DocumentSnapshot userDoc = await providerRef.get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return data['name'] ?? 'Unknown';
      }
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = service['coverImage'] ?? 'assets/images/monkey.png';
    final String serviceName = service['serviceName'] ?? 'Unknown';
    final List<dynamic> locs = service['locations'] ?? [];
    final double rating = service['rating']?.toDouble() ?? 0.0;
    final int reviews = service['reviews'] ?? 0;
    final double hrRate = service['hourlyRate']?.toDouble() ?? 0.0;

    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Cover image using our helper function for fallback logic
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: getImageProvider(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Service details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Name
                  Text(
                    serviceName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Provider Name (fetched from Firestore)
                  FutureBuilder<String>(
                    future: _getProviderName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('By ...', style: TextStyle(fontSize: 14));
                      }
                      if (snapshot.hasError) {
                        return const Text('By Unknown', style: TextStyle(fontSize: 14));
                      }
                      return Text('By ${snapshot.data}', style: const TextStyle(fontSize: 14));
                    },
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Text(
                    'Location: ${locs.join(", ")}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  // Rating and Reviews
                  Row(
                    children: [
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 34),
                      Text(
                        '$reviews Reviews',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Price per Hour
                  Text(
                    'LKR ${hrRate.toStringAsFixed(2)}/h',
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

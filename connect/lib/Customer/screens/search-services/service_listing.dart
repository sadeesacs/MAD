// lib/Customer/screens/search-services/service_listing.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../service-detail/service_detail.dart';

class SearchedServiceListingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services;

  const SearchedServiceListingScreen({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    // Debug print: check how many services we got
    print("SearchedServiceListingScreen: Received ${services.length} services.");

    return Scaffold(
      appBar: const ConnectAppBar(),
      bottomNavigationBar: const ConnectNavBar(),
      body: services.isEmpty
          ? const Center(child: Text('No matching services found'))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(context, service);
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    // Read fields from the service map; if missing, fallback to default values.
    final coverImage = service['coverImage'] ?? '';
    final serviceName = service['serviceName'] ?? 'Unknown Service';
    final providerName = service['serviceProviderName'] ?? 'Unknown Provider';
    final List<dynamic> locs = service['locations'] as List<dynamic>? ?? [];
    final locationString = locs.join(', ');

    // Parse rating and hourlyRate
    final double rating = service['rating'] != null
        ? (service['rating'] as num).toDouble()
        : 0.0;
    // If reviews are stored as an array, you might calculate the count.
    final int reviewsCount = (service['reviews'] is List)
        ? (service['reviews'] as List).length
        : 0;
    final double hourlyRate = service['hourlyRate'] != null
        ? (service['hourlyRate'] as num).toDouble()
        : 0.0;

    // Debug print: show key details for each service
    print("Service Card: $serviceName by $providerName, rating: $rating, rate: $hourlyRate");

    return GestureDetector(
      onTap: () {
        // Navigate to service detail screen with full service data.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(service: service),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6FAF8),
            borderRadius: BorderRadius.circular(16),
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
              // Cover image with fallback to asset if file not found
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: coverImage.isNotEmpty
                    ? Image.file(
                  File(coverImage),
                  width: 110,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/monkey.png',
                      width: 110,
                      height: 120,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : Image.asset(
                  'assets/images/monkey.png',
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
                    // Service name
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Provider name
                    Text(
                      'By $providerName',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Locations
                    Row(
                      children: [
                        const Text(
                          'Location: ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            locationString,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Rating & reviews
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
                    // Hourly Rate
                    Row(
                      children: [
                        Text(
                          'LKR ${hourlyRate.toStringAsFixed(2)}',
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
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

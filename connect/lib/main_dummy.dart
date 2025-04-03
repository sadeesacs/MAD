import 'package:flutter/material.dart';
import 'package:connect/Customer/screens/search-services/service_listing.dart';

void main() {
  runApp(const DummyApp());
}

class DummyApp extends StatelessWidget {
  const DummyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data matching the expected structure:
    final List<Map<String, dynamic>> dummyServices = [
      {
        'docId': 'abc123',
        'coverImage': '', // empty string => use fallback asset
        'serviceName': 'House Cleaning',
        'serviceProviderName': 'Alice Smith',
        'locations': ['Colombo', 'Gampaha'],
        'rating': 4.5,
        'reviews': [1, 2, 3], // dummy list, so count is 3
        'hourlyRate': 1500,
        'category': 'Cleaning',
        'status': 'Active',
      },
      {
        'docId': 'def456',
        'coverImage': '', // empty string => fallback asset
        'serviceName': 'Garden Maintenance',
        'serviceProviderName': 'Bob Johnson',
        'locations': ['Galle', 'Matara'],
        'rating': 3.8,
        'reviews': [1, 2],
        'hourlyRate': 2000,
        'category': 'Gardening',
        'status': 'Active',
      },
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchedServiceListingScreen(services: dummyServices),
    );
  }
}

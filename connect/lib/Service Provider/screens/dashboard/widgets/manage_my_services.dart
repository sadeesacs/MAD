import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopRatedSPWidget extends StatelessWidget {
  const TopRatedSPWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('services')
              .where('serviceProvider', isEqualTo: FirebaseFirestore.instance.doc('/users/${FirebaseAuth.instance.currentUser!.uid}'))
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final services = snapshot.data!.docs;

            if (services.isEmpty) {
              return const Text('No services available');
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: services.map((service) {
                  final data = service.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 200,
                      child: _buildTopRatedCard(data),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopRatedCard(Map<String, dynamic> service) {
    final double rating = (service['rating'] ?? 0).toDouble();
    final int roundedRating = rating.round();

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
            child: service['coverImage'] != null && service['coverImage'].isNotEmpty
                ? Image.file(
              File(service['coverImage']),
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
            )
                : Container(
              height: 80,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.image),
            ),
          ),
          const SizedBox(height: 8),

          // Service Title
          Text(
            service['serviceName'] ?? 'Unknown Service',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),

          // Category
          Text(
            service['category'] ?? 'Unknown Category',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // Rating
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
                rating.toStringAsFixed(1),
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
            'LKR ${service['hourlyRate']?.toString() ?? '0'}.00/h',
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
// lib/services/home_data_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Provides Firestore-based data for the Home screen:
///  - top-rated services
///  - latest 5-star reviews
class HomeDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch the top 2 highest-rated services from Firestore
  ///  - We assume rating is a [double] field named 'rating'
  ///  - We only want services with status == "Active"
  Future<List<Map<String, dynamic>>> fetchTopRatedServices({int limit = 2}) async {
    try {
      final querySnapshot = await _firestore
          .collection('services')
          .where('status', isEqualTo: 'Active')
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      // Convert each doc into a local map
      final services = <Map<String, dynamic>>[];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        // Insert doc id if needed
        data['id'] = doc.id;

        // Attempt local path check if `coverImage` exists
        data['coverImage'] = await _resolveLocalImagePath(data['coverImage']);

        services.add(data);
      }
      return services;
    } catch (e) {
      debugPrint('Error fetching top-rated services: $e');
      return [];
    }
  }

  /// Fetch the latest 5-star reviews (limit 5).
  ///  - We assume `rate` is a [double] field
  ///  - We store author reference, etc.
  Future<List<Map<String, dynamic>>> fetchLatestFiveStarReviews({int limit = 5}) async {
    try {
      final querySnapshot = await _firestore
          .collection('reviews')
          .where('rate', isEqualTo: 5.0)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final reviews = <Map<String, dynamic>>[];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // We might want to also fetch the category from the service if needed
        // If your review doc references the booking or the service, you can do that here.
        // For now, we assume the review has 'category' or we default.
        data['category'] = data['category'] ?? 'Unknown';

        // Convert doc to map
        reviews.add(data);
      }
      return reviews;
    } catch (e) {
      debugPrint('Error fetching 5-star reviews: $e');
      return [];
    }
  }

  /// Helper function to handle local file path or fallback to placeholder
  static Future<String> _resolveLocalImagePath(dynamic coverImagePath) async {
    if (coverImagePath == null || coverImagePath.toString().isEmpty) {
      return 'assets/images/monkey.png';
    }
    // If it doesn't start with '/', assume it's not local but some URL
    if (!coverImagePath.toString().startsWith('/')) {
      // Possibly a URL => we don't handle file existence for remote. Return as-is.
      return coverImagePath.toString();
    }
    // It's presumably a local file path
    final file = File(coverImagePath.toString());
    final exists = await file.exists();
    if (exists) {
      return coverImagePath.toString(); // local path is valid
    } else {
      // Fallback to placeholder
      return 'assets/images/monkey.png';
    }
  }
}

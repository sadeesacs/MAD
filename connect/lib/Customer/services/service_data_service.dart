// lib/services/service_data_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch services by category
  Future<List<Map<String, dynamic>>> fetchServicesByCategory(String categoryName) async {
    try {
      final querySnapshot = await _firestore
          .collection('services')
          .where('category', isEqualTo: categoryName)
          .where('status', isEqualTo: 'Active')
          .get();

      final results = <Map<String, dynamic>>[];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        // Save the document ID under the key 'docId' so that downstream code finds it.
        data['docId'] = doc.id;
        // Resolve local image path for coverImage
        data['coverImage'] = await _resolveLocalImagePath(data['coverImage']);
        results.add(data);
      }
      return results;
    } catch (e) {
      debugPrint('Error fetching services for $categoryName: $e');
      return [];
    }
  }

  static Future<String> _resolveLocalImagePath(dynamic coverImagePath) async {
    if (coverImagePath == null || coverImagePath.toString().isEmpty) {
      return 'assets/images/monkey.png';
    }
    if (!coverImagePath.toString().startsWith('/')) {
      return coverImagePath.toString();
    }
    final file = File(coverImagePath.toString());
    final exists = await file.exists();
    if (exists) {
      return coverImagePath.toString();
    } else {
      return 'assets/images/monkey.png';
    }
  }
}

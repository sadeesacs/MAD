// lib/Customer/services/home_data_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class HomeDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch top-rated services from 'services' collection
  /// sorted by descending 'rating', limited to [limit].
  Future<List<Map<String, dynamic>>> fetchTopRatedServices({int limit = 2}) async {
    try {
      // Query services with status='Active' (optional),
      // then order by 'rating' descending, limit to 'limit'.
      final query = await _firestore
          .collection('services')
          .where('status', isEqualTo: 'Active')
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      // Convert each doc to a Map, add 'serviceProviderName' if you want
      List<Map<String, dynamic>> services = [];
      for (var doc in query.docs) {
        final data = doc.data();
        data['docId'] = doc.id;
        services.add(data);
      }
      return services;
    } catch (e) {
      print('Error fetching top-rated services: $e');
      return [];
    }
  }

  /// Fetch the latest (or top) five-star (or top-rated) reviews from 'reviews' collection
  /// sorted by 'rate' descending, limited to [limit].
  Future<List<Map<String, dynamic>>> fetchLatestFiveStarReviews({int limit = 5}) async {
    try {
      final query = await _firestore
          .collection('reviews')
          .orderBy('rate', descending: true)
          .limit(limit)
          .get();

      List<Map<String, dynamic>> reviews = [];
      for (var doc in query.docs) {
        final data = doc.data();
        data['docId'] = doc.id;
        reviews.add(data);
      }
      return reviews;
    } catch (e) {
      print('Error fetching latest 5-star reviews: $e');
      return [];
    }
  }
}

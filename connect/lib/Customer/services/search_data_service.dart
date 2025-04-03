// lib/services/search_data_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Searches for services in Firestore that match the given filters.
  /// All filters are optional. Even if only a location is provided,
  /// it will return all services whose 'locations' array contains that value.
  Future<List<Map<String, dynamic>>> searchServices({
    String? category,
    String? district, // e.g. "Colombo"
    double? minPrice,
    double? maxPrice,
    int? minRating,
  }) async {
    try {
      // Start with the services collection
      CollectionReference servicesRef = _firestore.collection('services');

      // Always filter for Active services
      Query query = servicesRef.where('status', isEqualTo: 'Active');

      // Filter by category if provided
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      // Filter by rating if provided (only if > 0)
      if (minRating != null && minRating > 0) {
        query = query.where('rating', isGreaterThanOrEqualTo: minRating);
      }

      // Filter by hourlyRate if provided
      if (minPrice != null && minPrice > 0) {
        query = query.where('hourlyRate', isGreaterThanOrEqualTo: minPrice);
      }
      if (maxPrice != null && maxPrice > 0) {
        query = query.where('hourlyRate', isLessThanOrEqualTo: maxPrice);
      }

      QuerySnapshot querySnapshot = await query.get();

      List<Map<String, dynamic>> results = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // In-memory filter: if a district is specified, only include if the 'locations' array contains it.
        if (district != null && district.isNotEmpty) {
          List<dynamic> locs = data['locations'] as List<dynamic>? ?? [];
          if (!locs.contains(district)) {
            continue;
          }
        }

        // Fetch the service provider name from the 'users' collection
        if (data['serviceProvider'] != null) {
          try {
            DocumentReference providerRef = data['serviceProvider'];
            DocumentSnapshot providerDoc = await providerRef.get();
            if (providerDoc.exists) {
              Map<String, dynamic> providerData =
              providerDoc.data() as Map<String, dynamic>;
              data['serviceProviderName'] =
                  providerData['name'] ?? 'Unknown Provider';
            } else {
              data['serviceProviderName'] = 'Unknown Provider';
            }
          } catch (e) {
            data['serviceProviderName'] = 'Unknown Provider';
          }
        } else {
          data['serviceProviderName'] = 'Unknown Provider';
        }

        // Ensure the rating is a double
        data['rating'] = (data['rating'] is int)
            ? (data['rating'] as int).toDouble()
            : (data['rating']?.toDouble() ?? 0.0);

        // Ensure we have a reviews count (if not present, default to 0)
        data['reviews'] = data['reviews'] ?? 0;

        // Add the document ID to the data for reference
        data['id'] = doc.id;

        results.add(data);
      }

      return results;
    } catch (e) {
      print('Error in searchServices: $e');
      rethrow;
    }
  }
}

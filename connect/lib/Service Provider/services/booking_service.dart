import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current service provider ID
  String? get currentUserId {
    final user = _auth.currentUser;
    print('Current user: ${user?.uid ?? "not logged in"}');
    return user?.uid;
  }
  
  // Get pending requests for service provider
  Stream<QuerySnapshot> getPendingRequests() {
    print('Getting pending requests, current user ID: $currentUserId');
    // Query bookings where status is pending
    return _firestore
        .collection('booking')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Get scheduled jobs for service provider
  Stream<QuerySnapshot> getScheduledJobs() {
    return _firestore
        .collection('booking')
        .where('status', isEqualTo: 'accepted')
        .snapshots();
  }

  // Get completed jobs for service provider
  Stream<QuerySnapshot> getCompletedJobs() {
    return _firestore
        .collection('booking')
        .where('status', isEqualTo: 'completed')
        .snapshots();
  }

  // Process bookings to only show those belonging to current service provider
  Future<bool> isServiceProviderForBooking(Map<String, dynamic> booking) async {
    try {
      final service = booking['service'] as DocumentReference?;
      if (service == null) {
        print('Booking has no service reference');
        return false;
      }
      
      // Get the service document
      final serviceDoc = await service.get();
      
      if (!serviceDoc.exists) {
        print('Service document does not exist');
        return false;
      }
      
      // Check if currentUserId matches serviceProvider field
      final serviceData = serviceDoc.data() as Map<String, dynamic>;
      final serviceProviderId = serviceData['serviceProvider'];
      
      // Debug prints to check values
      print('Service ID: ${service.id}');
      print('Current User ID: $currentUserId');
      print('Service Provider ID: $serviceProviderId');
      
      // Check if the current user is the service provider for this service
      if (serviceProviderId == null) {
        print('Service has no provider ID');
        return false;
      }
      
      // If serviceProvider is a reference, extract the ID
      String providerIdToCompare;
      if (serviceProviderId is DocumentReference) {
        providerIdToCompare = serviceProviderId.id;
        print('Service provider is a reference with ID: $providerIdToCompare');
      } else {
        providerIdToCompare = serviceProviderId.toString();
        print('Service provider is a string: $providerIdToCompare');
      }
      
      final isMatch = providerIdToCompare == currentUserId;
      print('Is current user the service provider? $isMatch');
      return isMatch;
    } catch (e) {
      print('Error checking if service provider for booking: $e');
      return false;
    }
  }

  // Filter a list of booking docs to only those belonging to logged-in provider
  Future<List<DocumentSnapshot>> filterBookingsByCurrentProvider(List<DocumentSnapshot> bookings) async {
    if (currentUserId == null) {
      print('No user is logged in');
      return [];
    }
    
    List<DocumentSnapshot> filteredBookings = [];
    
    for (var doc in bookings) {
      final data = doc.data() as Map<String, dynamic>;
      if (await isServiceProviderForBooking(data)) {
        filteredBookings.add(doc);
      }
    }
    
    print('Filtered ${bookings.length} bookings to ${filteredBookings.length} for current provider');
    return filteredBookings;
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('booking').doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  // Get user data (customer info) from reference or ID
  Future<Map<String, dynamic>> getCustomerData(dynamic customer) async {
    if (customer == null) {
      print('Warning: Null customer reference provided');
      return {
        'name': 'Unknown User',
        'profile_pic': 'https://via.placeholder.com/150',
      };
    }
    
    String customerId;
    
    // Handle different types of customer identifiers
    if (customer is DocumentReference) {
      customerId = customer.id;
    } else if (customer is String && customer.contains('/')) {
      // Handle path-like strings "/users/userId"
      customerId = customer.split('/').last;
    } else {
      // Assume it's a direct user ID
      customerId = customer.toString();
    }
    
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(customerId).get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('User document not found or empty for ID: $customerId');
        return {
          'name': 'Unknown User',
          'profile_pic': 'https://via.placeholder.com/150',
        };
      }
    } catch (e) {
      print('Error getting customer data: $e');
      return {
        'name': 'Unknown User',
        'profile_pic': 'https://via.placeholder.com/150',
      };
    }
  }

  // Get service data from reference or ID
  Future<Map<String, dynamic>> getServiceData(dynamic service) async {
    if (service == null) {
      print('Warning: Null service reference provided');
      return {'category': 'Unknown Service', 'serviceName': 'Unknown Service'};
    }
    
    String serviceId;
    
    // Handle different types of service identifiers
    if (service is DocumentReference) {
      serviceId = service.id;
    } else if (service is String && service.contains('/')) {
      // Handle path-like strings "/services/serviceId"
      serviceId = service.split('/').last;
    } else {
      // Assume it's a direct service ID
      serviceId = service.toString();
    }
    
    try {
      DocumentSnapshot serviceDoc = await _firestore.collection('services').doc(serviceId).get();
      print('Fetching service data for ID: $serviceId - exists: ${serviceDoc.exists}');
      
      if (serviceDoc.exists && serviceDoc.data() != null) {
        final data = serviceDoc.data() as Map<String, dynamic>;
        // Add the ID to the data for easier reference
        return {
          ...data,
          'id': serviceId,
        };
      } else {
        print('Service not found for ID: $serviceId');
        return {'category': 'Unknown Service', 'serviceName': 'Unknown Service', 'id': serviceId};
      }
    } catch (e) {
      print('Error getting service data: $e');
      return {'category': 'Unknown Service', 'serviceName': 'Unknown Service', 'id': serviceId};
    }
  }

  // Fetch review from a review reference or by booking ID
  Future<Map<String, dynamic>> getBookingReview(dynamic reviewRef, [String? bookingId]) async {
    try {
      if (reviewRef is DocumentReference) {
        // Get the review directly from the reference
        DocumentSnapshot reviewDoc = await reviewRef.get();
        if (reviewDoc.exists) {
          return reviewDoc.data() as Map<String, dynamic>;
        }
      } else if (bookingId != null) {
        // Try to find the review by querying with the booking ID
        final querySnapshot = await _firestore
            .collection('reviews')
            .where('bookingId', isEqualTo: bookingId)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first.data();
        }
      }
      
      // Default value if no review found
      return {'rating': 0, 'review': 'No review provided'};
    } catch (e) {
      print('Error fetching review: $e');
      return {'rating': 0, 'review': 'Error loading review'};
    }
  }
  
  // Format Firestore timestamp to readable string
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }
}

// lib/Service Provider/screens/completed_jobs/completed_jobs.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../services/booking_service.dart';
import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'widgets/completed_jobs_card.dart';
import 'package:connect/Service Provider/screens/dashboard/dashboard_screen.dart';

class CompletedJobsScreen extends StatefulWidget {
  const CompletedJobsScreen({super.key});

  @override
  State<CompletedJobsScreen> createState() => _CompletedJobsScreenState();
}

class _CompletedJobsScreenState extends State<CompletedJobsScreen> {
  final ScrollController _scrollController = ScrollController();
  final BookingService _bookingService = BookingService();
  bool _hideNavBar = false;
  double _lastOffset = 0;
  final Map<String, Map<String, dynamic>> _customerDataCache = {};
  final Map<String, Map<String, dynamic>> _serviceDataCache = {};
  final Map<String, Map<String, dynamic>> _reviewDataCache = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && offset > _lastOffset) {
      if (!_hideNavBar) setState(() => _hideNavBar = true);
    } else if (direction == ScrollDirection.forward && offset < _lastOffset) {
      if (_hideNavBar) setState(() => _hideNavBar = false);
    }
    _lastOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Get customer data with caching
  Future<Map<String, dynamic>> _getCachedCustomerData(dynamic customer) async {
    String customerId;
    if (customer is DocumentReference) {
      customerId = customer.id;
    } else if (customer is String && customer.contains('/')) {
      customerId = customer.split('/').last;
    } else {
      customerId = customer.toString();
    }
    if (_customerDataCache.containsKey(customerId)) {
      return _customerDataCache[customerId]!;
    }
    final userData = await _bookingService.getCustomerData(customer);
    _customerDataCache[customerId] = userData;
    return userData;
  }

  // Get service data with caching
  Future<Map<String, dynamic>> _getCachedServiceData(dynamic service) async {
    String serviceId;
    if (service is DocumentReference) {
      serviceId = service.id;
    } else if (service is String && service.contains('/')) {
      serviceId = service.split('/').last;
    } else {
      serviceId = service.toString();
    }
    if (_serviceDataCache.containsKey(serviceId)) {
      return _serviceDataCache[serviceId]!;
    }
    final serviceData = await _bookingService.getServiceData(service);
    _serviceDataCache[serviceId] = serviceData;
    return serviceData;
  }

  // Get review data with caching
  Future<Map<String, dynamic>> _getCachedReviewData(String bookingId, DocumentReference? reviewRef) async {
    if (_reviewDataCache.containsKey(bookingId)) {
      return _reviewDataCache[bookingId]!;
    }
    final reviewData = await _bookingService.getBookingReview(reviewRef, bookingId);
    _reviewDataCache[bookingId] = reviewData;
    return reviewData;
  }

  // Process completed job data for display
  Map<String, dynamic> _createCompletedJobDataForDisplay(String docId, Map<String, dynamic> data,
      Map<String, dynamic> customerData, Map<String, dynamic> serviceData,
      [Map<String, dynamic>? reviewData]) {
    // Format date from Timestamp
    String dateStr = '';
    if (data['date'] is Timestamp) {
      dateStr = _bookingService.formatTimestamp(data['date'] as Timestamp);
    } else {
      dateStr = data['date']?.toString() ?? '';
    }

    // Format review date if available
    String reviewDateStr = '';
    if (reviewData != null && reviewData['date'] is Timestamp) {
      reviewDateStr = _bookingService.formatTimestamp(reviewData['date'] as Timestamp);
    }

    return {
      'bookingId': docId,
      'serviceType': serviceData['category'] ?? 'Unknown Service',
      'serviceName': serviceData['serviceName'] ?? 'Unknown Service',
      'customer': customerData['name'] ?? 'Unknown Customer',
      'date': dateStr,
      'time': data['time'] ?? '',
      'total': data['total'] ?? '',
      'district': data['district'] ?? '',
      'rating': reviewData != null ? (reviewData['rate'] as num?)?.toInt() ?? 0 : 0,
      'review': reviewData != null ? reviewData['comment'] ?? 'No review provided' : 'No review yet',
      'reviewDate': reviewDateStr,
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Redirect to DashboardScreen when the back button is pressed.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const ConnectAppBarSP(),
        endDrawer: const SPHamburgerMenu(),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _bookingService.getCompletedJobs(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No completed jobs'));
                }
                final allCompletedJobs = snapshot.data!.docs;
                return FutureBuilder<List<DocumentSnapshot>>(
                  future: _bookingService.filterBookingsByCurrentProvider(allCompletedJobs),
                  builder: (context, filteredSnapshot) {
                    if (filteredSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (filteredSnapshot.hasError) {
                      return Center(child: Text('Error: ${filteredSnapshot.error}'));
                    }
                    final completedJobs = filteredSnapshot.data ?? [];
                    if (completedJobs.isEmpty) {
                      return const Center(child: Text('No completed jobs for you'));
                    }
                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            'Completed Jobs',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Color(0xFF027335),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Preload customer, service, and review data
                          FutureBuilder(
                            future: Future.wait([
                              ...completedJobs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return _getCachedCustomerData(data['customer']);
                              }),
                              ...completedJobs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return _getCachedServiceData(data['service']);
                              }),
                              ...completedJobs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return _getCachedReviewData(doc.id, data['customer_reviews']);
                              })
                            ]),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return Column(
                                children: completedJobs.map((doc) {
                                  final jobData = doc.data() as Map<String, dynamic>;
                                  final customer = jobData['customer'];
                                  final service = jobData['service'];
                                  String customerId = customer is DocumentReference
                                      ? customer.id
                                      : customer.toString().contains('/')
                                      ? customer.toString().split('/').last
                                      : customer.toString();
                                  String serviceId = service is DocumentReference
                                      ? service.id
                                      : service.toString().contains('/')
                                      ? service.toString().split('/').last
                                      : service.toString();
                                  final customerData = _customerDataCache[customerId] ??
                                      {'name': 'Loading...', 'profile_pic': ''};
                                  final serviceData = _serviceDataCache[serviceId] ??
                                      {'category': 'Loading...', 'serviceName': 'Loading...'};
                                  final reviewData = _reviewDataCache[doc.id];
                                  final processedData = _createCompletedJobDataForDisplay(
                                    doc.id,
                                    jobData,
                                    customerData,
                                    serviceData,
                                    reviewData,
                                  );
                                  return CompletedJobsCard(
                                    bookingData: processedData,
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            // Floating navigation bar that hides on scroll.
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 500),
                offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
                child: const ConnectNavBarSP(
                  isHomeSelected: false,
                  isToolsSelected: false,
                  isCalendarSelected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

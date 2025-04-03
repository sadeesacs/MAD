// lib/Customer/screens/service-detail/service_detail.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../bookings/booking/booking_screen.dart';
import '../bookings/booking_form_data.dart';
import 'widgets/bottom_buttons.dart';
import 'widgets/job_description.dart';
import 'widgets/recent_jobs.dart';
import 'widgets/reviews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/service_data_service.dart';
import 'package:connect/util/image_provider_helper.dart'; // Your helper for images

const Color darkGreen = Color(0xFF027335);
const Color greyText  = Colors.grey;
const Color white     = Colors.white;
const Color black     = Colors.black;

class ServiceDetailScreen extends StatefulWidget {
  /// The passed service map must include at least a 'docId'
  /// which is the Firestore document id for the service.
  final Map<String, dynamic> service;

  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _isLoading = true;
  String? _error;

  // Data fetched from Firestore:
  Map<String, dynamic> _serviceData = {};
  String _providerName = 'Unknown';

  // Computed average rating from reviews:
  double _computedRating = 0.0;
  // Recent jobs list and reviews list:
  List<Map<String, dynamic>> _recentJobsData = [];
  List<Map<String, dynamic>> _reviewsData = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    try {
      // 1. Ensure docId is provided
      final String? docId = widget.service['docId'] as String?;
      if (docId == null) {
        throw Exception("No 'docId' found in the service map.");
      }

      // 2. Fetch service document from Firestore
      final serviceDoc = await FirebaseFirestore.instance
          .collection('services')
          .doc(docId)
          .get();

      if (!serviceDoc.exists) {
        throw Exception("Service document does not exist for docId: $docId");
      }

      final data = serviceDoc.data() as Map<String, dynamic>;
      // Store the fetched service data and add the docId into it.
      _serviceData = {...data, 'docId': docId};

      // 3. Fetch the service provider's name from the user doc.
      if (_serviceData['serviceProvider'] is DocumentReference) {
        final DocumentReference providerRef = _serviceData['serviceProvider'];
        final providerSnap = await providerRef.get();
        if (providerSnap.exists) {
          final userData = providerSnap.data() as Map<String, dynamic>;
          _providerName = userData['name'] ?? 'Unknown';
        }
      }

      // 4. Fetch recent jobs (if stored as references in the 'recentJobs' array)
      if (_serviceData['recentJobs'] != null && _serviceData['recentJobs'] is List) {
        List<dynamic> jobsRefs = _serviceData['recentJobs'];
        _recentJobsData = await _fetchRecentJobs(jobsRefs);
      }

      // 5. Fetch reviews and compute average rating.
      if (_serviceData['reviews'] != null && _serviceData['reviews'] is List) {
        List<dynamic> reviewRefs = _serviceData['reviews'];
        _reviewsData = await _fetchReviews(reviewRefs);

        if (_reviewsData.isNotEmpty) {
          double sum = 0.0;
          for (var rv in _reviewsData) {
            sum += (rv['rate'] ?? 0.0);
          }
          _computedRating = sum / _reviewsData.length;
        }
      } else {
        _computedRating = (_serviceData['rating']?.toDouble()) ?? 0.0;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchRecentJobs(List<dynamic> jobRefs) async {
    List<Map<String, dynamic>> results = [];
    for (var ref in jobRefs) {
      if (ref is DocumentReference) {
        final snap = await ref.get();
        if (snap.exists) {
          results.add(snap.data() as Map<String, dynamic>);
        }
      }
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> _fetchReviews(List<dynamic> rvRefs) async {
    List<Map<String, dynamic>> results = [];
    for (var ref in rvRefs) {
      if (ref is DocumentReference) {
        final snap = await ref.get();
        if (snap.exists) {
          results.add(snap.data() as Map<String, dynamic>);
        }
      }
    }
    return results;
  }

  Widget _buildCoverImage(String path) {
    // Use your helper to get the correct ImageProvider
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.grey[200],
        height: 200,
        width: double.infinity,
        child: Image(
          image: getImageProvider(path), // Uses a helper that checks local path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStarRow(double rating) {
    const totalStars = 5;
    int filledStars = rating.floor();
    bool hasHalf = (rating - filledStars) >= 0.5;
    List<Widget> stars = [];
    for (int i = 0; i < filledStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.orange));
    }
    if (hasHalf) {
      stars.add(const Icon(Icons.star_half, color: Colors.orange));
    }
    while (stars.length < totalStars) {
      stars.add(const Icon(Icons.star_border, color: Colors.orange));
    }
    return Row(children: stars);
  }

  Widget _locationChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF8),
        border: Border.all(color: darkGreen),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(label, style: const TextStyle(color: black)),
    );
  }

  Widget _buildTabSection(String jobDescription, List<Map<String, dynamic>> recentJobs, List<Map<String, dynamic>> reviewsData) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: darkGreen,
            labelColor: black,
            unselectedLabelColor: greyText,
            tabs: [
              Tab(text: 'Job Description'),
              Tab(text: 'Recent Jobs'),
              Tab(text: 'Reviews'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                JobDescription(description: jobDescription),
                RecentJobs(recentJobsList: recentJobs),
                Reviews(reviewsList: reviewsData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: const ConnectAppBar(),
        body: Center(child: Text('Error: $_error')),
      );
    }

    // Unpack fields from _serviceData
    final String category   = _serviceData['category']   ?? 'Unknown Category';
    final String coverImage = _serviceData['coverImage'] ?? 'assets/images/monkey.png';
    final String serviceName= _serviceData['serviceName'] ?? 'Untitled';
    final double hourlyRate = _serviceData['hourlyRate']?.toDouble() ?? 0.0;
    final List locations    = _serviceData['locations']    ?? [];
    final String jobDesc    = _serviceData['jobDescription'] ?? 'No description available';

    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: back button and category text
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFE9E3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF027335),
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      category,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 18),

                // Cover image
                _buildCoverImage(coverImage),
                const SizedBox(height: 12),

                // Service title and provider name
                Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  'By $_providerName',
                  style: TextStyle(
                    color: greyText,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 7),

                // Star rating and hourly rate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStarRow(_computedRating),
                    Text(
                      'LKR ${hourlyRate.toStringAsFixed(2)}/h',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Location chips
                Wrap(
                  spacing: 8,
                  children: [
                    for (var loc in locations) _locationChip(loc.toString()),
                  ],
                ),
                const SizedBox(height: 16),

                // Tab section: Job Description, Recent Jobs, Reviews
                _buildTabSection(jobDesc, _recentJobsData, _reviewsData),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Bottom Buttons: Book Now button integration
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomButtons(
              onMessageTap: () {
                // Implement messaging functionality if needed
              },
              onBookNowTap: () {
                // Create booking form data with required fields.
                final bookingFormData = BookingFormData(
                  serviceId: _serviceData['docId'] ?? '', // using the docId from Firestore
                  serviceTitle: serviceName,
                  providerName: _providerName,
                  pricePerHour: hourlyRate,
                  category: category,
                  imageUrl: coverImage,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(formData: bookingFormData),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

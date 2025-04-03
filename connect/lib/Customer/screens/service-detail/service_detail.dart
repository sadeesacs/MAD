import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Adjust these paths as needed in your project
import '../../../util/image_provider_helper.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../bookings/booking/booking_screen.dart';
import '../bookings/booking_form_data.dart';

import 'widgets/bottom_buttons.dart';
import 'widgets/job_description.dart';
import 'widgets/recent_jobs.dart';
import 'widgets/reviews.dart';

const Color darkGreen = Color(0xFF027335);
const Color greyText  = Colors.grey;
const Color white     = Colors.white;
const Color black     = Colors.black;

/// A screen that shows details for a given service.
/// [service] map should include at least a 'docId' (String)
/// that we can use to fetch the up-to-date data from Firestore.
class ServiceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _isLoading = true;
  String? _error;

  // Aggregated data after fetching
  Map<String, dynamic> _serviceData = {};
  String _providerName = 'Unknown';

  // The combined average rating from reviews
  double _computedRating = 0.0;
  // The list of recent jobs
  List<Map<String, dynamic>> _recentJobsData = [];
  // The list of reviews
  List<Map<String, dynamic>> _reviewsData = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  /// Fetches the main service doc, the provider name,
  /// the recent jobs, and the reviews from Firestore
  Future<void> _fetchAllData() async {
    try {
      // 1. We expect a docId in widget.service['docId']
      final String? docId = widget.service['docId'] as String?;
      if (docId == null) {
        throw Exception("No 'docId' found in the service map.");
      }

      // 2. Fetch service doc
      final serviceDoc = await FirebaseFirestore.instance
          .collection('services')
          .doc(docId)
          .get();
      if (!serviceDoc.exists) {
        throw Exception("Service document does not exist for docId: $docId");
      }

      final data = serviceDoc.data() as Map<String, dynamic>;
      // Store entire service data
      _serviceData = data;

      // 3. Get the provider's name from the user doc
      if (data['serviceProvider'] is DocumentReference) {
        final DocumentReference providerRef = data['serviceProvider'];
        final providerSnap = await providerRef.get();
        if (providerSnap.exists) {
          final userData = providerSnap.data() as Map<String, dynamic>;
          _providerName = userData['name'] ?? 'Unknown';
        }
      }

      // 4. Fetch recent jobs
      if (data['recentJobs'] != null && data['recentJobs'] is List) {
        List<dynamic> jobsRefs = data['recentJobs'];
        _recentJobsData = await _fetchRecentJobs(jobsRefs);
      }

      // 5. Fetch reviews
      // If you store references in a field named 'reviews', do this:
      if (data['reviews'] != null && data['reviews'] is List) {
        List<dynamic> reviewRefs = data['reviews'];
        _reviewsData = await _fetchReviews(reviewRefs);

        // Also compute average rating from these fetched reviews
        if (_reviewsData.isNotEmpty) {
          double sum = 0.0;
          for (var rv in _reviewsData) {
            sum += (rv['rate'] ?? 0.0);
          }
          _computedRating = sum / _reviewsData.length;
        }
      } else {
        // If you store rating separately, e.g. data['rating']
        // you can keep using that or combine them as needed
        _computedRating = (data['rating']?.toDouble()) ?? 0.0;
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

  /// Helper to fetch multiple recent jobs from the list of references
  Future<List<Map<String, dynamic>>> _fetchRecentJobs(List<dynamic> jobRefs) async {
    List<Map<String, dynamic>> results = [];
    for (var ref in jobRefs) {
      if (ref is DocumentReference) {
        final snap = await ref.get();
        if (snap.exists) {
          final jobData = snap.data() as Map<String, dynamic>;
          results.add(jobData);
        }
      }
    }
    return results;
  }

  /// Helper to fetch multiple reviews from the list of references
  Future<List<Map<String, dynamic>>> _fetchReviews(List<dynamic> rvRefs) async {
    List<Map<String, dynamic>> results = [];
    for (var ref in rvRefs) {
      if (ref is DocumentReference) {
        final snap = await ref.get();
        if (snap.exists) {
          final reviewData = snap.data() as Map<String, dynamic>;
          results.add(reviewData);
        }
      }
    }
    return results;
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

    // Unpack the fields from _serviceData
    final String category   = _serviceData['category']     ?? 'Unknown Category';
    final String coverImage = _serviceData['coverImage']   ?? '';
    final String serviceName= _serviceData['serviceName']  ?? 'Untitled';
    final double hourlyRate = _serviceData['hourlyRate']?.toDouble() ?? 0.0;
    final List locations    = _serviceData['locations']    ?? [];
    final String jobDesc    = _serviceData['jobDescription'] ?? 'No description...';

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
                // Row for back + category text
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

                // Title + Provider
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

                // Dynamic rating from either _computedRating or doc field
                // and dynamic price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // A quick star display for demonstration:
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

                // location chips from the array
                Wrap(
                  spacing: 8,
                  children: [
                    for (var loc in locations) _locationChip(loc.toString()),
                  ],
                ),
                const SizedBox(height: 16),

                // Tab Section (job desc, recent jobs, reviews)
                _buildTabSection(jobDesc, _recentJobsData, _reviewsData),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // (Optional) You might have a bottom bar like "Message" + "Book Now"
          // If you are skipping it for now, you can omit this part
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(), // or your BottomButtons widget
          ),
        ],
      ),
    );
  }

  /// Helper to build the cover image (with fallback)
  Widget _buildCoverImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.grey[200],
        height: 200,
        width: double.infinity,
        child: Image(
          image: getImageProvider(path),  // from your image_provider_helper
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Star row for the rating. A simple approach:
  Widget _buildStarRow(double rating) {
    // e.g. 3.5 => 3.5 stars
    const totalStars = 5;
    // Round down
    int filledStars = rating.floor();
    bool hasHalf = (rating - filledStars) >= 0.5;

    List<Widget> stars = [];
    for (int i = 0; i < filledStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.orange));
    }
    if (hasHalf) {
      stars.add(const Icon(Icons.star_half, color: Colors.orange));
    }
    // fill rest with star_border
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

  /// The 3-tab section
  Widget _buildTabSection(
      String jobDescription,
      List<Map<String, dynamic>> recentJobs,
      List<Map<String, dynamic>> reviewsData,
      ) {
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
                // 1) Job Description
                JobDescription(description: jobDescription),

                // 2) Recent Jobs
                RecentJobs(recentJobsList: recentJobs),

                // 3) Reviews
                Reviews(reviewsList: reviewsData),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

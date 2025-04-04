// lib/Service Provider/screens/dashboard/dashboard_screen.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Service%20Provider/screens/dashboard/widgets/manage_my_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/connect_app_bar_sp.dart' show ConnectAppBarSP;
import '../../widgets/connect_nav_bar_sp.dart' show ConnectNavBarSP;
import '../../widgets/sp_hamburger_menu.dart';
import 'widgets/customer_reviews_sp_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  // User profile data
  User? user = FirebaseAuth.instance.currentUser;
  String _userName = 'User';
  String? _profilePicUrl;

  // Service counts
  int completedServices = 0;
  int upcomingServices = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchUserData();
    _fetchServiceCounts();
  }

  Future<void> _fetchUserData() async {
    try {
      if (user == null || user!.email == null) {
        print('User or user email is null');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print('Fetching user data for email: ${user!.email}');

      // Try to get user by email first
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .limit(1)
          .get();

      // If no documents found by email, try with UID
      if (querySnapshot.docs.isEmpty) {
        print('No user found by email, trying with UID: ${user!.uid}');
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user!.uid)
            .limit(1)
            .get();
      }

      // If still no document, try direct document lookup by UID
      if (querySnapshot.docs.isEmpty) {
        print('Trying direct document lookup with UID: ${user!.uid}');
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data()!;
          print('Found user data by direct lookup: ${userData['name']}');

          setState(() {
            _userName = userData['name'] ?? 'User';
            _profilePicUrl = userData['profile_pic'];
          });
        } else {
          print('No user document found by any method');
          // Use Firebase Auth data as fallback
          setState(() {
            _userName = user!.displayName ?? 'User';
            _profilePicUrl = user!.photoURL;
          });
        }
      } else {
        final userData = querySnapshot.docs.first.data();
        print('Found user data by query: ${userData['name']}');

        setState(() {
          _userName = userData['name'] ?? 'User';
          _profilePicUrl = userData['profile_pic'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Use Firebase Auth data as fallback
      if (user != null) {
        setState(() {
          _userName = user!.displayName ?? 'User';
          _profilePicUrl = user!.photoURL;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchServiceCounts() async {
    try {
      if (user == null) {
        print('User is null, cannot fetch service counts');
        return;
      }

      // First get all bookings
      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('booking')
          .get();

      int completed = 0;
      int upcoming = 0;

      // Process each booking to check if the current user is the service provider
      for (var booking in bookingsSnapshot.docs) {
        final bookingData = booking.data();

        // Get the service reference from booking
        if (bookingData['service'] != null) {
          final serviceRef = bookingData['service'] as DocumentReference;
          final serviceDoc = await serviceRef.get();

          if (serviceDoc.exists) {
            final serviceData = serviceDoc.data() as Map<String, dynamic>;

            // Check if serviceProvider field exists and points to current user
            if (serviceData['serviceProvider'] != null) {
              final serviceProviderRef = serviceData['serviceProvider'] as DocumentReference;

              // If this booking's service provider is the current user
              if (serviceProviderRef.id == user!.uid) {
                // Count based on status
                final status = bookingData['status'];
                if (status == 'completed') {
                  completed++;
                } else if (status == 'accepted') {
                  upcoming++;
                }
              }
            }
          }
        }
      }

      setState(() {
        completedServices = completed;
        upcomingServices = upcoming;
      });
    } catch (e) {
      print('Error fetching service counts: $e');
    }
  }

  void _onScroll() {
    final offset = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;

    // Hide nav bar on scroll down, show on scroll up
    if (direction == ScrollDirection.reverse && offset > _lastOffset) {
      if (!_hideNavBar) {
        setState(() => _hideNavBar = true);
      }
    } else if (direction == ScrollDirection.forward && offset < _lastOffset) {
      if (_hideNavBar) {
        setState(() => _hideNavBar = false);
      }
    }
    _lastOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildStatsCard({
    required String title,
    required int count,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF027335), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF027335), width: 1.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF027335),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Profile image widget based on _profilePicUrl
  Widget _buildProfileImage() {
    if (_profilePicUrl != null && _profilePicUrl!.isNotEmpty) {
      if (_profilePicUrl!.startsWith('/')) {
        // Local file path
        return ClipOval(
          child: Image.file(
            File(_profilePicUrl!),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/profile_pic/leo_perera.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      } else {
        // Remote URL
        return ClipOval(
          child: Image.network(
            _profilePicUrl!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/profile_pic/leo_perera.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      }
    } else {
      // Fallback to default image
      return ClipOval(
        child: Image.asset(
          'assets/images/profile_pic/leo_perera.jpg',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _buildJobRequestCard(Map<String, dynamic> job) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Title
          Text(
            job['serviceTitle'] ?? '',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job['customerName'] ?? '',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                job['requestedDate'] ?? '',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchServiceData(
      DocumentReference serviceRef) async {
    final serviceDoc = await serviceRef.get();
    return serviceDoc.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _fetchCustomerData(
      DocumentReference customerRef) async {
    final customerDoc = await customerRef.get();
    return customerDoc.data() as Map<String, dynamic>;
  }

  // Filter bookings to only show those belonging to current service provider
  Future<List<DocumentSnapshot>> _filterBookingsByServiceProvider(
      List<DocumentSnapshot> bookings) async {
    List<DocumentSnapshot> filteredBookings = [];

    for (var doc in bookings) {
      final bookingData = doc.data() as Map<String, dynamic>;
      if (bookingData['service'] == null) continue;

      final serviceRef = bookingData['service'] as DocumentReference;
      final serviceDoc = await serviceRef.get();

      if (serviceDoc.exists) {
        final serviceData = serviceDoc.data() as Map<String, dynamic>;

        if (serviceData['serviceProvider'] != null) {
          final serviceProviderRef = serviceData['serviceProvider'] as DocumentReference;
          if (user != null && serviceProviderRef.id == user!.uid) {
            if (bookingData['status'] == 'pending') {
              filteredBookings.add(doc);
            }
          }
        }
      }
    }

    return filteredBookings;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation (stay on this screen)
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const ConnectAppBarSP(),
        endDrawer: const SPHamburgerMenu(),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome & Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Welcome, $_userName',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Color(0xFF027335),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      _buildProfileImage(),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Completed & Upcoming Services
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatsCard(
                          title: 'Completed Services',
                          count: completedServices,
                          icon: Icons.check,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: _buildStatsCard(
                          title: 'Upcoming Services',
                          count: upcomingServices,
                          icon: Icons.priority_high,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // New Job Requests
                  const Text(
                    'New Job Requests',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Color(0xFF027335),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Container(
                    height: 253,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6FAF6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('booking')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final docs = snapshot.data?.docs ?? [];
                        return FutureBuilder<List<DocumentSnapshot>>(
                          future: _filterBookingsByServiceProvider(docs),
                          builder: (context, filteredSnapshot) {
                            if (filteredSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (filteredSnapshot.hasError) {
                              return const Text('Error filtering bookings');
                            }
                            final filteredBookings = filteredSnapshot.data ?? [];
                            if (filteredBookings.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No job requests available',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredBookings.length,
                              separatorBuilder: (_, __) => const Divider(
                                color: Colors.black,
                                thickness: 1,
                                height: 1,
                              ),
                              itemBuilder: (context, index) {
                                final booking = filteredBookings[index];
                                final bookingData =
                                booking.data() as Map<String, dynamic>;
                                final serviceRef =
                                bookingData['service'] as DocumentReference;
                                final customerRef =
                                bookingData['customer'] as DocumentReference;

                                return FutureBuilder<Map<String, dynamic>>(
                                  future: Future.wait([
                                    _fetchServiceData(serviceRef),
                                    _fetchCustomerData(customerRef),
                                  ]).then((results) => {
                                    'serviceTitle': results[0]['serviceName'],
                                    'customerName': results[1]['name'],
                                    'requestedDate': DateFormat('yyyy-MM-dd HH:mm')
                                        .format((bookingData['date'] as Timestamp)
                                        .toDate()),
                                  }),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return const Text('Error loading job request');
                                    }
                                    final job = snapshot.data!;
                                    return _buildJobRequestCard(job);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Top Rated
                  const TopRatedSPWidget(),
                  const SizedBox(height: 30),

                  // Customer Reviews
                  const CustomerReviewsSPWidget(),
                ],
              ),
            ),
            // Floating Nav Bar that hides on scroll
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 500),
                offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
                child: ConnectNavBarSP(
                  isHomeSelected: false,
                  isToolsSelected: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

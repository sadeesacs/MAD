import 'package:connect/Service%20Provider/screens/dashboard/widgets/manage_my_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar_sp.dart' show ConnectAppBarSP;
import '../../widgets/connect_nav_bar_sp.dart' show ConnectNavBarSP;
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

  int completedServices = 15;
  int upcomingServices = 10;

  final List<Map<String, String>> _jobRequests = [
    {
      'serviceTitle': 'Kitchen cleaning',
      'customerName': 'Kusal Mendis',
      'requestedDate': '2025-05-07',
    },
    {
      'serviceTitle': 'Gardening',
      'customerName': 'Dasun Shanaka',
      'requestedDate': '2025-05-07',
    },
    {
      'serviceTitle': 'Tree Planter',
      'customerName': 'Ryan Renolds',
      'requestedDate': '2025-05-07',
    },
    {
      'serviceTitle': 'Car Wash',
      'customerName': 'Chamika Karun',
      'requestedDate': '2025-05-08',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
              fontWeight: FontWeight.w500, // Medium
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
                  fontWeight: FontWeight.w600, // SemiBold
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

  Widget _buildJobRequestCard(Map<String, String> job) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
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
                    const Text(
                      'Welcome, Leo Perera',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Color(0xFF027335),
                      ),
                    ),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile_pic/leo_perera.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                    fontWeight: FontWeight.w600, // SemiBold
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
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _jobRequests.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final job = _jobRequests[index];
                      return _buildJobRequestCard(job);
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
                // Home is highlighted here
                isHomeSelected: true,
                isToolsSelected: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
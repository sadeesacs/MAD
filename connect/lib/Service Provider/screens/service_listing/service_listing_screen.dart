import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar_sp.dart' show ConnectAppBarSP;
import '../../widgets/connect_nav_bar_sp.dart' show ConnectNavBarSP;
import 'widgets/service_card.dart';

// Example "details" screen import (adjust path/name if different)
// This is where the user ends up after tapping the arrow
import '../service_details/service_details_screen.dart';

class ServiceListingScreen extends StatefulWidget {
  const ServiceListingScreen({super.key});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  // Updated services list with new entity fields
  final List<Map<String, dynamic>> _services = [
    {
      'serviceName': 'Window Cleaning',
      'category': 'Cleaning',
      'hourlyRate': 1000.0,
      'locations': ['Colombo', 'Kalutara'],
      'availableHours': '8AM - 5PM',
      'availableDates': ['Monday', 'Friday'],
      'jobDescription': 'Professional window cleaning services...',
      'coverImage': 'assets/images/cover_image/cleaning1.png',
      'rating': 4.5,
      'recentJobs': [
        {
          'images': ['assets/images/jobs/job1.png', 'assets/images/jobs/job2.png'],
          'description': 'Cleaned windows of a large house.'
        }
      ],
      'reviews': [
        {
          'rating': 5.0,
          'comment': 'Excellent service!',
          'author': 'John'
        }
      ],
      'status': 'Active',
    },
    {
      'serviceName': 'Garden Maintenance',
      'category': 'Gardening',
      'hourlyRate': 500.0,
      'locations': ['Galle', 'Matara'],
      'availableHours': '9AM - 3PM',
      'availableDates': ['Tuesday', 'Thursday'],
      'jobDescription': 'We take care of all your gardening needs...',
      'coverImage': 'assets/images/cover_image/gardening1.jpg',
      'rating': 3.8,
      'recentJobs': [
        {
          'images': ['assets/images/jobs/job1.png', 'assets/images/jobs/job2.png'],
          'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
        },
        {
          'images': ['assets/images/jobs/job1.png', 'assets/images/jobs/job2.png'],
          'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
        },
      ],
      'reviews': [
        {
          'rating': 4.0,
          'comment': 'Good job, but took a bit longer.',
          'author': 'Alice'
        }
      ],
      'status': 'Inactive',
    },
    // Add more services as needed...
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
                // Title + Add icon alignment
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 225,
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Services',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Color(0xFF027335),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // "Add" service placeholder
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFF027335)),
                        ),
                        child: const Icon(Icons.add, color: Color(0xFF027335)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Service Cards
                Column(
                  children: _services.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ServiceCard(
                        serviceData: service,
                        onArrowTap: () {
                          // Navigate to details, passing entire service map
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceDetailsScreen(
                                service: service,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: const ConnectNavBarSP(
                isHomeSelected: false,
                isToolsSelected: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
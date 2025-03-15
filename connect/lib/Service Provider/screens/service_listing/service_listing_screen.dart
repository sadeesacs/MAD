import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar_sp.dart' show ConnectAppBarSP;
import '../../widgets/connect_nav_bar_sp.dart' show ConnectNavBarSP;
import 'widgets/service_card.dart';

class ServiceListingScreen extends StatefulWidget {
  const ServiceListingScreen({super.key});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Window Cleaning',
      'category': 'Cleaning',
      'status': 'Active',
      'price': 1000.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    {
      'title': 'Garden Maintenance',
      'category': 'Gardening',
      'status': 'Inactive',
      'price': 500.00,
      'image': 'assets/images/cover_image/gardening1.jpg',
    },
    {
      'title': 'Window Cleaning',
      'category': 'Cleaning',
      'status': 'Active',
      'price': 500.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    {
      'title': 'Garden Maintenance',
      'category': 'Gardening',
      'status': 'Inactive',
      'price': 500.00,
      'image': 'assets/images/cover_image/gardening1.jpg',
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

    // nav bar
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
                          border: Border.all(color: const Color(0xFF027335)),
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
                        title: service['title'] as String,
                        category: service['category'] as String,
                        status: service['status'] as String,
                        price: service['price'] as double,
                        imagePath: service['image'] as String,
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
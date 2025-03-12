import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';

import '../home/widgets/search_bar_widget.dart';

import 'widgets/service_listing_card.dart';

class ServiceListingScreen extends StatefulWidget {
  final String categoryName;

  const ServiceListingScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  final List<Map<String, dynamic>> allServices = [
    {
      'category': 'Fitness',
      'title': 'Window Cleaning',
      'provider': 'Mr. Richard Perera',
      'city': 'Colombo',
      'province': 'Gampaha',
      'rating': 4.9,
      'reviews': 150,
      'price': 500.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    {
      'category': 'Gardening',
      'title': 'Garden Maintenance',
      'provider': 'Ms. Alice Green',
      'city': 'Colombo',
      'province': 'Western',
      'rating': 4.7,
      'reviews': 110,
      'price': 800.00,
      'image': 'assets/images/cover_image/gardening1.jpg',
    },
    {
      'category': 'Cleaning',
      'title': 'Window Cleaning',
      'provider': 'Mr. Richard Perera',
      'city': 'Colombo',
      'province': 'Gampaha',
      'rating': 4.9,
      'reviews': 150,
      'price': 500.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    {
      'category': 'Gardening',
      'title': 'Garden Maintenance',
      'provider': 'Ms. Alice Green',
      'city': 'Colombo',
      'province': 'Western',
      'rating': 4.7,
      'reviews': 110,
      'price': 800.00,
      'image': 'assets/images/cover_image/gardening1.jpg',
    },
    {
      'category': 'Cleaning',
      'title': 'Window Cleaning',
      'provider': 'Mr. Richard Perera',
      'city': 'Colombo',
      'province': 'Gampaha',
      'rating': 4.9,
      'reviews': 150,
      'price': 500.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    {
      'category': 'Gardening',
      'title': 'Garden Maintenance',
      'provider': 'Ms. Alice Green',
      'city': 'Colombo',
      'province': 'Western',
      'rating': 4.7,
      'reviews': 110,
      'price': 800.00,
      'image': 'assets/images/cover_image/gardening1.jpg',
    },
    {
      'category': 'Cleaning',
      'title': 'Window Cleaning',
      'provider': 'Mr. Richard Perera',
      'city': 'Colombo',
      'province': 'Gampaha',
      'rating': 4.9,
      'reviews': 150,
      'price': 500.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    {
      'category': 'Gardening',
      'title': 'Garden Maintenance',
      'provider': 'Ms. Alice Green',
      'city': 'Colombo',
      'province': 'Western',
      'rating': 4.7,
      'reviews': 110,
      'price': 800.00,
      'image': 'assets/images/cover_image/gardening1.jpg',
    },
  ];

  List<Map<String, dynamic>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    filteredServices = allServices.where((service) {
      return service['category'] == widget.categoryName;
    }).toList();
  }

  void _onScroll() {
    final offset = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;

    // Hide on scroll down, show on scroll up
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
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                // Row for back button + centered category name
                Row(
                  children: [
                    // Back Arrow (left)
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

                    // Category name (center)
                    Text(
                      widget.categoryName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0xFF027335),
                      ),
                    ),
                    const Spacer(),

                    // Invisible box matching arrow size to keep text centered
                    SizedBox(width: 28) // ~ the width of arrow+padding
                  ],
                ),

                const SizedBox(height: 30),

                SearchBarWidget(
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),

                const SizedBox(height: 30),

                // Service cards for this category
                Column(
                  children: filteredServices.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ServiceListingCard(
                        imagePath: service['image'],
                        title: service['title'],
                        provider: service['provider'],
                        city: service['city'],
                        province: service['province'],
                        rating: service['rating'],
                        reviewsCount: service['reviews'],
                        price: service['price'],
                      ),
                    );
                  }).toList(),
                ),

                // Extra bottom spacing

              ],
            ),
          ),

          // Floating NavBar with hide/show animation
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: const ConnectNavBar(
                // This isn't the home page, so set false
                isHomeSelected: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
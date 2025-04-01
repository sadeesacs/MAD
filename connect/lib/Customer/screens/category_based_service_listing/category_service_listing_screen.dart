import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../home/widgets/search_bar_widget.dart';
import '../service-detail/service_detail.dart';

class CategoryServiceListingScreen extends StatefulWidget {
  final String categoryName;

  const CategoryServiceListingScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryServiceListingScreen> createState() => _CategoryServiceListingScreenState();
}

class _CategoryServiceListingScreenState extends State<CategoryServiceListingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  // For demonstration, some dummy data:
  final List<Map<String, dynamic>> allServices = [
    {
      'category': 'Cleaning',
      'title': 'Kitchen Cleaning',
      'provider': 'Leo Perera',
      'city': 'Colombo',
      'province': 'Gampaha',
      'rating': 4.8,
      'reviews': 50,
      'price': 500.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    {
      'category': 'Cleaning',
      'title': 'Window Cleaning',
      'provider': 'Richard Fernando',
      'city': 'Kandy',
      'province': 'Central',
      'rating': 4.5,
      'reviews': 25,
      'price': 600.00,
      'image': 'assets/images/cover_image/cleaning1.png',
    },
    // Add more if needed
  ];

  List<Map<String, dynamic>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Filter based on widget.categoryName
    filteredServices = allServices.where((service) {
      return service['category'] == widget.categoryName;
    }).toList();
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
                      widget.categoryName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0xFF027335),
                      ),
                    ),
                    const Spacer(),
                    // dummy box for symmetrical spacing
                    const SizedBox(width: 28),
                  ],
                ),
                const SizedBox(height: 30),

                // Possibly a search bar
                SearchBarWidget(onTap: () {}),
                const SizedBox(height: 30),

                // Show filtered services
                Column(
                  children: filteredServices.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to ServiceDetailScreen with the selected service data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceDetailScreen(
                                service: service, // pass the entire map
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6FAF8),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Cover image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  service['image'],
                                  width: 110,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Service details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      service['title'],
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Provider
                                    Text(
                                      'By ${service['provider']}',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // City + Province
                                    Row(
                                      children: [
                                        const Text(
                                          'Location: ',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${service['city']}, ${service['province']}',
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Rating + Reviews
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFFFFD700),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          service['rating'].toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Text(
                                          '${service['reviews']} Reviews',
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Price
                                    Row(
                                      children: [
                                        Text(
                                          'LKR ${service['price'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '/h',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: const ConnectNavBar(isHomeSelected: false),
            ),
          ),
        ],
      ),
    );
  }
}

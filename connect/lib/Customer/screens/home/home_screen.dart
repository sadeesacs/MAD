// lib/Customer/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../../widgets/hamburger_menu.dart';
import '../search-services/search_services.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/special_offers_widget.dart';
import 'widgets/categories_widget.dart';
import 'widgets/top_rated_widget.dart';
import 'widgets/customer_reviews_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;

  // Hard-coded data for top rated services
  final List<Map<String, dynamic>> _topRatedServices = [
    {
      'coverImage': 'assets/images/monkey.png', // Replace with your actual image asset if needed
      'serviceName': 'Test Service 1',
      'serviceProviderName': 'Provider One',
      'rating': 4.5,
      'hourlyRate': 1500,
    },
    {
      'coverImage': 'assets/images/monkey.png',
      'serviceName': 'Test Service 2',
      'serviceProviderName': 'Provider Two',
      'rating': 4.8,
      'hourlyRate': 2000,
    },
  ];

  // Hard-coded data for reviews (for now)
  final List<Map<String, dynamic>> _latestFiveStarReviews = [
    {
      'category': 'Cleaning',
      'comment': 'Great experience!',
      'authorName': 'John Doe',
      'rate': 5.0,
    },
    {
      'category': 'Gardening',
      'comment': 'Very satisfied!',
      'authorName': 'Jane Smith',
      'rate': 5.0,
    },
  ];

  bool _isLoading = false; // For hard-coded data, we can set false

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // No backend fetch needed when using hard-coded data.
  }

  void _scrollListener() {
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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the Scaffold with WillPopScope to disable back navigation.
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const ConnectAppBar(),
        endDrawer: const HamburgerMenu(),
        body: Stack(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SearchBarWidget(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchFunctionScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Special Offers (static)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: SpecialOffersWidget(),
                  ),
                  const SizedBox(height: 35),
                  // Categories (static)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: CategoriesWidget(),
                  ),
                  const SizedBox(height: 35),
                  // Top Rated Services (using hard-coded data)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TopRatedWidget(services: _topRatedServices),
                  ),
                  const SizedBox(height: 35),
                  // Customer Reviews (using hard-coded data)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: CustomerReviewsWidget(
                        latestReviews: _latestFiveStarReviews),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            // Animated Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 500),
                offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
                child: const ConnectNavBar(
                  isHomeSelected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

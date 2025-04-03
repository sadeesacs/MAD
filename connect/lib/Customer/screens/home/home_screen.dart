// lib/Customer/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// Import your new HomeDataService

import '../../services/home_data_service.dart';
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

  // Data from backend
  List<Map<String, dynamic>> _topRatedServices = [];
  List<Map<String, dynamic>> _latestFiveStarReviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    setState(() => _isLoading = true);

    final homeDataService = HomeDataService();
    final topRated = await homeDataService.fetchTopRatedServices(limit: 2);
    final reviews = await homeDataService.fetchLatestFiveStarReviews(limit: 5);

    setState(() {
      _topRatedServices = topRated;
      _latestFiveStarReviews = reviews;
      _isLoading = false;
    });
  }

  void _scrollListener() {
    final offset = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;
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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                /// Search bar
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

                /// Special Offers (static or not?)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: SpecialOffersWidget(),
                ),
                const SizedBox(height: 35),

                /// Categories (static local)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: CategoriesWidget(),
                ),
                const SizedBox(height: 35),

                /// Top Rated
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TopRatedWidget(services: _topRatedServices),
                ),
                const SizedBox(height: 35),

                /// Customer Reviews (5-star)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: CustomerReviewsWidget(
                    latestReviews: _latestFiveStarReviews,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          /// nav bar animation
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
    );
  }
}

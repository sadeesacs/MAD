import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                ),
                const SizedBox(height: 30),

                /// Special Offers
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: const SpecialOffersWidget(),
                ),
                const SizedBox(height: 35),

                /// Categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: const CategoriesWidget(),
                ),
                const SizedBox(height: 35),

                /// Top Rated
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: const TopRatedWidget(),
                ),
                const SizedBox(height: 35),

                /// Customer Reviews
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: const CustomerReviewsWidget(),
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
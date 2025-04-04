import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../util/image_provider_helper.dart';
import '../../services/service_data_service.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../home/widgets/search_bar_widget.dart';
import '../service-detail/service_detail.dart';

/// Widget to fetch and display the provider's name from Firestore.
class ProviderNameWidget extends StatelessWidget {
  final dynamic serviceProvider; // Expected to be a DocumentReference

  const ProviderNameWidget({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    if (serviceProvider is DocumentReference) {
      return FutureBuilder<DocumentSnapshot>(
        future: (serviceProvider as DocumentReference).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              'Loading...',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                color: Colors.black,
              ),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text(
              'Unknown Provider',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                color: Colors.black,
              ),
            );
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['name'] ?? 'No Provider';
          return Text(
            'By $name',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              color: Colors.black,
            ),
          );
        },
      );
    } else {
      return const Text(
        'Unknown Provider',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          color: Colors.black,
        ),
      );
    }
  }
}

class CategoryServiceListingScreen extends StatefulWidget {
  final String categoryName;

  const CategoryServiceListingScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryServiceListingScreen> createState() =>
      _CategoryServiceListingScreenState();
}

class _CategoryServiceListingScreenState
    extends State<CategoryServiceListingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hideNavBar = false;
  double _lastOffset = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchServices();
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

  Future<void> _fetchServices() async {
    final serviceDataService = ServiceDataService();
    final results =
    await serviceDataService.fetchServicesByCategory(widget.categoryName);
    setState(() {
      _services = results;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String _formatLocations(dynamic locs) {
    if (locs is List) {
      return locs.join(', ');
    }
    return locs?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                    const SizedBox(width: 28),
                  ],
                ),
                const SizedBox(height: 30),
                // Possibly a search bar
                SearchBarWidget(onTap: () {}),
                const SizedBox(height: 30),
                // Show services
                Column(
                  children: _services.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          // Pass the entire service map to detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceDetailScreen(
                                service: service,
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
                              // Service image using helper function
                              _buildServiceImage(service['coverImage']),
                              const SizedBox(width: 12),
                              // Service details text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service['serviceName'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Provider name fetched from users collection
                                    ProviderNameWidget(
                                      serviceProvider: service['serviceProvider'],
                                    ),
                                    const SizedBox(height: 4),
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
                                          _formatLocations(service['locations']),
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFFFFD700),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          service['rating'] != null
                                              ? (service['rating'] as num).toStringAsFixed(1)
                                              : '0.0',
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Text(
                                          '${service['reviews'] ?? 0} Reviews',
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
                                    Row(
                                      children: [
                                        Text(
                                          'LKR ${(service['hourlyRate'] ?? 0).toStringAsFixed(2)}',
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
          // Floating NavBar
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

  Widget _buildServiceImage(dynamic coverImagePath) {
    return Container(
      width: 110,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
        image: DecorationImage(
          image: getImageProvider(coverImagePath?.toString() ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
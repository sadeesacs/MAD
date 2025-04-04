import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Local widget imports
import '../home/home_screen.dart';
import 'widgets/reset_button.dart';
import 'widgets/select_location.dart';
import 'widgets/select_price.dart';
import 'widgets/select_rating.dart';
import 'widgets/select_service.dart';

// The listing screen we will push to
import 'service_listing.dart';

import '../../widgets/connect_app_bar.dart';

const Color darkGreen = Color(0xFF027335);
const Color white = Colors.white;
const Color black = Colors.black;
const Color lightBlack = Color(0xFF666666);
const Color bodyBackgroundColor = Color(0xFFF6FBF6);
const Color textBoxBackgroundColor = Color(0xFFF6FAF8);

class SearchFunctionScreen extends StatefulWidget {
  const SearchFunctionScreen({super.key});

  @override
  State<SearchFunctionScreen> createState() => _SearchFunctionScreenState();
}

class _SearchFunctionScreenState extends State<SearchFunctionScreen> {
  // Controllers for price range
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  // Selected filters
  String? _selectedDistrict;
  String? _selectedServiceCategory;
  int? _selectedRating;

  // Reset filters
  void _resetFilters() {
    setState(() {
      _selectedDistrict = null;
      _selectedServiceCategory = null;
      _selectedRating = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  /// Builds and executes a query for Firestore 'services' collection,
  /// does local filtering for rating & price, fetches provider name,
  /// then navigates to SearchedServiceListingScreen.
  Future<void> _performSearch() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // 1) Start with services where status == "Active"
      Query query = firestore
          .collection('services')
          .where('status', isEqualTo: 'Active');

      // 2) If a category is selected
      if (_selectedServiceCategory != null && _selectedServiceCategory!.isNotEmpty) {
        query = query.where('category', isEqualTo: _selectedServiceCategory);
      }

      // 3) If a district is selected
      if (_selectedDistrict != null && _selectedDistrict!.isNotEmpty) {
        // 'locations' array must contain the chosen district
        query = query.where('locations', arrayContains: _selectedDistrict);
      }

      // 4) Get the docs
      final querySnapshot = await query.get();

      // 5) Prepare local filters for price/rating
      double minPrice = 0.0;
      double maxPrice = double.infinity;

      if (_minPriceController.text.trim().isNotEmpty) {
        minPrice = double.tryParse(_minPriceController.text.trim()) ?? 0.0;
      }
      if (_maxPriceController.text.trim().isNotEmpty) {
        maxPrice = double.tryParse(_maxPriceController.text.trim()) ?? double.infinity;
      }

      final List<Map<String, dynamic>> finalServices = [];

      // 6) Local filtering
      for (var doc in querySnapshot.docs) {
        final data = (doc.data() as Map<String, dynamic>?) ?? {};

        // rating & hourlyRate may be null => default to 0
        final double docRating = (data['rating'] ?? 0).toDouble();
        final double docRate   = (data['hourlyRate'] ?? 0).toDouble();

        // Check rating
        if (_selectedRating != null && docRating < _selectedRating!) {
          continue;
        }
        // Check price
        if (docRate < minPrice || docRate > maxPrice) {
          continue;
        }

        // Passed all checks => add to final list
        finalServices.add({
          ...data,
          'docId': doc.id, // keep the doc id
        });
      }

      // 7) For each service, fetch provider's name from 'users' doc
      final List<Map<String, dynamic>> finalWithProvider = [];
      for (var serviceMap in finalServices) {
        String providerName = 'Unknown Provider';
        final providerRef = serviceMap['serviceProvider'];
        if (providerRef is DocumentReference) {
          final providerSnap = await providerRef.get();
          if (providerSnap.exists) {
            final userData = providerSnap.data() as Map<String, dynamic>;
            providerName = userData['name'] ?? 'Unknown Provider';
          }
        }
        // Store the provider name in the map
        serviceMap['serviceProviderName'] = providerName;
        finalWithProvider.add(serviceMap);
      }

      // 8) Navigate to listing screen
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchedServiceListingScreen(services: finalWithProvider),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the entire screen in WillPopScope to override system back
    return WillPopScope(
      onWillPop: () async {
        // Navigate to HomeScreen and prevent default back
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false; // returning false means system back is disabled
      },
      child: Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: const ConnectAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Back & Title
              Row(
                children: [
                  // Custom back button
                  GestureDetector(
                    onTap: () {
                      // Instead of pop, go to HomeScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
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
                  const SizedBox(width: 20),
                  const Text(
                    'Search Services',
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              // Reset Filters
              ResetFiltersButton(onPressed: _resetFilters),
              const SizedBox(height: 10),

              // Select location
              SelectLocation(
                selectedDistrict: _selectedDistrict,
                onChanged: (String? val) {
                  setState(() {
                    _selectedDistrict = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Select service category
              SelectServiceCategory(
                selectedServiceCategory: _selectedServiceCategory,
                onChanged: (String? val) {
                  setState(() {
                    _selectedServiceCategory = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Price range
              SelectPriceRange(
                minPriceController: _minPriceController,
                maxPriceController: _maxPriceController,
              ),
              const SizedBox(height: 16),

              // Rating
              SelectRating(
                selectedRating: _selectedRating,
                onChanged: (int? val) {
                  setState(() {
                    _selectedRating = val;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF027335),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

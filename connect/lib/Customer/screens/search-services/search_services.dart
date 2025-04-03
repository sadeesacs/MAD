// lib/Customer/screens/search-services/search_services.dart
import 'package:flutter/material.dart';
import '../../services/search_data_service.dart';
import '../../widgets/connect_app_bar.dart';
import 'widgets/reset_button.dart';
import 'widgets/select_button.dart';
import 'widgets/select_location.dart';
import 'widgets/select_price.dart';
import 'widgets/select_rating.dart';
import 'widgets/select_service.dart';
import 'package:connect/Customer/screens/search-services/service_listing.dart'; // Destination screen

const Color darkGreen = Color(0xFF027335);
const Color bodyBackgroundColor = Color(0xFFF6FBF6);

class SearchFunctionScreen extends StatefulWidget {
  const SearchFunctionScreen({super.key});

  @override
  State<SearchFunctionScreen> createState() => _SearchFunctionScreenState();
}

class _SearchFunctionScreenState extends State<SearchFunctionScreen> {
  // District, Category, rating
  String? _selectedDistrict;
  String? _selectedServiceCategory;
  int? _selectedRating;

  // Price range
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  bool _isSearching = false; // to show a loading indicator if desired

  void _resetFilters() {
    setState(() {
      _selectedDistrict = null;
      _selectedServiceCategory = null;
      _selectedRating = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  Future<void> _onSearchPressed() async {
    setState(() => _isSearching = true);

    // Prepare filters
    final String? district = _selectedDistrict;
    final String? category = _selectedServiceCategory;
    final int? rating = _selectedRating;

    double? minPrice;
    double? maxPrice;

    if (_minPriceController.text.trim().isNotEmpty) {
      minPrice = double.tryParse(_minPriceController.text.trim()) ?? 0.0;
    }
    if (_maxPriceController.text.trim().isNotEmpty) {
      maxPrice = double.tryParse(_maxPriceController.text.trim());
    }

    try {
      // We do the search in our new service
      final results = await SearchDataService().searchServices(
        category: category,
        district: district,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: rating,
      );

      // Then navigate to the SearchedServiceListingScreen with these results
      // We'll pass as constructor argument
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchedServiceListingScreen(services: results),
          ),
        );
      }
    } catch (e) {
      // handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search error: $e')),
      );
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back + Title
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

                // District
                SelectLocation(
                  selectedDistrict: _selectedDistrict,
                  onChanged: (val) {
                    setState(() => _selectedDistrict = val);
                  },
                ),
                const SizedBox(height: 16),

                // Category
                SelectServiceCategory(
                  selectedServiceCategory: _selectedServiceCategory,
                  onChanged: (val) {
                    setState(() => _selectedServiceCategory = val);
                  },
                ),
                const SizedBox(height: 16),

                // Price Range
                SelectPriceRange(
                  minPriceController: _minPriceController,
                  maxPriceController: _maxPriceController,
                ),
                const SizedBox(height: 16),

                // Rating
                SelectRating(
                  selectedRating: _selectedRating,
                  onChanged: (val) {
                    setState(() => _selectedRating = val);
                  },
                ),
                const SizedBox(height: 24),

                // Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSearching ? null : _onSearchPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF027335),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSearching
                        ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

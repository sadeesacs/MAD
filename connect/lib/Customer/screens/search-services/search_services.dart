import 'package:connect/Customer/screens/search-services/widgets/reset_button.dart';
import 'package:connect/Customer/screens/search-services/widgets/select_button.dart';
import 'package:connect/Customer/screens/search-services/widgets/select_location.dart';
import 'package:connect/Customer/screens/search-services/widgets/select_price.dart';
import 'package:connect/Customer/screens/search-services/widgets/select_rating.dart';
import 'package:connect/Customer/screens/search-services/widgets/select_service.dart';
import 'package:flutter/material.dart';

import '../../widgets/connect_app_bar.dart';


const Color darkGreen = Color(0xFF027335);
const Color white = Colors.white;
const Color black = Colors.black;
const Color lightBlack = Color(0xFF666666);
const Color bodyBackgroundColor = Color(0xFFF6FBF6);
const Color textBoxBackgroundColor = Color(0xFFF6FAF8);

void main() {
  runApp(const ConnectApp());
}

class ConnectApp extends StatelessWidget {
  const ConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchFunctionScreen(),
    );
  }
}

class SearchFunctionScreen extends StatefulWidget {
  const SearchFunctionScreen({super.key});

  @override
  State<SearchFunctionScreen> createState() => _SearchFunctionScreenState();
}

class _SearchFunctionScreenState extends State<SearchFunctionScreen> {
  // Controllers for text fields
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  // Variables to store selected values
  String? _selectedDistrict;
  String? _selectedServiceCategory;
  int? _selectedRating;

  // Function to reset filters
  void _resetFilters() {
    setState(() {
      _selectedDistrict = null;
      _selectedServiceCategory = null;
      _selectedRating = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: const ConnectAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button and Search Services Text
            Row(
              children: [
                // Back Button
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
                const SizedBox(width: 20,),
                const Text(
                  'Search Services',
                  style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            ),
            const SizedBox(height: 2),

            // Reset Filters Button
            ResetFiltersButton(onPressed: _resetFilters),
            const SizedBox(height: 10),

            // Select Location
            SelectLocation(
              selectedDistrict: _selectedDistrict,
              onChanged: (String? value) {
                setState(() {
                  _selectedDistrict = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Select Service Category
            SelectServiceCategory(
              selectedServiceCategory: _selectedServiceCategory,
              onChanged: (String? value) {
                setState(() {
                  _selectedServiceCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Select Price Range
            SelectPriceRange(
              minPriceController: _minPriceController,
              maxPriceController: _maxPriceController,
            ),
            const SizedBox(height: 16),

            // Select Rating
            SelectRating(
              selectedRating: _selectedRating,
              onChanged: (int? value) {
                setState(() {
                  _selectedRating = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Search Button
            const SearchButton(),
          ],
        ),
      ),
    );
  }
}
// lib/Customer/screens/service-listing/service_listing.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../services/service_data_service.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import 'widget/category_selector.dart';
import 'widget/service_card.dart';

const Color darkGreen = Color(0xFF027335);
const Color cardBackgroundColor = Color(0xFFF6FAF8);
const Color white = Colors.white;
const Color black = Colors.black;

class ServiceListingScreen extends StatefulWidget {
  const ServiceListingScreen({super.key});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  String? _selectedCategory;
  final List<String> _categories = [
    'Plumbing',
    'Cleaning',
    'Gardening',
    'Electrical',
    'Car Wash',
    'Cooking',
    'Painting',
    'Fitness',
    'Massage',
    'Babysitting',
    'ElderCare',
    'Laundry',
  ];

  bool _isLoading = false;
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    // default to 'Plumbing'
    _selectedCategory = _categories.first;
    _fetchServicesForCategory(_selectedCategory!);
  }

  Future<void> _fetchServicesForCategory(String categoryName) async {
    setState(() => _isLoading = true);
    final serviceDataService = ServiceDataService();
    final results = await serviceDataService.fetchServicesByCategory(categoryName);
    setState(() {
      _services = results;
      _isLoading = false;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchServicesForCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Services',
                    style: TextStyle(color: darkGreen, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                CategorySelector(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _onCategorySelected,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return ServiceCard(service: service);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: const ConnectNavBar(
              isHomeSelected: false,
              isConstructionSelected: true,
            ),
          ),
        ],
      ),
    );
  }
}

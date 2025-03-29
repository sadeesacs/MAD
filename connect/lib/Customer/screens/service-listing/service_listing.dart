import 'package:connect/Customer/screens/service-listing/widget/category_selector.dart';
import 'package:connect/Customer/screens/service-listing/widget/service_card.dart';
import 'package:flutter/material.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';


const Color darkGreen = Color(0xFF027335);
const Color appBarColor = Color(0xFFF1FAF1);
const Color cardBackgroundColor = Color(0xFFF6FAF8);
const Color white = Colors.white;
const Color black = Colors.black;

void main() {
  runApp(const ConnectApp());
}

class ConnectApp extends StatelessWidget {
  const ConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServiceListingScreen(),
    );
  }
}

class ServiceListingScreen extends StatefulWidget {
  const ServiceListingScreen({super.key});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  String? _selectedCategory = 'Plumbing';

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

  final List<Map<String, dynamic>> _services = [
    {
      'category': 'Plumbing',
      'serviceName': 'Major Leaks',
      'providerName': 'Mr. Richard Peters',
      'location': 'Colombo, Gampha',
      'rating': 4.9,
      'reviews': 150,
      'price': 'LKR 700.00/h',
      'image': 'assets/images/cover_image/cleaning_cover_image.jpg', // Replace with your asset path
    },

    {
      'category': 'Cleaning',
      'serviceName': 'Window Cleaning',
      'providerName': 'Mr. Richard Peters',
      'location': 'Colombo, Gampha',
      'rating': 4.9,
      'reviews': 150,
      'price': 'LKR 500.00/h',
      'image': 'assets/images/cover_image/cleaning_cover_image.jpg', // Replace with your asset path
    },

    {
      'category': 'Cleaning',
      'serviceName': 'Window Cleaning',
      'providerName': 'Mr. Richard Peters',
      'location': 'Colombo, Gampha',
      'rating': 4.9,
      'reviews': 150,
      'price': 'LKR 500.00/h',
      'image': 'assets/images/cover_image/cleaning_cover_image.jpg', // Replace with your asset path
    },

    {
      'category': 'Cleaning',
      'serviceName': 'Window Cleaning',
      'providerName': 'Mr. Richard Peters',
      'location': 'Colombo, Gampha',
      'rating': 4.9,
      'reviews': 150,
      'price': 'LKR 500.00/h',
      'image': 'assets/images/cover_image/cleaning_cover_image.jpg', // Replace with your asset path
    },
    // Add more services here
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories[0]; // Set Plumbing as default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBar(), // Use the ConnectAppBar widget
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0), // Add 25 padding to the entire page
            child: Column(
              children: [
                // Services Text
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Text(
                      'Services',
                      style: TextStyle(color: darkGreen, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: 4),
                // Category Selector
                CategorySelector(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),

                SizedBox(height: 16),
                // Service Listing Cards
                Expanded(
                  child: ListView.builder(
                    //padding: const EdgeInsets.all(16.0),
                    itemCount: _services.where((service) => service['category'] == _selectedCategory).length,
                    itemBuilder: (context, index) {
                      final service = _services.where((service) => service['category'] == _selectedCategory).toList()[index];
                      return ServiceCard(service: service);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Nav Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: const ConnectNavBar(
              isConstructionSelected: true,
              isHomeSelected: false,
            ),
          ),
        ],
      ),
    );
  }
}
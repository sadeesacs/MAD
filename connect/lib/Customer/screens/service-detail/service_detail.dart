import 'package:connect/Customer/screens/service-detail/widgets/bottom_buttons.dart';
import 'package:flutter/material.dart';

import '../../widgets/connect_app_bar.dart';

const Color navbarColor = Color(0xFFF7FAF7);
const Color darkGreen = Color(0xFF027335);
const Color greyText = Colors.grey;
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
      home: ServiceDetailScreen(),
    );
  }
}

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBar(), // Use the ConnectAppBar widget
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0), // Add 25 padding to the entire page
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cleaning Text
                Center(
                  child: Text(
                    'Cleaning',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Cover Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/cover_image/cleaning_cover_image.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),

                // Kitchen Cleaning Section
                const Text(
                  'Kitchen Cleaning',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'By Leo Perera',
                  style: TextStyle(color: greyText),
                ),
                const SizedBox(height: 5),

                // Stars and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.orange),
                        Icon(Icons.star, color: Colors.orange),
                        Icon(Icons.star, color: Colors.orange),
                        Icon(Icons.star_half, color: Colors.orange),
                        Icon(Icons.star_border, color: Colors.orange),
                      ],
                    ),
                    const Text(
                      'LKR 500.00/h',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Locations
                Wrap(
                  spacing: 8,
                  children: [
                    locationChip('Colombo'),
                    locationChip('Gampaha'),
                    locationChip('Kottawa'),
                  ],
                ),
                const SizedBox(height: 16),

                // Job Description Section
                _buildTabSection(),
                const SizedBox(height: 80),
              ],
            ),
          ),
          // Fixed Bottom Buttons
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomButtons(),
          ),
        ],
      ),
    );
  }

  Widget locationChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: darkGreen),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(
        label,
        style: TextStyle(color: darkGreen),
      ),
    );
  }

  Widget _buildTabSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            indicatorColor: darkGreen,
            labelColor: black,
            unselectedLabelColor: greyText,
            tabs: const [
              Tab(text: 'Job Description'),
              Tab(text: 'Recent Jobs'),
              Tab(text: 'Reviews'),
            ],
          ),
          SizedBox(
            height: 400, // Fixed height for TabBarView
            child: TabBarView(
              children: [
                // Job Description Content

                // Recent Jobs Content

                // Reviews Content

              ],
            ),
          ),
        ],
      ),
    );
  }
}
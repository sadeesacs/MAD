import 'package:connect/Customer/screens/service-detail/widgets/bottom_buttons.dart';
import 'package:connect/Customer/screens/service-detail/widgets/job_description.dart';
import 'package:connect/Customer/screens/service-detail/widgets/recent_jobs.dart';
import 'package:connect/Customer/screens/service-detail/widgets/reviews.dart';
import 'package:flutter/material.dart';

import '../../widgets/connect_app_bar.dart';
import '../service-listing/service_listing.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // Apply Roboto font to the entire app
      ),
      home: const ServiceDetailScreen(),
    );
  }
}

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  get indicator => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBar(), // Use the ConnectAppBar widget
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            // Add 25 padding to the entire page
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row for Back Button and Cleaning Text
                Row(
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (
                                context) => const ServiceListingScreen()),
                          ),
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
                    // Spacer to push the title to the center

                    // Cleaning Text
                    Text(
                      'Cleaning',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Spacer to balance the row

                    // Invisible placeholder to match the back button's width
                    const SizedBox(width: 40),
                    // Adjust width to match back button size
                  ],
                ),
                const SizedBox(height: 18),

                // Cover Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/cover_image/cleaning_cover_image.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),

                // Kitchen Cleaning Section
                Text(
                  'Kitchen Cleaning',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Apply Roboto font
                  ),
                ),
                Text(
                  'By Leo Perera',
                  style: TextStyle(
                    color: greyText,
                    fontFamily: 'Roboto', // Apply Roboto font
                  ),
                ),
                const SizedBox(height: 7),

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
                    Text(
                      'LKR 500.00/h',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
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
        color: const Color(0xFFF6FAF8),
        border: Border.all(color: darkGreen),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: black,
          fontFamily: 'Roboto',
        ),
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
            labelPadding: const EdgeInsets.symmetric(horizontal: 3),
            tabs: [
              const Tab(text: 'Job Description'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: const Tab(text: 'Recent Jobs'),
              ),
              const Tab(text: 'Reviews'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                const JobDescription(),
                RecentJobs(),
                Reviews(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

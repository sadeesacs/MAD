import 'package:flutter/material.dart';
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
// For booking
import '../bookings/booking/booking_screen.dart';
import '../bookings/booking_form_data.dart';

import 'widgets/bottom_buttons.dart';
import 'widgets/job_description.dart';
import 'widgets/recent_jobs.dart';
import 'widgets/reviews.dart';

const Color darkGreen = Color(0xFF027335);
const Color greyText  = Colors.grey;
const Color white     = Colors.white;
const Color black     = Colors.black;

class ServiceDetailScreen extends StatelessWidget {
  // This receives the entire service map
  final Map<String, dynamic> service;

  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract data from the service map
    final String category = service['category'] ?? 'Service';
    final String title    = service['title']    ?? 'Untitled';
    final String provider = service['provider'] ?? 'Unknown';
    final String image    = service['image']    ?? '';
    final double price    = service['price']    ?? 0.0;

    return Scaffold(
      backgroundColor: white,
      appBar: const ConnectAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row: back + category
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
                      category,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 18),

                // Cover Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
                const SizedBox(height: 12),

                // Title + Provider
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  'By $provider',
                  style: TextStyle(
                    color: greyText,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 7),

                // Hard-coded rating + dynamic price
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
                      'LKR ${price.toStringAsFixed(2)}/h',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Example location chips (optional)
                Wrap(
                  spacing: 8,
                  children: [
                    _locationChip('Colombo'),
                    _locationChip('Gampaha'),
                    _locationChip('Kottawa'),
                  ],
                ),
                const SizedBox(height: 16),

                // Tab Section: job desc, recent jobs, reviews
                _buildTabSection(),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Bottom Buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomButtons(
              // We can define separate onTap for "Message" & "Book Now"
              onMessageTap: () {
                // Placeholder
              },
              onBookNowTap: () {
                // Navigate to BookingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      formData: BookingFormData(
                        serviceTitle: title,
                        providerName: provider,
                        pricePerHour: price,
                        imageUrl: image,
                        category: category,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF8),
        border: Border.all(color: darkGreen),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(label, style: const TextStyle(color: black)),
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
            tabs: const [
              Tab(text: 'Job Description'),
              Tab(text: 'Recent Jobs'),
              Tab(text: 'Reviews'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                const JobDescription(),
                const RecentJobs(),
                const Reviews(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

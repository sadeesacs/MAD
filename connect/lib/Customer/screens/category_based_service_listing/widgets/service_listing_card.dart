import 'package:flutter/material.dart';
import '../../bookings/booking/booking_screen.dart';
import '../../bookings/booking_form_data.dart'; // Import Booking Screen

class ServiceListingCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String provider;
  final String city;
  final String province;
  final double rating;
  final int reviewsCount;
  final double price;
  final String category;

  const ServiceListingCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.provider,
    required this.city,
    required this.province,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to BookingScreen and pass service details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingScreen(
              formData: BookingFormData(
                serviceTitle: title,
                providerName: provider,
                pricePerHour: price,
                imageUrl: imagePath,
                category: category,
                serviceId: '',
              ),
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
            // Cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 110,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Service details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Provider Name
                  Text(
                    'By $provider',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      const Text(
                        'Location: ',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w500, // Medium
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '$city, $province',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Rating & Reviews
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFD700),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w600, // Semibold
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Text(
                        '$reviewsCount Reviews',
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
                  // Price Per Hour
                  Row(
                    children: [
                      Text(
                        'LKR ${price.toStringAsFixed(2)}',
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
    );
  }
}

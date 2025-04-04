// lib/Customer/category_listing/category_screen.dart
import 'package:flutter/material.dart';
import 'package:connect/Customer/screens/home/home_screen.dart'; // Import HomeScreen
import '../../widgets/connect_app_bar.dart';
import '../../widgets/connect_nav_bar.dart';
import '../category_based_service_listing/category_service_listing_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // Local array of categories
  final List<Map<String, String>> _categories = const [
    {'name': 'Gardening', 'image': 'assets/images/categories/gardening.png'},
    {'name': 'Cleaning', 'image': 'assets/images/categories/cleaning.png'},
    {'name': 'Fitness', 'image': 'assets/images/categories/fitness.png'},
    {'name': 'Cooking', 'image': 'assets/images/categories/cooking.png'},
    {'name': 'Painting', 'image': 'assets/images/categories/painting.png'},
    {'name': 'Car Wash', 'image': 'assets/images/categories/car_wash.png'},
    {'name': 'Baby Sitting', 'image': 'assets/images/categories/baby_sitting.png'},
    {'name': 'Laundry', 'image': 'assets/images/categories/laundry.png'},
    {'name': 'Plumbing', 'image': 'assets/images/categories/Plumbing.png'},
    {'name': 'Electrical', 'image': 'assets/images/categories/electrical.png'},
    {'name': 'Massage', 'image': 'assets/images/categories/Massage.png'},
    {'name': 'Eldercare', 'image': 'assets/images/categories/adultcare.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // When back button is pressed, navigate to HomeScreen.
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: const ConnectAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow and screen title row
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
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Color(0xFF027335),
                        ),
                      ),
                      const Spacer(),
                      // Invisible placeholder to balance the row
                      const SizedBox(width: 28),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // 3-column grid of categories from the local array
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 30,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return InkWell(
                        onTap: () {
                          // Navigate to the CategoryServiceListingScreen passing the category name.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryServiceListingScreen(
                                categoryName: category['name']!,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(category['image']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category['name']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            // Navigation Bar at the bottom.
            const Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: ConnectNavBar(isDashboardSelected: true),
            ),
          ],
        ),
      ),
    );
  }
}

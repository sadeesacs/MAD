import 'package:flutter/material.dart';
import 'Widgets/category_item.dart';
import 'Widgets/connect_nav_bar.dart'; // Import the BottomNav widget
import 'Widgets/connect_app_bar.dart';  // Import the custom app bar widget
import 'Widgets/hamburger_menu.dart';  // Import the HamburgerMenu widget

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),  // Use the custom app bar
      drawer: const HamburgerMenu(),  // Add the HamburgerMenu as the Drawer
      body: Column(
        children: [
          const SizedBox(height: 20), // Adjust space for the back button

          // Back button and Title in a Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);  // Navigate back to previous screen
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5E1), // Light green background
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: const EdgeInsets.all(8), // Padding around the back button
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF027335), // Green color for the icon
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Adjust space between back button and title

                // Title: Categories
                Padding(
                  padding: const EdgeInsets.only(left: 50.0), // Move the title left and right
                  child: const Text(
                    "Categories",
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF027335)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),  // Adjust vertical space between title and GridView

          // GridView for category items
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: const [
                CategoryItem(name: 'Plumbing', image: 'assets/images/categories/Plumbing.png'),
                CategoryItem(name: 'Cleaning', image: 'assets/images/categories/cleaning.png'),
                CategoryItem(name: 'Gardening', image: 'assets/images/categories/gardening.png'),
                CategoryItem(name: 'Electrical', image: 'assets/images/categories/electrical.png'),
                CategoryItem(name: 'Car Wash', image: 'assets/images/categories/car_wash.png'),
                CategoryItem(name: 'Cooking', image: 'assets/images/categories/cooking.png'),
                CategoryItem(name: 'Painting', image: 'assets/images/categories/painting.png'),
                CategoryItem(name: 'Fitness', image: 'assets/images/categories/fitness.png'),
                CategoryItem(name: 'Massage', image: 'assets/images/categories/Massage.png'),
                CategoryItem(name: 'Babysitting', image: 'assets/images/categories/baby_sitting.png'),
                CategoryItem(name: 'Eldercare', image: 'assets/images/categories/adultcare.png'),
                CategoryItem(name: 'Laundry', image: 'assets/images/categories/laundry.png'),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const ConnectNavBar(),  // Custom bottom navigation
    );
  }
}

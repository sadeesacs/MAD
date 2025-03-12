import 'package:flutter/material.dart';
import '../../category_based_service_listing/service_listing_screen.dart';
// <-- Make sure this path is correct for your project

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Gardening', 'image': 'assets/images/categories/gardening.png'},
      {'name': 'Cleaning', 'image': 'assets/images/categories/cleaning.png'},
      {'name': 'Fitness', 'image': 'assets/images/categories/fitness.png'},
      {'name': 'Cooking', 'image': 'assets/images/categories/cooking.png'},
      {'name': 'Painting', 'image': 'assets/images/categories/painting.png'},
      {'name': 'Car Wash', 'image': 'assets/images/categories/car_wash.png'},
      {'name': 'Baby Sitting', 'image': 'assets/images/categories/baby_sitting.png'},
      {'name': 'Laundry', 'image': 'assets/images/categories/laundry.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color(0xFF027335),
              ),
            ),
            Spacer(),
            Text(
              'See All',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xFF027335),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Grid with category items
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 30,
            childAspectRatio: 0.8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            return InkWell(
              onTap: () {
                // Navigate to the new screen, passing category name
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceListingScreen(
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
                    height: 62,
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
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

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
                fontWeight: FontWeight.w600, // SemiBold
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

        /// **Fixed Grid to Avoid Overflow**
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 items per row
            crossAxisSpacing: 16, // Horizontal spacing
            mainAxisSpacing: 30,  // Increased vertical spacing
            childAspectRatio: 0.8, // **Ensure enough height for image + text**
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            return Column(
              mainAxisSize: MainAxisSize.min, // Prevents overflow issues
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
                const SizedBox(height: 6), // Extra spacing for text
                Text(
                  category['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Prevents multi-line overflow
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
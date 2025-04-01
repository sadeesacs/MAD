import 'package:flutter/material.dart';

import '../service_listing.dart';


class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                onCategorySelected(categories[index]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedCategory == categories[index] ? darkGreen : white,
                side: BorderSide(color: darkGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: selectedCategory == categories[index] ? white : black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
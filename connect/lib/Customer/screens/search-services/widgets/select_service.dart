import 'package:flutter/material.dart';

class SelectServiceCategory extends StatelessWidget {
  final String? selectedServiceCategory;
  final Function(String?) onChanged;

  SelectServiceCategory({
    super.key,
    required this.selectedServiceCategory,
    required this.onChanged,
  });

  final List<String> _serviceCategories = [
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Service Category',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedServiceCategory,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: const Color(0xFFF6FAF8),
          ),
          items: _serviceCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: onChanged,
          hint: const Text('Select Service Category'),
        ),
      ],
    );
  }
}
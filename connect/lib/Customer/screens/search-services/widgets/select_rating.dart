// lib/Customer/screens/search-services/widgets/select_rating.dart
import 'package:flutter/material.dart';

class SelectRating extends StatelessWidget {
  final int? selectedRating;
  final Function(int?) onChanged;

  SelectRating({
    Key? key,
    required this.selectedRating,
    required this.onChanged,
  }) : super(key: key);

  final List<int> _ratings = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Rating',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedRating,
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
          items: _ratings.map((int rating) {
            return DropdownMenuItem<int>(
              value: rating,
              child: Text('$rating'),
            );
          }).toList(),
          onChanged: onChanged,
          hint: const Text('Select Rating'),
        ),
      ],
    );
  }
}

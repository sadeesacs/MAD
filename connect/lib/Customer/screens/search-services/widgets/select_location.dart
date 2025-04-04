// lib/Customer/screens/search-services/widgets/select_location.dart
import 'package:flutter/material.dart';

class SelectLocation extends StatelessWidget {
  final String? selectedDistrict;
  final Function(String?) onChanged;

  SelectLocation({
    super.key,
    required this.selectedDistrict,
    required this.onChanged,
  });

  final List<String> _districts = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Monaragala',
    'Ratnapura',
    'Kegalle',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Location',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedDistrict,
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
          items: _districts.map((String district) {
            return DropdownMenuItem<String>(
              value: district,
              child: Text(district),
            );
          }).toList(),
          onChanged: onChanged,
          hint: const Text('Select District'),
        ),
      ],
    );
  }
}

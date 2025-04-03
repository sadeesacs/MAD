// lib/Customer/screens/search-services/widgets/select_price.dart
import 'package:flutter/material.dart';

class SelectPriceRange extends StatelessWidget {
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;

  const SelectPriceRange({
    Key? key,
    required this.minPriceController,
    required this.maxPriceController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Price Range',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minPriceController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Min',
                  filled: true,
                  fillColor: const Color(0xFFF6FAF8),
                ),
              ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: TextField(
                controller: maxPriceController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Max',
                  filled: true,
                  fillColor: const Color(0xFFF6FAF8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button full width
      child: ElevatedButton(
        onPressed: () {
          // Perform search action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF027335),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Search',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onTap;
  const SearchBarWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A7F10), width: 1.5),
          color: Colors.transparent,
        ),
        height: 50,
        child: Row(
          children: [
            Icon(Icons.search, color: Color(0xFF3A7F10), size: 30),
            const SizedBox(width: 12),
            Text(
              'Search Services',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            const Icon(Icons.filter_list, color: Color(0xFF3A7F10)),
          ],
        ),
      ),
    );
  }
}
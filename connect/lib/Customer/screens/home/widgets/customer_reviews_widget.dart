import 'package:flutter/material.dart';

class CustomerReviewsWidget extends StatelessWidget {
  const CustomerReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'category': 'Cleaning',
        'review':
        '“The service marketplace app is a fantastic platform for connecting customers with service providers seamlessly.”',
        'author': '~ Quinn',
      },
      {
        'category': 'Laundry',
        'review':
        '“Super convenient! Scheduling laundry pickup has never been easier.”',
        'author': '~ Alex',
      },
      {
        'category': 'Gardening',
        'review': '“My garden looks amazing now!”',
        'author': '~ Sam',
      },
      // Add more if you want...
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0xFF027335),
          ),
        ),
        const SizedBox(height: 16),
        // Increased height to 150 to avoid overflow
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final rv = reviews[index];
              return Container(
                width: 220,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F8F4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rv['category']!,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rv['review']!,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        rv['author']!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

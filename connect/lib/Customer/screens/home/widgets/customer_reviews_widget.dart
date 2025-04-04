// lib/Customer/screens/home/widgets/customer_reviews_widget.dart
import 'package:flutter/material.dart';

class CustomerReviewsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> latestReviews;

  const CustomerReviewsWidget({super.key, required this.latestReviews});

  @override
  Widget build(BuildContext context) {
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
        SizedBox(
          height: 150,
          child: latestReviews.isEmpty
              ? const Center(child: Text('No recent 5-star reviews'))
              : ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: latestReviews.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final rv = latestReviews[index];
              final category = rv['category'] ?? 'Unknown';
              final reviewText = rv['comment'] ?? 'No comment';
              // If you want to store the author's name or doc reference:
              final author = rv['authorName'] ?? '~ Unnamed';
              // rating is in rv['rate'], if needed.

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
                      category,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '“$reviewText”',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        author,
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

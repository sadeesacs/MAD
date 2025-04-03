// lib/Customer/screens/service-detail/widgets/reviews.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reviews extends StatelessWidget {
  final List<Map<String, dynamic>> reviewsList;

  const Reviews({Key? key, required this.reviewsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reviewsList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No reviews yet.'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(13.0),
      itemCount: reviewsList.length,
      itemBuilder: (context, index) {
        final rv = reviewsList[index];
        final authorRef = rv['author'] as DocumentReference?;
        final comment = rv['comment'] ?? 'No comment';
        final rate = (rv['rate'] ?? 0.0).toDouble();

        return _buildReviewCard(authorRef, rate, comment);
      },
    );
  }

  Widget _buildReviewCard(
      DocumentReference? authorRef,
      double rating,
      String comment,
      ) {
    // We won't fetch the author's name again here unless you want to show it
    // or you can pass it from the parent
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Review comment
          Text(
            comment,
            style: const TextStyle(color: Colors.black),
          ),
          // If you want to show the author's name or more info,
          // you can do a future builder for the doc or pass it from the parent
        ],
      ),
    );
  }
}

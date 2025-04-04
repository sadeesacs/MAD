import 'package:flutter/material.dart';

class ViewRatingBottomSheet extends StatelessWidget {
  final int rating;
  final String review;
  final String customerName;
  final String reviewDate;

  const ViewRatingBottomSheet({
    super.key,
    required this.rating,
    required this.review,
    this.customerName = '',
    this.reviewDate = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Rating',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Star rating display
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 30,
              );
            }),
          ),
          
          if (customerName.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              'By: $customerName',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          
          if (reviewDate.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              'Date: $reviewDate',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
          
          const SizedBox(height: 15),
          const Text(
            'Review:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            review,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
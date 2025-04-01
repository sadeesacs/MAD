import 'package:flutter/material.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        children: [
          _buildReviewCard(
            profileImage: 'assets/images/profile_pic/leo_perera.jpg',
            clientName: 'Jeremy Elen',
            rating: 4.8,
            review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
            profileImage: 'assets/images/profile_pic/leo_perera.jpg',
            clientName: 'Sarah Smith',
            rating: 4.5,
            review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
            profileImage: 'assets/images/profile_pic/leo_perera.jpg',
            clientName: 'John Doe',
            rating: 4.9,
            review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String profileImage,
    required String clientName,
    required double rating,
    required String review,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture, Name, and Rating
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(profileImage),
              ),
              const SizedBox(width: 8),
              Text(
                clientName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Review Content
          Text(
            review,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
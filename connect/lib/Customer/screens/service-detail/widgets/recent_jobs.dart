import 'package:flutter/material.dart';

class RecentJobs extends StatelessWidget {
  const RecentJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildJobCard(
          image1: 'assets/images/jobs/cleaningjob1.jpg',
          image2: 'assets/images/jobs/cleaningjob1.jpg',
          description: 'Kitchen cleaning for a family home in Colombo.',
        ),
        const SizedBox(height: 16),
        _buildJobCard(
          image1: 'assets/images/jobs/cleaningjob1.jpg',
          image2: 'assets/images/jobs/cleaningjob1.jpg',
          description: 'Deep cleaning of a restaurant kitchen in Gampaha.',
        ),
        const SizedBox(height: 16),
        _buildJobCard(
          image1: 'assets/images/jobs/cleaningjob1.jpg',
          image2: 'assets/images/jobs/cleaningjob1.jpg',
          description: 'Office pantry cleaning in Kottawa.',
        ),
      ],
    );
  }

  Widget _buildJobCard({
    required String image1,
    required String image2,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Two Images in a Row
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(image1, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(image2, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            description,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
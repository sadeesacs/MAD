// recent_jobs.dart
import 'package:flutter/material.dart';

class RecentJobs extends StatelessWidget {
  const RecentJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(13.0),
      children: [
        _buildJobCard(
          image1: 'assets/images/jobs/cleaningjob1.jpg',
          image2: 'assets/images/jobs/cleaningjob1.jpg',
          description: 'Kitchen cleaning for a family home in Colombo.',
        ),
        // ...
      ],
    );
  }

  Widget _buildJobCard({required String image1, required String image2, required String description}) {
    return Container(
      // ...
    );
  }
}

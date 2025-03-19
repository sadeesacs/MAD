import 'package:flutter/material.dart';
import 'add_recent_job_screen.dart'; // Adjust import based on actual project structure

class RecentJobsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> jobs; // Each job has 'images':[], 'description':''

  const RecentJobsWidget({
    super.key,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + add icon
        Row(
          children: [
            const Text(
              'Recent Jobs',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF027335),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddRecentJobScreen(),
                  ),
                ).then((value) {
                  // Handle any updates to jobs list if needed
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // List of job cards
        Column(
          children: jobs.map((job) {
            return _buildJobCard(job);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final List<String> images = job['images'] as List<String>;
    final String desc = job['description'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF027335)),
        borderRadius: BorderRadius.circular(16), // 10% corners
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Two images side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: images.map((imgPath) {
              return Image.asset(
                imgPath,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            desc,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

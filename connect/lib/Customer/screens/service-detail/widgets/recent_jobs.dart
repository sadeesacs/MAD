// lib/Customer/screens/service-detail/widgets/recent_jobs.dart
import 'package:flutter/material.dart';
import '../../../../util/image_provider_helper.dart';

class RecentJobs extends StatelessWidget {
  final List<Map<String, dynamic>> recentJobsList;

  const RecentJobs({Key? key, required this.recentJobsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentJobsList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No recent jobs available.'),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(13.0),
      itemCount: recentJobsList.length,
      itemBuilder: (context, index) {
        final job = recentJobsList[index];
        final images = (job['images'] as List?) ?? [];
        final description = job['description'] ?? 'No description';
        // (Optional) final Timestamp date = job['date'] ?? ...
        return _buildJobCard(images, description);
      },
    );
  }

  Widget _buildJobCard(List images, String description) {
    // We assume 2 images, but we can adapt
    final img1 = images.isNotEmpty ? images[0] : '';
    final img2 = images.length > 1 ? images[1] : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Two Images side by side
          Row(
            children: [
              Expanded(child: _buildImage(img1)),
              const SizedBox(width: 8),
              Expanded(child: _buildImage(img2)),
            ],
          ),
          const SizedBox(height: 8),
          // Description
          Text(description, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    return Container(
      height: 100,
      color: Colors.grey[200],
      child: Image(
        image: getImageProvider(path),
        fit: BoxFit.cover,
      ),
    );
  }
}

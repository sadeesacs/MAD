import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentJobsWidget extends StatelessWidget {
  final String serviceId;
  final VoidCallback onAdd;

  const RecentJobsWidget({
    super.key,
    required this.serviceId,
    required this.onAdd,
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
              onTap: onAdd,
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
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('services').doc(serviceId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final serviceData = snapshot.data!.data() as Map<String, dynamic>;
            final recentJobsRefs = (serviceData['recentJobs'] as List<dynamic>).cast<DocumentReference>();

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchRecentJobs(recentJobsRefs),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                final jobs = snapshot.data ?? [];

                if (jobs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recent jobs available',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                return Column(
                  children: jobs.map((job) {
                    return _buildJobCard(job);
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _fetchRecentJobs(List<DocumentReference> recentJobsRefs) async {
    final fetchedRecentJobs = <Map<String, dynamic>>[];

    for (final ref in recentJobsRefs) {
      final docSnapshot = await ref.get();
      if (docSnapshot.exists) {
        final jobData = docSnapshot.data() as Map<String, dynamic>;
        fetchedRecentJobs.add(jobData);
      }
    }

    return fetchedRecentJobs;
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
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imgPath),
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/other/service_default_image.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    );
                  },
                ),
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
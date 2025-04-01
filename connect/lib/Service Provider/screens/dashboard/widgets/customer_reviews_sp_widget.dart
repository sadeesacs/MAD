import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerReviewsSPWidget extends StatelessWidget {
  const CustomerReviewsSPWidget({super.key});

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
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('services')
              .where('serviceProvider',
                  isEqualTo: FirebaseFirestore.instance
                      .doc('/users/${FirebaseAuth.instance.currentUser!.uid}'))
              .snapshots(),
          builder: (context, servicesSnapshot) {
            if (servicesSnapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (servicesSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final services = servicesSnapshot.data!.docs;
            final reviewRefs = services
                .expand((service) =>
                    (service.data() as Map<String, dynamic>)['reviews'] ?? [])
                .cast<DocumentReference>()
                .toList();

            if (reviewRefs.isEmpty) {
              return const Text('No reviews available');
            }

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reviews')
                  .where(FieldPath.documentId,
                      whereIn: reviewRefs.map((ref) => ref.id).toList())
                  .snapshots(),
              builder: (context, reviewsSnapshot) {
                if (reviewsSnapshot.hasError) {
                  return const Text('Error loading reviews');
                }

                if (reviewsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reviews = reviewsSnapshot.data!.docs;

                return SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final review =
                          reviews[index].data() as Map<String, dynamic>;
                      return FutureBuilder<DocumentSnapshot>(
                        future: (review['author'] as DocumentReference).get(),
                        builder: (context, authorSnapshot) {
                          String authorName = 'Loading...';
                          if (authorSnapshot.hasData &&
                              authorSnapshot.data != null) {
                            final authorData = authorSnapshot.data!.data()
                                as Map<String, dynamic>?;
                            authorName = authorData?['name'] ?? 'Unknown';
                          }

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
                                Row(
                                  children: [
                                    ...List.generate(5, (i) {
                                      final rating =
                                          (review['rate'] ?? 0.0) as num;
                                      if (i < rating.floor()) {
                                        return const Icon(Icons.star,
                                            color: Color(0xFFFFD700), size: 16);
                                      } else if (i < rating) {
                                        return const Icon(Icons.star_half,
                                            color: Color(0xFFFFD700), size: 16);
                                      }
                                      return const Icon(Icons.star_border,
                                          color: Color(0xFFFFD700), size: 16);
                                    }),
                                    const SizedBox(width: 4),
                                    Text(
                                      (review['rate'] ?? 0.0).toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '"${review['comment'] ?? ''}"',
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
                                    '~ $authorName',
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
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

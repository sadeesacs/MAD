import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../popups/rate_review_bottom_sheet.dart';

class BookingHistoryCard extends StatelessWidget {
  final String bookingDocId; // Firestore doc ID if you need it
  final Map<String, dynamic> bookingData;

  const BookingHistoryCard({
    Key? key,
    required this.bookingDocId,
    required this.bookingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String bookingId       = bookingData['bookingId']       ?? '';
    final String serviceType     = bookingData['serviceType']     ?? '';
    final String serviceProvider = bookingData['serviceProvider'] ?? '';
    final String serviceName     = bookingData['serviceName']     ?? '';
    final String date            = bookingData['date']            ?? '';
    final String time            = bookingData['time']            ?? '';
    final String total           = bookingData['total']           ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF027335)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Booking ID', bookingId),
          const SizedBox(height: 8),
          _buildRow('Service Type', serviceType),
          const SizedBox(height: 8),
          _buildRow('Service Provider', serviceProvider),
          const SizedBox(height: 8),
          _buildRow('Service Name', serviceName),
          const SizedBox(height: 8),
          _buildRow('Date', date),
          const SizedBox(height: 8),
          _buildRow('Time', time),
          const SizedBox(height: 8),
          _buildRow('Total', total),
          const SizedBox(height: 16),
          // Rate button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () async {
                // Show bottom sheet for rating + review.
                final result = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return RateReviewBottomSheet(bookingData: bookingData);
                  },
                );

                // If the user submitted the review (not canceled),
                // we get the result => store in Firestore "reviews" collection.
                if (result != null && result['rating'] != null) {
                  // rating is integer or double, review is string
                  final double rating = (result['rating'] as int).toDouble();
                  final String comment = result['review'] ?? '';

                  // Save it in Firestore
                  // You may want to store the bookingDocId or service doc reference if needed
                  // But the spec says the doc must look like:
                  // author: <reference to user doc>
                  // comment: "some text"
                  // rate: 3.5
                  // So we do exactly that.
                  // We won't store booking doc references unless you want to.

                  // Create the review doc.
                  // If you'd like to reference the booking or service, you can.
                  await _storeReviewInFirestore(rating, comment);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF027335),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Rate',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  /// Stores the user's rating and comment in the 'reviews' collection
  /// using the minimal schema you specified:
  ///   author:  <reference to user doc>
  ///   comment: <the user's review text>
  ///   rate:    <the star rating as a double>
  Future<void> _storeReviewInFirestore(double rating, String comment) async {
    // We'll do it here for simplicity, or you can do it in a repository.

    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final user = auth.currentUser;
    if (user == null) return; // Not signed in; no-op

    final userDocRef = firestore.collection('users').doc(user.uid);

    await firestore.collection('reviews').add({
      'author': userDocRef,
      'comment': comment,
      'rate': rating,
      // If you want to store references to the booking doc or service doc, you can add them here.
      // E.g. 'bookingRef': <reference to bookingDoc> or 'serviceRef': <reference to service doc>
    });
  }
}

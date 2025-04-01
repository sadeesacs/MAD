import 'package:flutter/material.dart';
import '../popups/rate_review_bottom_sheet.dart';

class BookingHistoryCard extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingHistoryCard({
    Key? key,
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
          // Rate button (in bottom-right)
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                // Show bottom sheet for rating + review
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return RateReviewBottomSheet(bookingData: bookingData);
                  },
                );
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
}
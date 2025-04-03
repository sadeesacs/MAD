import 'package:flutter/material.dart';

class UpcomingBookingCard extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onCancel;

  const UpcomingBookingCard({
    Key? key,
    required this.bookingData,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String bookingId       = bookingData['bookingId']       ?? '';
    final String serviceType     = bookingData['serviceType']     ?? '';
    final String serviceProvider = bookingData['serviceProvider'] ?? '';
    final String serviceName     = bookingData['serviceName']     ?? '';
    final String date            = bookingData['date']            ?? '';
    final String time            = bookingData['time']            ?? '';
    final String estimatedTotal  = bookingData['estimatedTotal']  ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF027335)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking ID
          _buildLabelValueRow('Booking ID', bookingId),
          const SizedBox(height: 10),

          // Service Type
          _buildLabelValueRow('Service Type', serviceType),
          const SizedBox(height: 10),

          // Service Provider
          _buildLabelValueRow('Service Provider', serviceProvider),
          const SizedBox(height: 10),

          // Service Name
          _buildLabelValueRow('Service Name', serviceName),
          const SizedBox(height: 10),

          // Date
          _buildLabelValueRow('Date', date),
          const SizedBox(height: 10),

          // Time
          _buildLabelValueRow('Time', time),
          const SizedBox(height: 10),

          // Estimated Total
          _buildLabelValueRow('Estimated Total', estimatedTotal),
          const SizedBox(height: 15),

          // Cancel button (bottom right)
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF027335),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValueRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
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

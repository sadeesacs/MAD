import 'package:flutter/material.dart';

class PendingRequestsCard extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onDetailsPressed;

  const PendingRequestsCard({
    Key? key,
    required this.bookingData,
    required this.onDetailsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String bookingId      = bookingData['bookingId']      ?? '';
    final String serviceType    = bookingData['serviceType']    ?? '';
    final String customer       = bookingData['customer']       ?? '';
    final String serviceName    = bookingData['serviceName']    ?? '';
    final String date           = bookingData['date']           ?? '';
    final String time           = bookingData['time']           ?? '';
    final String total = bookingData['total'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF027335)),
        borderRadius: BorderRadius.circular(16), // 10% corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Booking ID', bookingId),
          const SizedBox(height: 8),
          _buildRow('Service Type', serviceType),
          const SizedBox(height: 8),
          _buildRow('Customer', customer),
          const SizedBox(height: 8),
          _buildRow('Service Name', serviceName),
          const SizedBox(height: 8),
          _buildRow('Date', date),
          const SizedBox(height: 8),
          _buildRow('Time', time),
          const SizedBox(height: 8),
          _buildRow('Estimated Total', total),
          const SizedBox(height: 16),
          // "Details" button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: onDetailsPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF027335),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Details',
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

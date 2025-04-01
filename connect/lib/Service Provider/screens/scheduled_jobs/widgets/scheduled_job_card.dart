import 'package:flutter/material.dart';

const Color darkGreen = Color(0xFF027335);
const Color white = Colors.white;

class ScheduledJobCard extends StatelessWidget {
  final String bookingId;
  final String serviceType;
  final String customerName;
  final String date;
  final String time;
  final String total;
  final VoidCallback onComplete;
  final VoidCallback onViewDetails;

  const ScheduledJobCard({
    super.key,
    required this.bookingId,
    required this.serviceType,
    required this.customerName,
    required this.date,
    required this.time,
    required this.total,
    required this.onComplete,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, // no fill
      elevation: 0, // remove elevation/shadow
      shape: RoundedRectangleBorder(
        side: BorderSide(color: darkGreen, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Details (Two Columns)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Labels Column
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking ID:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Service Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Customer:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Estimated Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 16),
                // Data Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookingId),
                    Text(serviceType),
                    Text(customerName),
                    Text(date),
                    Text(time),
                    Text(total),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                const SizedBox(width: 8),
                // Complete button
                ElevatedButton(
                  onPressed: onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Complete',
                    style: TextStyle(color: white),
                  ),
                ),
                const SizedBox(width: 8),
                // Details button
                OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: darkGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Details',
                    style: TextStyle(color: darkGreen),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

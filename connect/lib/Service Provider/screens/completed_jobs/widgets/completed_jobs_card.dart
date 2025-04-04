import 'package:flutter/material.dart';
import '../popups/view_rating_bottom_sheet.dart';

class CompletedJobsCard extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const CompletedJobsCard({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final String bookingId      = bookingData['bookingId']      ?? '';
    final String serviceType    = bookingData['serviceType']    ?? '';
    final String customer       = bookingData['customer']       ?? '';
    final String date           = bookingData['date']           ?? '';
    final String time           = bookingData['time']           ?? '';
    final String total          = bookingData['total']          ?? '';
    // rating & review for bottom sheet
    final int rating            = bookingData['rating']         ?? 0;
    final String review         = bookingData['review']         ?? '';
    final String reviewDate     = bookingData['reviewDate']     ?? '';

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
          _buildRow('Booking ID', bookingId),
          const SizedBox(height: 8),
          _buildRow('Service Type', serviceType),
          const SizedBox(height: 8),
          _buildRow('Customer', customer),
          const SizedBox(height: 8),
          _buildRow('Date', date),
          const SizedBox(height: 8),
          _buildRow('Time', time),
          const SizedBox(height: 8),
          _buildRow('Estimated Total', total),
          const SizedBox(height: 16),
          
          // Show stars for the rating
          if (rating > 0)
            Row(
              children: [
                const Text(
                  'Rating: ',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                ...List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ],
            ),
          const SizedBox(height: 16),
          
          // "View Rating" button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return ViewRatingBottomSheet(
                      rating: rating,
                      review: review,
                      customerName: customer,
                      reviewDate: reviewDate,
                    );
                  },
                );
              },
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
              child: Text(
                rating > 0 ? 'View Rating' : 'No Rating Yet',
                style: const TextStyle(
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
          flex: 3,
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
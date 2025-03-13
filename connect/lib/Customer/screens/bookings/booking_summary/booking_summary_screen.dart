import 'package:flutter/material.dart';
import '../../../widgets/connect_app_bar.dart';
import 'package:intl/intl.dart';

import '../booking/booking_model.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  late BookingModel bookingModel;
  late double totalCost;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is BookingModel) {
      bookingModel = args;
      // Calculate total cost
      // We know the service price is 500/h from the booking screen’s example
      final hours = bookingModel.totalHours;
      totalCost = hours * 500.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back + Title
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFE9E3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF027335),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Booking Summary',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFF027335),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // The summary labels + info
            _buildRow('Service Type', 'Cleaning'),
            const SizedBox(height: 8),
            _buildRow('Service Provider', 'Leo Perera'),
            const SizedBox(height: 8),
            _buildRow('Service Name', 'Kitchen Cleaning'),
            const SizedBox(height: 8),
            _buildRow(
              'Date',
              bookingModel.date != null
                  ? DateFormat('yyyy/MM/dd').format(bookingModel.date!)
                  : '',
            ),
            const SizedBox(height: 8),
            _buildRow(
              'Time',
              '${_formatTime(bookingModel.fromTime)} To ${_formatTime(bookingModel.toTime)}',
            ),
            const SizedBox(height: 16),

            // Estimated Total (in a rectangle with #F6FAF8 background and #027335 border)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAF8),
                border: Border.all(color: const Color(0xFF027335)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'Estimated Total',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500, // Medium
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'LKR ${totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Confirm Booking button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to booking confirmation
                  Navigator.pushNamed(context, '/bookingConfirmation');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String info) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500, // Medium
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        Text(
          info,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400, // Regular
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('h:mm a').format(dt);
  }
}

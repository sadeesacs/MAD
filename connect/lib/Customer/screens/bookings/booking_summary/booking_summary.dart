import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/connect_app_bar.dart';
import '../booking_confirmation/booking_confirmation.dart';
import '../booking_form_data.dart';

class BookingSummary extends StatefulWidget {
  final BookingFormData formData;

  const BookingSummary({super.key, required this.formData});

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  double? _estimatedTotal;

  @override
  void initState() {
    super.initState();
    _computeEstimatedTotal();
  }

  void _computeEstimatedTotal() {
    DateTime baseDate;
    try {
      baseDate = DateFormat('yyyy/MM/dd').parse(widget.formData.date!);
    } catch (_) {
      baseDate = DateTime.now();
    }

    final fromStr = widget.formData.fromTime ?? '0:00 AM';
    final toStr = widget.formData.toTime ?? '0:00 AM';

    final fromDt = _parseTime(fromStr, baseDate);
    final toDt = _parseTime(toStr, baseDate);

    int diffInMinutes = toDt.difference(fromDt).inMinutes;
    if (diffInMinutes < 0) {
      diffInMinutes = 0;
    }
    final diffInHours = diffInMinutes / 60.0;

    setState(() {
      _estimatedTotal = widget.formData.pricePerHour * diffInHours;
    });
  }

  DateTime _parseTime(String timeStr, DateTime baseDate) {
    timeStr = timeStr.trim();
    if (!timeStr.contains('AM') && !timeStr.contains('PM')) {
      // If no AM/PM, fallback to base date
      throw FormatException("No AM/PM in time string: $timeStr");
    }

    final parts = timeStr.split(' ');
    if (parts.length != 2) {
      throw FormatException("Invalid time format: $timeStr");
    }

    final hourMin = parts[0].split(':');
    if (hourMin.length != 2) {
      throw FormatException("Invalid HH:MM in $timeStr");
    }

    int hour = int.parse(hourMin[0]);
    int minute = int.parse(hourMin[1]);
    final meridiem = parts[1].toUpperCase();

    if (meridiem == 'PM' && hour < 12) hour += 12;
    if (meridiem == 'AM' && hour == 12) hour = 0;

    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.formData;

    return Scaffold(
      appBar: const ConnectAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back + "Booking Summary"
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Go back to booking screen
                    Navigator.pop(context);
                  },
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
                const Expanded(
                  child: Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF027335),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Service Type
            _buildSummaryRow(
              label: 'Service Type',
              value: form.category,
            ),
            const SizedBox(height: 25),

            // Service Provider
            _buildSummaryRow(
              label: 'Service Provider',
              value: form.providerName,
            ),
            const SizedBox(height: 25),

            // Service Name
            _buildSummaryRow(
              label: 'Service Name',
              value: form.serviceTitle,
            ),
            const SizedBox(height: 15),

            // Date
            _buildSummaryRow(
              label: 'Date',
              value: form.date ?? '',
            ),
            const SizedBox(height: 25),

            // Time
            _buildSummaryRow(
              label: 'Time',
              value: '${form.fromTime} To ${form.toTime}',
            ),
            const SizedBox(height: 25),

            // Estimated total
            Container(
              padding: const EdgeInsets.all(12),
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
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'LKR ${_estimatedTotal?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 130),

            // Confirm Booking button
            Center(
              child: ElevatedButton(
                onPressed: _onConfirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
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

  Widget _buildSummaryRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        // Value
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _onConfirmBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BookingConfirmation(),
      ),
    );
  }
}
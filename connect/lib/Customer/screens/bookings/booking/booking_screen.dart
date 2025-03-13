import 'package:flutter/material.dart';
import '../../../widgets/connect_app_bar.dart';
import '../booking_form_data.dart';
import 'widgets/date_input.dart';
import 'widgets/time_input.dart';
import 'widgets/district_input.dart';
import 'widgets/location_input.dart';
import '../booking_summary/booking_summary.dart';

class BookingScreen extends StatefulWidget {
  final BookingFormData formData;

  const BookingScreen({super.key, required this.formData});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isDateValid = true;
  bool _isTimeValid = true;
  bool _isDistrictValid = true;
  bool _isAddressValid = true;
  bool _isLocationValid = true;

  @override
  void initState() {
    super.initState();
    if (widget.formData.address != null) {
      _addressController.text = widget.formData.address!;
    }
    if (widget.formData.additionalNotes != null) {
      _notesController.text = widget.formData.additionalNotes!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                const Spacer(),
                const Text(
                  'Booking Service',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFF027335),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 30),

            /// Service card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover image from formData
                Container(
                  width: 100,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(widget.formData.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title, provider, price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.formData.serviceTitle,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'By ${widget.formData.providerName}',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'LKR ${widget.formData.pricePerHour.toStringAsFixed(2)}/h',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),

            /// 1) Select Date
            const Text(
              'Select Date',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            DateInput(
              initialDate: widget.formData.date,
              isError: !_isDateValid,
              onDateSelected: (val) {
                setState(() {
                  widget.formData.date = val;
                  _isDateValid = true; // user picked a date => valid
                });
              },
            ),
            const SizedBox(height: 25),

            /// 2) Select Time
            const Text(
              'Select Time',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TimeInput(
              initialFromTime: widget.formData.fromTime,
              initialToTime: widget.formData.toTime,
              isError: !_isTimeValid,
              onTimeSelected: (from, to) {
                setState(() {
                  // Make sure we store times in "3:00 PM" format
                  widget.formData.fromTime = from;
                  widget.formData.toTime = to;
                  _isTimeValid = true;
                });
              },
            ),
            const SizedBox(height: 25),

            /// 3) Select District
            const Text(
              'Select District',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            DistrictInput(
              initialDistrict: widget.formData.district,
              isError: !_isDistrictValid,
              onDistrictSelected: (val) {
                setState(() {
                  widget.formData.district = val;
                  _isDistrictValid = true;
                });
              },
            ),
            const SizedBox(height: 25),

            /// 4) Enter Address
            const Text(
              'Enter Address',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _addressController,
              hint: 'Enter your address here',
              isError: !_isAddressValid,
              onChanged: (val) {
                widget.formData.address = val;
              },
            ),
            const SizedBox(height: 25),

            /// 5) Select location (map)
            const Text(
              'Select Location',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            LocationInput(
              lat: widget.formData.latitude,
              lng: widget.formData.longitude,
              isError: !_isLocationValid,
              onLocationPicked: (lat, lng) {
                setState(() {
                  widget.formData.latitude = lat;
                  widget.formData.longitude = lng;
                  _isLocationValid = true;
                });
              },
            ),
            const SizedBox(height: 25),

            /// 6) Additional Notes
            const Text(
              'Additional Notes',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _notesController,
              hint: 'Additional Notes',
              isError: false,
              maxLines: 4,
              onChanged: (val) {
                // Limit to 100 words
                final words = val.trim().split(RegExp(r'\s+'));
                if (words.length > 100) {
                  final truncated = words.take(100).join(' ');
                  _notesController.text = truncated;
                  _notesController.selection = TextSelection.fromPosition(
                    TextPosition(offset: truncated.length),
                  );
                } else {
                  widget.formData.additionalNotes = val;
                }
              },
            ),
            const SizedBox(height: 25),

            /// Next Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isError,
    int maxLines = 1,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Color(0xFF838383),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 10%
          borderSide: BorderSide(
            color: isError ? Colors.red : Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isError ? Colors.red : Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }

  void _onNextPressed() {
    // Validate required fields:
    bool valid = true;

    // Date
    if (widget.formData.date == null || widget.formData.date!.isEmpty) {
      _isDateValid = false;
      valid = false;
    }
    // Time
    if (widget.formData.fromTime == null ||
        widget.formData.fromTime!.isEmpty ||
        widget.formData.toTime == null ||
        widget.formData.toTime!.isEmpty) {
      _isTimeValid = false;
      valid = false;
    }
    // District
    if (widget.formData.district == null || widget.formData.district!.isEmpty) {
      _isDistrictValid = false;
      valid = false;
    }
    // Address
    if (widget.formData.address == null || widget.formData.address!.isEmpty) {
      _isAddressValid = false;
      valid = false;
    }
    // Location
    if (widget.formData.latitude == null || widget.formData.longitude == null) {
      _isLocationValid = false;
      valid = false;
    }

    setState(() {});

    if (!valid) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSummary(
          formData: widget.formData,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date/time
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For maps

import '../../../widgets/connect_app_bar.dart';
import 'booking_model.dart';
import 'widgets/district_search_dialog.dart';

class BookingScreen extends StatefulWidget {
  final String coverImagePath;
  final double pricePerHour;
  final String categoryName;
  final String providerName;
  final String serviceTitle;

  const BookingScreen({
    super.key,
    required this.coverImagePath,
    required this.pricePerHour,
    required this.categoryName,
    required this.providerName,
    required this.serviceTitle,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // We'll store data in a BookingModel
  final BookingModel _bookingModel = BookingModel();

  // For validation
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false; // Tracks if user tapped "Next"

  // Controllers for text fields
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  // Display texts for date/time
  String? _displayDate;
  String? _displayFromTime;
  String? _displayToTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      appBar: const ConnectAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
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
              const SizedBox(height: 16),

              // Service Card
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.coverImagePath,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.serviceTitle,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'By ${widget.providerName}',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'LKR ${widget.pricePerHour.toStringAsFixed(2)}/h',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // The Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Select Date
                    _buildLabel('Select Date'),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _fieldBackgroundColor(
                            isError: _submitted && _bookingModel.date == null,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: Text(
                          _displayDate ?? 'Select Date',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            color: _displayDate == null
                                ? const Color(0xFF838383)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Select Time
                    _buildLabel('Select Time'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // From Time
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(isFromTime: true),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _fieldBackgroundColor(
                                  isError:
                                  _submitted && _bookingModel.fromTime == null,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              child: Text(
                                _displayFromTime ?? 'From',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: _displayFromTime == null
                                      ? const Color(0xFF838383)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          ':',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // To Time
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(isFromTime: false),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _fieldBackgroundColor(
                                  isError:
                                  _submitted && _bookingModel.toTime == null,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              child: Text(
                                _displayToTime ?? 'To',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: _displayToTime == null
                                      ? const Color(0xFF838383)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Select District
                    _buildLabel('Select District'),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _showDistrictSearchDialog,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _fieldBackgroundColor(
                            isError: _submitted &&
                                (_districtController.text.isEmpty),
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _districtController.text.isEmpty
                                    ? 'Select District'
                                    : _districtController.text,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: _districtController.text.isEmpty
                                      ? const Color(0xFF838383)
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Enter Address
                    _buildLabel('Enter Address'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _addressController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _fieldBackgroundColor(
                          isError: _submitted &&
                              _addressController.text.trim().isEmpty,
                        ),
                        hintText: 'Enter your address here',
                        hintStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          color: Color(0xFF838383),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // Additional validation for text field
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return ''; // We won't show text error, just highlight
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Select Location
                    _buildLabel('Select Location'),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _selectLocationOnMap,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _fieldBackgroundColor(
                            isError: _submitted &&
                                (_bookingModel.lat == null ||
                                    _bookingModel.lng == null),
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: Text(
                          (_bookingModel.lat == null || _bookingModel.lng == null)
                              ? 'Click here to select location'
                              : 'Lat: ${_bookingModel.lat}, Lng: ${_bookingModel.lng}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            color: (_bookingModel.lat == null)
                                ? const Color(0xFF838383)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Additional Notes (optional)
                    _buildLabel('Additional Notes'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3, // Reduced height
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Additional Notes',
                        hintStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          color: Color(0xFF838383),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // No mandatory validation for notes
                      validator: (value) {
                        if (value != null &&
                            value.trim().split(' ').length > 100) {
                          return 'Maximum 100 words allowed!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // "Next" button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
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
                  onPressed: _goToConfirmation,
                  child: const Text(
                    'Next',
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
      ),
    );
  }

  // A helper that returns a background color: white or light red if error
  Color _fieldBackgroundColor({required bool isError}) {
    return isError ? Colors.red.shade50 : Colors.white;
  }

  // Helper label builder
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _bookingModel.date = picked;
        _displayDate = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  Future<void> _pickTime({required bool isFromTime}) async {
    final initialTime = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      final now = DateTime.now();
      final selected =
      DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        if (isFromTime) {
          _bookingModel.fromTime = selected;
          _displayFromTime = DateFormat('h:mm a').format(selected);
        } else {
          _bookingModel.toTime = selected;
          _displayToTime = DateFormat('h:mm a').format(selected);
        }
      });
    }
  }

  Future<void> _showDistrictSearchDialog() async {
    final selectedDistrict = await showDialog<String>(
      context: context,
      builder: (_) => const DistrictSearchDialog(),
    );
    if (selectedDistrict != null) {
      setState(() {
        _bookingModel.district = selectedDistrict;
        _districtController.text = selectedDistrict;
      });
    }
  }

  Future<void> _selectLocationOnMap() async {
    final LatLng? pickedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (_) => const SelectLocationScreen()),
    );
    if (pickedLocation != null) {
      setState(() {
        _bookingModel.lat = pickedLocation.latitude;
        _bookingModel.lng = pickedLocation.longitude;
      });
    }
  }

  void _goToConfirmation() {
    // Mark that we've submitted once
    setState(() {
      _submitted = true;
    });

    // Run form validation
    final isValid = _formKey.currentState?.validate() ?? false;

    // Check mandatory fields
    final hasDate = _bookingModel.date != null;
    final hasFromTime = _bookingModel.fromTime != null;
    final hasToTime = _bookingModel.toTime != null;
    final hasDistrict = _districtController.text.isNotEmpty;
    final hasAddress = _addressController.text.trim().isNotEmpty;
    final hasLocation = _bookingModel.lat != null && _bookingModel.lng != null;

    // Only proceed if everything is filled
    if (isValid &&
        hasDate &&
        hasFromTime &&
        hasToTime &&
        hasDistrict &&
        hasAddress &&
        hasLocation) {
      _bookingModel.address = _addressController.text.trim();
      _bookingModel.notes = _notesController.text.trim();

      // Navigate to Booking Confirmation
      Navigator.pushNamed(
        context,
        '/bookingConfirmation',
        arguments: _bookingModel,
      );
    }
  }
}

// A placeholder map location picker using google_maps_flutter
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final LatLng _initialPosition = const LatLng(6.9271, 79.8612); // Example: Colombo
  LatLng? _pickedLocation;

  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(title: const Text('Select Location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (latLng) {
              setState(() {
                _pickedLocation = latLng;
              });
            },
            markers: {
              if (_pickedLocation != null)
                Marker(
                  markerId: const MarkerId('picked'),
                  position: _pickedLocation!,
                ),
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop<LatLng>(context, _pickedLocation);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF027335),
              ),
              child: const Text(
                'Confirm Location',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

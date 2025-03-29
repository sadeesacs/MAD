import 'package:flutter/material.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'edit_widgets/category_selector.dart';
import 'edit_widgets/location_selector.dart';
import 'edit_widgets/time_input.dart';
import 'edit_widgets/available_dates_picker.dart';
import 'edit_widgets/cover_image_picker.dart';

class AddServiceDetailsScreen extends StatefulWidget {
  const AddServiceDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceDetailsScreen> createState() => _AddServiceDetailsScreenState();
}

class _AddServiceDetailsScreenState extends State<AddServiceDetailsScreen> {
  // Controllers for text input
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _coverImageController = TextEditingController();

  // Single-choice category
  String? _selectedCategory;

  // Multi-choice locations
  List<String> _selectedLocations = [];

  // Time input (From and To)
  String? _fromTime;
  String? _toTime;

  // Days of week
  Set<String> _selectedDays = {};

  // Validation flags
  bool _serviceNameError     = false;
  bool _categoryError        = false;
  bool _hourlyRateError      = false;
  bool _locationsError       = false;
  bool _timeError            = false;
  bool _datesError           = false;
  bool _coverImageError      = false;
  bool _jobDescriptionError  = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
      endDrawer: const SPHamburgerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Back button and Title row
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
                const Expanded(
                  child: Text(
                    'Add Service Details',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xFF027335),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Service Name
            _buildLabel('Service Name'),
            const SizedBox(height: 12),
            TextField(
              controller: _serviceNameController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Service Name',
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: Colors.black,
                ),
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _serviceNameError ? Colors.red : Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _serviceNameError ? Colors.red : Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category
            _buildLabel('Category'),
            const SizedBox(height: 12),
            CategorySelector(
              selectedCategory: _selectedCategory, // initially null
              isError: _categoryError,
              onCategorySelected: (cat) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            ),
            const SizedBox(height: 20),

            // Hourly Rate
            _buildLabel('Hourly Rate'),
            const SizedBox(height: 8),
            TextField(
              controller: _hourlyRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'LKR 99.00',
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _hourlyRateError ? Colors.red : Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _hourlyRateError ? Colors.red : Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Location
            _buildLabel('Location'),
            const SizedBox(height: 8),
            LocationSelector(
              selectedLocations: _selectedLocations, // empty initially
              isError: _locationsError,
              onLocationsChanged: (locs) {
                setState(() {
                  _selectedLocations = locs;
                });
              },
            ),
            const SizedBox(height: 20),

            // Available Hours
            _buildLabel('Available Hours'),
            const SizedBox(height: 8),
            TimeInput(
              initialFromTime: _fromTime,
              initialToTime: _toTime,
              isError: _timeError,
              onTimeSelected: (from, to) {
                setState(() {
                  _fromTime = from;
                  _toTime = to;
                });
              },
            ),
            const SizedBox(height: 20),

            // Available Dates
            _buildLabel('Available Dates'),
            const SizedBox(height: 8),
            AvailableDatesPicker(
              selectedDays: _selectedDays, // empty initially
              isError: _datesError,
              onDayToggled: (day) {
                setState(() {
                  if (_selectedDays.contains(day)) {
                    _selectedDays.remove(day);
                  } else {
                    _selectedDays.add(day);
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            // Extra: Job Description
            _buildLabel('Job Description'),
            const SizedBox(height: 8),
            TextField(
              controller: _jobDescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter job description here...',
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _jobDescriptionError ? Colors.red : Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _jobDescriptionError ? Colors.red : Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cover Image
            _buildLabel('Cover Image'),
            const SizedBox(height: 8),
            CoverImagePicker(
              imagePath: _coverImageController.text, // empty initially
              isError: _coverImageError,
              onImagePicked: (path) {
                setState(() {
                  _coverImageController.text = path;
                });
              },
            ),
            const SizedBox(height: 30),

            // Add Service button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onAddService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Add Service',
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  bool _validateInputs() {
    bool valid = true;

    setState(() {
      _serviceNameError = _serviceNameController.text.trim().isEmpty;
      if (_serviceNameError) valid = false;

      _categoryError = (_selectedCategory == null || _selectedCategory!.isEmpty);
      if (_categoryError) valid = false;

      _hourlyRateError = !_validateHourlyRate(_hourlyRateController.text);
      if (_hourlyRateError) valid = false;

      _locationsError = _selectedLocations.isEmpty;
      if (_locationsError) valid = false;

      _timeError = (_fromTime == null || _fromTime!.isEmpty || _toTime == null || _toTime!.isEmpty);
      if (_timeError) valid = false;

      _datesError = _selectedDays.isEmpty;
      if (_datesError) valid = false;

      _jobDescriptionError = _jobDescriptionController.text.trim().isEmpty;
      if (_jobDescriptionError) valid = false;

      _coverImageError = _coverImageController.text.trim().isEmpty;
      if (_coverImageError) valid = false;
    });

    return valid;
  }

  bool _validateHourlyRate(String text) {
    if (!text.startsWith('LKR ')) return false;
    final numberPart = text.substring(4).trim();
    if (numberPart.isEmpty) return false;
    return double.tryParse(numberPart) != null;
  }

  void _onAddService() {
    // Validate fields
    if (!_validateInputs()) return;

    // If all validations pass, create a service map (like in edit)
    final double newRate = double.parse(_hourlyRateController.text.substring(4).trim());

    // Convert selectedDays back to strings
    final dayStrings = _selectedDays.map(_mapLetterToFullDay).toList();

    final newService = <String, dynamic>{
      'serviceName': _serviceNameController.text.trim(),
      'category': _selectedCategory,
      'hourlyRate': newRate,
      'locations': _selectedLocations,
      'availableFrom': _fromTime,
      'availableTo': _toTime,
      'availableDates': dayStrings,
      'jobDescription': _jobDescriptionController.text.trim(),
      'coverImage': _coverImageController.text.trim(),
    };

    // For now, just pop with the newService
    Navigator.pop(context, newService);
  }

  String _mapLetterToFullDay(String letter) {
    switch (letter) {
      case 'M':
        return 'Monday';
      case 'T':
        return 'Tuesday';
      case 'W':
        return 'Wednesday';
      case 'F':
        return 'Friday';
      case 'S':
        return 'Saturday';
      default:
        return letter;
    }
  }
}

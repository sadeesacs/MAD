import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'edit_widgets/category_selector.dart';
import 'edit_widgets/location_selector.dart';
import 'edit_widgets/time_input.dart';
import 'edit_widgets/available_dates_picker.dart';
import 'edit_widgets/cover_image_picker.dart';

class AddServiceDetailsScreen extends StatefulWidget {
  const AddServiceDetailsScreen({super.key});

  @override
  State<AddServiceDetailsScreen> createState() =>
      _AddServiceDetailsScreenState();
}

class _AddServiceDetailsScreenState extends State<AddServiceDetailsScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _coverImageController = TextEditingController();

  String? _selectedCategory;
  List<String> _selectedLocations = [];
  String? _fromTime;
  String? _toTime;
  final Set<String> _selectedDays = {};

  bool _serviceNameError = false;
  bool _categoryError = false;
  bool _hourlyRateError = false;
  bool _locationsError = false;
  bool _timeError = false;
  bool _datesError = false;
  bool _coverImageError = false;
  bool _jobDescriptionError = false;

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
            _buildLabel('Category'),
            const SizedBox(height: 12),
            CategorySelector(
              selectedCategory: _selectedCategory,
              isError: _categoryError,
              onCategorySelected: (cat) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            ),
            const SizedBox(height: 20),
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
            _buildLabel('Location'),
            const SizedBox(height: 8),
            LocationSelector(
              selectedLocations: _selectedLocations,
              isError: _locationsError,
              onLocationsChanged: (locs) {
                setState(() {
                  _selectedLocations = locs;
                });
              },
            ),
            const SizedBox(height: 20),
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
            _buildLabel('Available Dates'),
            const SizedBox(height: 8),
            AvailableDatesPicker(
              selectedDays: _selectedDays,
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
            _buildLabel('Cover Image'),
            const SizedBox(height: 8),
            CoverImagePicker(
              imagePath: _coverImageController.text,
              isError: _coverImageError,
              onImagePicked: (path) {
                setState(() {
                  _coverImageController.text = path;
                });
              },
            ),
            const SizedBox(height: 30),
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

      _categoryError =
          (_selectedCategory == null || _selectedCategory!.isEmpty);
      if (_categoryError) valid = false;

      _hourlyRateError = !_validateHourlyRate(_hourlyRateController.text);
      if (_hourlyRateError) valid = false;

      _locationsError = _selectedLocations.isEmpty;
      if (_locationsError) valid = false;

      _timeError = (_fromTime == null ||
          _fromTime!.isEmpty ||
          _toTime == null ||
          _toTime!.isEmpty);
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

  Future<void> _onAddService() async {
    if (!_validateInputs()) return;

    final double newRate =
        double.parse(_hourlyRateController.text.substring(4).trim());
    final dayStrings = _selectedDays.map(_mapLetterToFullDay).toList();

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocID = user.uid;
    if (userDocID.isEmpty) return;

    final serviceProviderId = userDocID;

    final newService = <String, dynamic>{
      'serviceName': _serviceNameController.text.trim(),
      'serviceProvider': FirebaseFirestore.instance.doc('/users/$serviceProviderId'),
      'category': _selectedCategory,
      'hourlyRate': newRate,
      'locations': _selectedLocations,
      'availableHours': '$_fromTime - $_toTime',
      'availableDates': dayStrings,
      'jobDescription': _jobDescriptionController.text.trim(),
      'coverImage': '',
      'rating': 0.0,
      'status': 'Active',
    };


    final serviceDoc = await FirebaseFirestore.instance.collection('services').add(newService);
    final serviceId = serviceDoc.id;

    await _saveImageLocally(serviceProviderId, serviceId);

    Navigator.pop(context, newService);
  }

  Future<void> _saveImageLocally(String serviceProviderId, String serviceId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final serviceDir = Directory('${directory.path}/images/service/$serviceProviderId');
      if (!await serviceDir.exists()) {
        await serviceDir.create(recursive: true);
      }

      final String fileName = "${serviceProviderId}_${serviceId}_cover.png";
      final coverImagePath = path.join(serviceDir.path, fileName);
      final coverImageFile = File(_coverImageController.text);
      await coverImageFile.copy(coverImagePath);

      // Update the service document with the local image path
      await FirebaseFirestore.instance.collection('services').doc(serviceId).update({
        'coverImage': coverImagePath,
      });
    } catch (e) {
      print("Error saving image: $e");
    }
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

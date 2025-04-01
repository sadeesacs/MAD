import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class EditServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const EditServiceDetailsScreen({
    super.key,
    required this.service,
  });

  @override
  State<EditServiceDetailsScreen> createState() => _EditServiceDetailsScreenState();
}

class _EditServiceDetailsScreenState extends State<EditServiceDetailsScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _coverImageController = TextEditingController();

  String? _selectedCategory;
  List<String> _selectedLocations = [];
  String? _fromTime;
  String? _toTime;
  Set<String> _selectedDays = {};

  bool _serviceNameError = false;
  bool _categoryError = false;
  bool _hourlyRateError = false;
  bool _locationsError = false;
  bool _timeError = false;
  bool _datesError = false;
  bool _coverImageError = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _serviceNameController.text = widget.service['serviceName'] ?? '';
    double rate = widget.service['hourlyRate']?.toDouble() ?? 0.0;
    _hourlyRateController.text = 'LKR ${rate.toStringAsFixed(2)}';
    _selectedCategory = widget.service['category'];
    List<dynamic> locs = widget.service['locations'] ?? [];
    _selectedLocations = locs.map((e) => e.toString()).toList();
    _coverImageController.text = widget.service['coverImage'] ?? '';

    String availableHours = widget.service['availableHours'] ?? '';
    List<String> hours = availableHours.split(' - ');
    if (hours.length == 2) {
      _fromTime = hours[0];
      _toTime = hours[1];
    }

    List<String> days = (widget.service['availableDates'] ?? []).cast<String>();
    _selectedDays = days.map((d) => _mapDayToSingleLetter(d)).toSet();
  }

  String _mapDayToSingleLetter(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 'M';
      case 'tuesday':
        return 'T';
      case 'wednesday':
        return 'W';
      case 'thursday':
        return 'T';
      case 'friday':
        return 'F';
      case 'saturday':
        return 'S';
      case 'sunday':
        return 'S';
      default:
        return day;
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

  bool _validateInputs() {
    setState(() {
      _serviceNameError = _serviceNameController.text.trim().isEmpty;
      _categoryError = (_selectedCategory == null || _selectedCategory!.isEmpty);
      _hourlyRateError = !_validateHourlyRate(_hourlyRateController.text);
      _locationsError = _selectedLocations.isEmpty;
      _timeError = (_fromTime == null || _fromTime!.isEmpty || _toTime == null || _toTime!.isEmpty);
      _datesError = _selectedDays.isEmpty;
      _coverImageError = _coverImageController.text.trim().isEmpty;
    });

    return !(_serviceNameError || _categoryError || _hourlyRateError || _locationsError || _timeError || _datesError || _coverImageError);
  }

  bool _validateHourlyRate(String text) {
    if (!text.startsWith('LKR ')) return false;
    String numberPart = text.substring(4).trim();
    if (numberPart.isEmpty) return false;
    return double.tryParse(numberPart) != null;
  }

  void _onSaveChanges() async {
    if (!_validateInputs()) return;

    final double newRate = double.parse(_hourlyRateController.text.substring(4).trim());
    List<String> dayStrings = _selectedDays.map(_mapLetterToFullDay).toList();

    final updatedService = Map<String, dynamic>.from(widget.service);
    updatedService['serviceName'] = _serviceNameController.text.trim();
    updatedService['category'] = _selectedCategory;
    updatedService['hourlyRate'] = newRate;
    updatedService['locations'] = List<String>.from(_selectedLocations);
    updatedService['availableHours'] = '$_fromTime - $_toTime';
    updatedService['availableDates'] = dayStrings;
    updatedService['coverImage'] = _coverImageController.text.trim();

    await _updateServiceInFirestore(updatedService);
    Navigator.pop(context, updatedService);
  }

  Future<void> _updateServiceInFirestore(Map<String, dynamic> updatedService) async {
    final serviceId = widget.service['id'];
    final serviceDocRef = FirebaseFirestore.instance.collection('services').doc(serviceId);

    try {
      final docSnapshot = await serviceDocRef.get();
      if (docSnapshot.exists) {
        await serviceDocRef.update(updatedService);
        await _saveImageLocally(serviceId);
        print("Service updated successfully");
      } else {
        print("Service document not found");
      }
    } catch (e) {
      print("Error updating service: $e");
    }
  }

  Future<void> _saveImageLocally(String serviceId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final serviceDir = Directory('${directory.path}/images/service/${widget.service['serviceProvider'].id}');
      if (!await serviceDir.exists()) {
        await serviceDir.create(recursive: true);
      }

      final String fileName = "${widget.service['serviceProvider'].id}_${serviceId}_cover.png";
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
                    'Edit Service Details',
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
              selectedCategory: _selectedCategory,
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
              selectedLocations: _selectedLocations,
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

            // Cover Image
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

            // Save Changes button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSaveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Save Changes',
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
}
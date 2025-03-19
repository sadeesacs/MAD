import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

const Color darkGreen = Color(0xFF027335);
const Color white = Colors.white;
const Color black = Colors.black;

class AddServiceForm extends StatefulWidget {
  const AddServiceForm({super.key});

  @override
  _AddServiceFormState createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  String? _selectedCategory;
  List<String> _selectedLocations = [];
  List<String> _selectedDays = [];
  String? _startTime;
  String? _endTime;
  File? _coverImage;

  final List<String> _categories = [
    'Plumbing',
    'Cleaning',
    'Gardening',
    'Electrical',
    'Car Wash',
    'Cooking',
    'Painting',
    'Fitness',
    'Massage',
    'Eldercare',
    'Babysitting',
    'Laundry',
  ];

  final List<String> _locations = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Monaragala',
    'Ratnapura',
    'Kegalle',
  ];

  final List<String> _daysOfWeek = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Service Name
        const Text(
        'Service Name',
        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _serviceNameController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF6FAF8),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: black),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a service name';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Category Dropdown
      const Text(
        'Category',
        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: _selectedCategory,
        items: _categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF6FAF8),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: black),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a category';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Hourly Rate
      const Text(
        'Hourly Rate',
        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _hourlyRateController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF6FAF8),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: black),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an hourly rate';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Location (Multi-Select Dropdown)
          const Text(
            'Location',
            style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF6FAF8),
              border: Border.all(color: black),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            height: 58, // Fixed height for the input field
            child: Row(
              children: [
                // Display selected locations as chips in a single row
                Expanded(

                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _selectedLocations.map((location) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(
                              location,
                              style: const TextStyle(fontSize: 12), // Smaller font size
                            ),
                            onDeleted: () {
                              setState(() {
                                _selectedLocations.remove(location);
                              });
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 5), // Smaller padding
                            visualDensity: VisualDensity.compact, // Compact chip size
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),


                // Dropdown for selecting locations
                DropdownButton<String>(
                  value: null,
                  items: _locations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && !_selectedLocations.contains(newValue)) {
                      setState(() {
                        _selectedLocations.add(newValue);
                      });
                    }
                  },
                  hint: const SizedBox(), // Remove the hint
                  underline: const SizedBox(), // Remove the underline
                  //icon: const Icon(Icons.arrow_drop_down, color: darkGreen), // Custom dropdown icon
                  isDense: true, // Make the dropdown compact
                ),
              ],
            ),
          ),
      const SizedBox(height: 16),

      // Available Hours
      const Text(
        'Available Hours',
        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: TextEditingController(text: _startTime),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF6FAF8),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: TextEditingController(text: _endTime),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF6FAF8),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Available Dates
      const Text(
        'Available Dates',
        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _daysOfWeek.map((day) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedDays.contains(day)) {
                  _selectedDays.remove(day);
                } else {
                  _selectedDays.add(day);
                }
              });
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _selectedDays.contains(day) ? darkGreen : white,
                border: Border.all(color: black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                day,
                style: TextStyle(
                  color: _selectedDays.contains(day) ? white : black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 16),

      // Job Description
      const Text(
        'Job Description',
        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _jobDescriptionController,
        maxLines: 4,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF6FAF8),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: black),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a job description';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Cover Image
      const Text(
        'Cover Image',
        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFF6FAF8),
            border: Border.all(color: black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _coverImage != null
              ? Image.file(_coverImage!, fit: BoxFit.cover)
              : const Center(
            child: Text('', style: TextStyle(color: darkGreen)),
          ),
          ),
        ),
        const SizedBox(height: 24),

        // Add Service Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle form submission
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            child: const Text(
              'Add Service',
              style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
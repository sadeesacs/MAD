import 'package:flutter/material.dart';
import '../../widgets/connect_app_bar_sp.dart';
import 'job_widgets/dual_image_picker.dart';

class AddRecentJobScreen extends StatefulWidget {
  const AddRecentJobScreen({super.key});

  @override
  State<AddRecentJobScreen> createState() => _AddRecentJobScreenState();
}

class _AddRecentJobScreenState extends State<AddRecentJobScreen> {
  String? _image1;
  String? _image2;

  final TextEditingController _descriptionController = TextEditingController();

  bool _image1Error = false;
  bool _image2Error = false;
  bool _descriptionError = false;

  void _onSave() {
    setState(() {
      _image1Error = (_image1 == null || _image1!.isEmpty);
      _image2Error = (_image2 == null || _image2!.isEmpty);
      _descriptionError = _descriptionController.text.trim().isEmpty;
    });

    if (_image1Error || _image2Error || _descriptionError) {
      return;
    }

    final newJob = {
      'images': [_image1!, _image2!],
      'description': _descriptionController.text.trim(),
    };

    Navigator.pop(context, newJob);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button + title row
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
                    'Add Recent Jobs',
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

            // Two image squares
            DualImagePicker(
              image1Path: _image1,
              image2Path: _image2,
              image1Error: _image1Error,
              image2Error: _image2Error,
              onImage1Picked: (path) {
                setState(() => _image1 = path);
              },
              onImage2Picked: (path) {
                setState(() => _image2 = path);
              },
            ),
            const SizedBox(height: 30),

            // Description label
            const Text(
              'Description',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Description input
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 200, // only 200 letters
              decoration: InputDecoration(
                counterText: '',
                fillColor: const Color(0xFFF6FAF8),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _descriptionError ? Colors.red : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _descriptionError ? Colors.red : Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 20% edges
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Save',
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
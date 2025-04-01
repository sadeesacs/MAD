import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'job_widgets/dual_image_picker.dart';

class AddRecentJobScreen extends StatefulWidget {
  final String selectedServiceId;

  const AddRecentJobScreen({super.key, required this.selectedServiceId});

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

  Future<String> _saveImageLocally(String serviceProviderId, String jobId,
      String imagePath, String imageName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final jobDir =
          Directory('${directory.path}/images/recent_jobs/$serviceProviderId');
      if (!await jobDir.exists()) {
        await jobDir.create(recursive: true);
      }

      final String fileName = "${serviceProviderId}_${jobId}_$imageName.png";
      final localImagePath = path.join(jobDir.path, fileName);
      final imageFile = File(imagePath);
      await imageFile.copy(localImagePath);

      return localImagePath;
    } catch (e) {
      print("Error saving image: $e");
      return '';
    }
  }

  void _onSave() async {
    setState(() {
      _image1Error = (_image1 == null || _image1!.isEmpty);
      _image2Error = (_image2 == null || _image2!.isEmpty);
      _descriptionError = _descriptionController.text.trim().isEmpty;
    });

    if (_image1Error || _image2Error || _descriptionError) {
      print("Validation failed: image1Error=$_image1Error, image2Error=$_image2Error, descriptionError=$_descriptionError");
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is logged in");
      return;
    }

    final userDocID = user.uid;
    if (userDocID.isEmpty) {
      print("User document ID is empty");
      return;
    }

    try {
      final jobId = FirebaseFirestore.instance.collection('recent_jobs').doc().id;
      print("Generated job ID: $jobId");

      final image1Path = await _saveImageLocally(userDocID, jobId, _image1!, 'image1');
      final image2Path = await _saveImageLocally(userDocID, jobId, _image2!, 'image2');
      print("Saved images locally: image1Path=$image1Path, image2Path=$image2Path");

      final newJob = {
        'images': [image1Path, image2Path],
        'description': _descriptionController.text.trim(),
        'date': FieldValue.serverTimestamp(), // Add timestamp field
      };

      await FirebaseFirestore.instance.collection('recent_jobs').doc(jobId).set(newJob);
      print("New job added to recent_jobs collection");

      // Update the selected service document with new job reference
      final jobRef = FirebaseFirestore.instance.collection('recent_jobs').doc(jobId);
      await FirebaseFirestore.instance.collection('services').doc(widget.selectedServiceId).update({
        'recentJobs': FieldValue.arrayUnion([jobRef]),
      });
      print("Updated recentJobs array in services collection");

      Navigator.pop(context, newJob); // Ensure this line is executed
    } catch (e) {
      print("Error saving job: $e");
    }
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
                    'Add Recent Job',
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
              onImage1Picked: (path) => setState(() => _image1 = path),
              onImage2Picked: (path) => setState(() => _image2 = path),
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
                    color: _descriptionError ? Colors.red : Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _descriptionError ? Colors.red : Colors.black,
                    width: 2,
                  ),
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
                    borderRadius: BorderRadius.circular(16),
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

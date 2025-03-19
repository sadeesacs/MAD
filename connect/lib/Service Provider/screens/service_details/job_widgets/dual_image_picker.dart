import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DualImagePicker extends StatelessWidget {
  final String? image1Path;
  final String? image2Path;
  final bool image1Error;
  final bool image2Error;
  final ValueChanged<String> onImage1Picked;
  final ValueChanged<String> onImage2Picked;

  const DualImagePicker({
    Key? key,
    this.image1Path,
    this.image2Path,
    required this.image1Error,
    required this.image2Error,
    required this.onImage1Picked,
    required this.onImage2Picked,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context, bool isImage1) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isImage1) {
        onImage1Picked(pickedFile.path);
      } else {
        onImage2Picked(pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // First image square
        Expanded(
          child: InkWell(
            onTap: () => _pickImage(context, true),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAF8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: image1Error ? Colors.red : Colors.black,
                ),
              ),
              child: Stack(
                children: [
                  if (image1Path != null && image1Path!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(image1Path!),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Second image square
        Expanded(
          child: InkWell(
            onTap: () => _pickImage(context, false),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAF8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: image2Error ? Colors.red : Colors.black,
                ),
              ),
              child: Stack(
                children: [
                  if (image2Path != null && image2Path!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(image2Path!),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
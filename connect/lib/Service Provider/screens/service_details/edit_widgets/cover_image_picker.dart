import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CoverImagePicker extends StatefulWidget {
  final String imagePath;
  final bool isError;
  final ValueChanged<String> onImagePicked;

  const CoverImagePicker({
    super.key,
    required this.imagePath,
    required this.isError,
    required this.onImagePicked,
  });

  @override
  State<CoverImagePicker> createState() => _CoverImagePickerState();
}

class _CoverImagePickerState extends State<CoverImagePicker> {
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _localPath = widget.imagePath.isNotEmpty ? widget.imagePath : null;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError ? Colors.red : Colors.black;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF6FAF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        alignment: Alignment.center,
        child: _localPath == null || _localPath!.isEmpty
            ? const Text(
          'Tap to select image',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black54,
          ),
        )
            : _buildImagePreview(_localPath!),
      ),
    );
  }

  Widget _buildImagePreview(String path) {
    if (path.startsWith('http')) {
      // If you have a network URL
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 120,
      );
    } else {
      // Local file
      if (!File(path).existsSync()) {
        return const Text(
          'File not found\nTap to select another image',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        );
      } else {
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 120,
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _localPath = pickedFile.path;
      });
      widget.onImagePicked(pickedFile.path);
    }
  }
}
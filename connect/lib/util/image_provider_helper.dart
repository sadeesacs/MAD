import 'dart:io';
import 'package:flutter/material.dart';

/// Returns an ImageProvider based on the provided [imagePath]:
/// - If [imagePath] is null or empty, returns a placeholder asset image.
/// - If [imagePath] starts with 'http', returns a NetworkImage.
/// - Otherwise, checks if the local file exists and returns a FileImage if so;
///   otherwise, falls back to the placeholder.
ImageProvider getImageProvider(String? imagePath) {
  const String placeholder = 'assets/images/monkey.png';
  if (imagePath == null || imagePath.isEmpty) {
    return const AssetImage(placeholder);
  }
  if (imagePath.startsWith('http')) {
    return NetworkImage(imagePath);
  }
  final file = File(imagePath);
  return file.existsSync() ? FileImage(file) : const AssetImage(placeholder);
}

import 'dart:io';
import 'package:flutter/material.dart';

/// Returns a FileImage if [coverImagePath] starts with '/' and exists;
/// otherwise, returns a NetworkImage if [coverImagePath] is a valid URL.
/// If [coverImagePath] is empty or the file does not exist, returns a fallback asset.
ImageProvider getImageProvider(String coverImagePath) {
  if (coverImagePath.isNotEmpty) {
    if (coverImagePath.startsWith('/')) {
      final file = File(coverImagePath);
      if (file.existsSync()) {
        return FileImage(file);
      }
    } else {
      // You can add additional URL validation if needed.
      return NetworkImage(coverImagePath);
    }
  }
  // Fallback asset
  return const AssetImage('assets/images/monkey.png');
}

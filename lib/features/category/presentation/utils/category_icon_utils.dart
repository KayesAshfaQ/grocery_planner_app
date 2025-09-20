import 'package:flutter/material.dart';

/// Utility class for handling category icon operations
class CategoryIconUtils {
  /// Parses an IconData from imageUri string format "codePoint,fontFamily"
  static IconData? parseIconFromUri(String? imageUri) {
    if (imageUri == null || imageUri.isEmpty) {
      return null;
    }

    try {
      final parts = imageUri.split(',');
      if (parts.length >= 2) {
        final codePoint = int.parse(parts[0]);
        final fontFamily = parts[1];
        return IconData(codePoint, fontFamily: fontFamily);
      }
    } catch (e) {
      // If parsing fails, return null
      return null;
    }

    return null;
  }

  /// Converts an IconData to imageUri string format "codePoint,fontFamily"
  static String? iconToUri(IconData? icon) {
    if (icon == null) {
      return null;
    }

    return '${icon.codePoint},${icon.fontFamily}';
  }
}

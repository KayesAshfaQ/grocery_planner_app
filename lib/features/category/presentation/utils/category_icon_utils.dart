import 'package:flutter/material.dart';
// Import generated LineIcons pack for fallback resolution
import 'package:grocery_planner_app/flutter_iconpicker_packs/LineIcons/LineIcons.dart';

/// Utility class for handling category icon serialization and resolution.
///
/// Icons are stored as a small CSV string: "codePoint,fontFamily,fontPackage,matchTextDirection".
/// For backwards compatibility we accept older values with only "codePoint,fontFamily".
///
/// Important: to keep Flutter's icon font tree-shaking intact we avoid creating
/// IconData instances at runtime. Instead we resolve and return const IconData
/// instances from the generated icon pack (`lineAwesomeIcons`). If an exact
/// const match cannot be found, we return null.
class CategoryIconUtils {
  /// Parse a previously-saved icon URI and return a const IconData from the
  /// generated pack when possible. Returns null when parsing fails or when
  /// no const IconData match exists.
  static IconData? parseIconFromUri(String? imageUri) {
    if (imageUri == null || imageUri.isEmpty) return null;

    final parts = imageUri.split(',');
    if (parts.length < 2) return null;

    final codePoint = int.tryParse(parts[0]);
    if (codePoint == null) return null;

    final family = parts[1].isEmpty ? null : parts[1];
    final package = parts.length >= 3 && parts[2].isNotEmpty ? parts[2] : null;

    // If a package was serialized, try to find an exact match (codePoint + package/family)
    if (package != null && package.isNotEmpty) {
      return _findIconInPack(codePoint, package: package, family: family);
    }

    // Otherwise try a fast lookup by codePoint in the cached map built from the pack.
    return _codePointToIconCache[codePoint];
  }

  /// Serializes an [IconData] into the compact CSV format used by the app.
  /// Format: codePoint,family,package,matchTextDirection
  static String? iconToUri(IconData? icon) {
    if (icon == null) return null;
    final family = icon.fontFamily ?? '';
    final package = icon.fontPackage ?? '';
    final match = icon.matchTextDirection ? 'true' : 'false';
    return '${icon.codePoint},$family,$package,$match';
  }

  // ----------------------
  // Private helpers/cache
  // ----------------------

  /// Find an IconData inside the generated pack that matches the given
  /// codePoint and (optionally) package or family.
  static IconData? _findIconInPack(int codePoint,
      {required String package, String? family}) {
    try {
      for (final pickerIcon in lineAwesomeIcons.values) {
        final data = pickerIcon.data;
        if (data.codePoint != codePoint) continue;
        if (data.fontPackage == package) return data;
        if (family != null && data.fontFamily == family) return data;
      }
    } catch (_) {
      // If the pack isn't available for any reason, swallow and return null.
    }
    return null;
  }

  /// Lazily-built cache mapping codePoint -> const IconData for O(1) lookups.
  static final Map<int, IconData> _codePointToIconCache =
      _buildCodePointCache();

  static Map<int, IconData> _buildCodePointCache() {
    final map = <int, IconData>{};
    try {
      for (final pickerIcon in lineAwesomeIcons.values) {
        map[pickerIcon.data.codePoint] = pickerIcon.data;
      }
    } catch (_) {
      // ignore: If pack isn't present or malformed, return empty map
    }
    return map;
  }
}

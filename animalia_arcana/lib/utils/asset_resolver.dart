import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class AssetResolver {
  // Return paths RELATIVE to assets/ (no leading 'assets/')
  static const String fallbackPlaceholder = 'images/placeholder_card.jpg';

  static Future<bool> _existsAssetKey(String key) async {
    // key must match pubspec key; for our project we prefix 'assets/' when loading
    final fullKey = key.startsWith('assets/') ? key : 'assets/$key';
    try {
      await rootBundle.load(fullKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String _stripAssetsPrefix(String path) {
    return path.startsWith('assets/') ? path.substring(7) : path;
  }

  static Future<String> resolveCardAssetPath(String base, String image) async {
    String normBase = _stripAssetsPrefix(base);
    if (normBase.isNotEmpty && !normBase.endsWith('/')) {
      normBase = '$normBase/';
    }
    final cleanedImage = _stripAssetsPrefix(image);

    final exact = '$normBase$cleanedImage';
    if (kDebugMode) debugPrint('AssetResolver: try exact → $exact');
    if (await _existsAssetKey(exact)) {
      if (kDebugMode) debugPrint('AssetResolver: using $exact');
      return exact;
    }

    final dotIndex = cleanedImage.lastIndexOf('.');
    final stem = (dotIndex > 0 ? cleanedImage.substring(0, dotIndex) : cleanedImage)
        .toLowerCase()
        .replaceAll(' ', '_');

    final png = '$normBase$stem.png';
    if (kDebugMode) debugPrint('AssetResolver: try png → $png');
    if (await _existsAssetKey(png)) {
      if (kDebugMode) debugPrint('AssetResolver: using $png');
      return png;
    }

    final jpg = '$normBase$stem.jpg';
    if (kDebugMode) debugPrint('AssetResolver: try jpg → $jpg');
    if (await _existsAssetKey(jpg)) {
      if (kDebugMode) debugPrint('AssetResolver: using $jpg');
      return jpg;
    }

    if (kDebugMode) debugPrint('AssetResolver: fallback → $fallbackPlaceholder');
    if (await _existsAssetKey(fallbackPlaceholder)) return fallbackPlaceholder;

    if (kDebugMode) {
      debugPrint('AssetResolver: placeholder missing, last tried $jpg');
    }
    return jpg; // still relative (no assets/)
  }

  static Future<String> resolveFromFullPath(String fullPath) async {
    final stripped = _stripAssetsPrefix(fullPath);
    final lastSlash = stripped.lastIndexOf('/');
    if (lastSlash == -1) {
      return resolveCardAssetPath('', stripped);
    }
    final base = stripped.substring(0, lastSlash + 1);
    final image = stripped.substring(lastSlash + 1);
    return resolveCardAssetPath(base, image);
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ThemeManager extends ChangeNotifier {
  Color _primary = const Color(0xFF2D1B69);
  Color _secondary = const Color(0xFFFFD700);
  Color _background = const Color(0xFF0A0A0A);
  String _fontFamily = 'Roboto';
  String _backgroundImagePath = '';
  String? _lastDeckId;

  Color get primary => _primary;
  Color get secondary => _secondary;
  Color get background => _background;
  String get fontFamily => _fontFamily;
  String get backgroundImagePath => _backgroundImagePath;

  Future<void> loadThemeForDeck(String deckId) async {
    try {
      final path = 'assets/themes/$deckId.json';
      final jsonStr = await rootBundle.loadString(path);
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;

      final palette = map['palette'] as Map<String, dynamic>?;
      if (palette != null) {
        _background = _parseHexOrFallback(palette['bg'], _background);
        _primary = _parseHexOrFallback(palette['primary'], _primary);
        _secondary = _parseHexOrFallback(palette['accent'], _secondary);
      }

      final font = map['font'] as Map<String, dynamic>?;
      if (font != null) {
        _fontFamily = (font['title'] as String?) ?? _fontFamily;
      }

      final bgImage = map['backgroundImage'];
      if (bgImage is String) {
        _backgroundImagePath = bgImage;
      } else {
        _backgroundImagePath = '';
      }

      _lastDeckId = deckId;
      if (kDebugMode) {
        debugPrint('🎨 Theme loaded for deckId: $deckId');
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ThemeManager: using defaults, failed to load theme for $deckId: $e');
      }
      _lastDeckId = deckId;
      notifyListeners();
    }
  }

  static Color _parseHexOrFallback(dynamic value, Color fallback) {
    if (value is String) {
      var hex = value.replaceAll('#', '').toUpperCase();
      if (hex.length == 6) hex = 'FF$hex';
      final parsed = int.tryParse(hex, radix: 16);
      if (parsed != null) return Color(parsed);
    }
    return fallback;
  }
}
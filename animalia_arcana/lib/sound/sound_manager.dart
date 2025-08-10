import 'package:flutter/foundation.dart';

class SoundManager {
  static Future<void> play(String key) async {
    if (kDebugMode) {
      debugPrint('🔔 Sound hook: play("$key") [stub]');
    }
    // TODO: integrate sound assets / audio player
  }
}
import 'package:flutter/services.dart';

class HapticService {
  static bool _isEnabled = true;

  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  static Future<void> light() async {
    if (!_isEnabled) return;
    await HapticFeedback.lightImpact();
  }

  static Future<void> medium() async {
    if (!_isEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavy() async {
    if (!_isEnabled) return;
    await HapticFeedback.heavyImpact();
  }

  static Future<void> selection() async {
    if (!_isEnabled) return;
    await HapticFeedback.selectionClick();
  }
}

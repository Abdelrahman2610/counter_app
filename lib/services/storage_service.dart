import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/counter_model.dart';
import '../models/counter_history.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Theme settings
  static Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool('dark_mode', isDark);
  }

  static Future<bool> isDarkMode() async {
    return _prefs.getBool('dark_mode') ?? false;
  }

  static Future<void> setColorTheme(String theme) async {
    await _prefs.setString('color_theme', theme);
  }

  static Future<String> getColorTheme() async {
    return _prefs.getString('color_theme') ?? 'indigo';
  }

  // Counter persistence
  static Future<void> saveCounters(List<CounterModel> counters) async {
    final jsonList = counters.map((c) => c.toJson()).toList();
    await _prefs.setString('counters', jsonEncode(jsonList));
  }

  static Future<List<CounterModel>> loadCounters() async {
    final jsonString = _prefs.getString('counters');
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => CounterModel.fromJson(json)).toList();
  }

  // History
  static Future<void> saveHistory(
    String counterId,
    List<CounterHistory> history,
  ) async {
    final jsonList = history.map((h) => h.toJson()).toList();
    await _prefs.setString('history_$counterId', jsonEncode(jsonList));
  }

  static Future<List<CounterHistory>> loadHistory(String counterId) async {
    final jsonString = _prefs.getString('history_$counterId');
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => CounterHistory.fromJson(json)).toList();
  }

  // Settings
  static Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool('sound_enabled', enabled);
  }

  static Future<bool> isSoundEnabled() async {
    return _prefs.getBool('sound_enabled') ?? true;
  }

  static Future<void> setHapticEnabled(bool enabled) async {
    await _prefs.setBool('haptic_enabled', enabled);
  }

  static Future<bool> isHapticEnabled() async {
    return _prefs.getBool('haptic_enabled') ?? true;
  }
}

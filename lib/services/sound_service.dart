import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isEnabled = true;

  static Future<void> init() async {
    _isEnabled = true;
  }

  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  static Future<void> playIncrement() async {
    if (!_isEnabled) return;
    try {
      // Play a simple beep sound (you can replace with actual sound files)
      await _player.play(AssetSource('sounds/increment.wav'));
    } catch (e) {
      // Fallback: no sound if asset missing
      print('Sound error: $e');
    }
  }

  static Future<void> playDecrement() async {
    if (!_isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/decrement.wav'));
    } catch (e) {
      print('Sound error: $e');
    }
  }

  static Future<void> playReset() async {
    if (!_isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/reset.mp3'));
    } catch (e) {
      print('Sound error: $e');
    }
  }

  static Future<void> playGoalReached() async {
    if (!_isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/goal.mp3'));
    } catch (e) {
      print('Sound error: $e');
    }
  }
}

import 'package:vibration/vibration.dart';

/// Simple wrapper for haptic feedback.
class HapticService {
  static bool _enabled = true;

  static bool get enabled => _enabled;
  static set enabled(bool value) => _enabled = value;

  /// Light tap feedback.
  static Future<void> lightTap() async {
    if (!_enabled) return;
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 30);
      }
    } catch (_) {}
  }

  /// Medium feedback for interactions.
  static Future<void> medium() async {
    if (!_enabled) return;
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 60);
      }
    } catch (_) {}
  }

  /// Heavy buzz for evolution / important events.
  static Future<void> heavy() async {
    if (!_enabled) return;
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 150);
      }
    } catch (_) {}
  }

  /// Success pattern.
  static Future<void> success() async {
    if (!_enabled) return;
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 50, 100, 50]);
      }
    } catch (_) {}
  }
}

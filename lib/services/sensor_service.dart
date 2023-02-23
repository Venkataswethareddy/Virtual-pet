import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// Provides accelerometer / gyroscope streams for shake detection and tilt.
class SensorService {
  static StreamSubscription<AccelerometerEvent>? _accelSub;

  /// Tilt values (normalised −1 to 1, used for pet sliding).
  static double tiltX = 0.0;
  static double tiltY = 0.0;

  /// Shake detection callback.
  static Function()? onShake;

  static const double _shakeThreshold = 15.0;

  /// Start listening to accelerometer.
  static void start() {
    _accelSub = accelerometerEventStream().listen((event) {
      // Normalise tilt (-10 to 10 → -1 to 1)
      tiltX = (event.x / 10.0).clamp(-1.0, 1.0);
      tiltY = (event.y / 10.0).clamp(-1.0, 1.0);

      // Shake detection
      final magnitude = event.x.abs() + event.y.abs() + event.z.abs();
      if (magnitude > _shakeThreshold && onShake != null) {
        onShake!();
      }
    });
  }

  /// Stop listening.
  static void stop() {
    _accelSub?.cancel();
    _accelSub = null;
  }
}

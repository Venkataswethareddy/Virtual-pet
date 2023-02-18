import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Wrapper around flutter_local_notifications.
/// Provides scheduled reminders for hunger, play, evolution, and daily login.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  /// Show an immediate notification.
  static Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'tamago_channel',
        'Tamago Alerts',
        channelDescription: 'Pet status alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(id, title, body, details);
  }

  /// Cancel a specific notification.
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel all notifications.
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Convenience methods ──────────────────────────────

  static Future<void> petHungry() => show(
        id: 1,
        title: 'Your pet is hungry! 🍕',
        body: 'Feed it before it gets sick!',
      );

  static Future<void> petMissesYou() => show(
        id: 2,
        title: 'Your pet misses you! 💕',
        body: 'Come play with your pet!',
      );

  static Future<void> petEvolving() => show(
        id: 3,
        title: 'Evolution time! ✨',
        body: 'Your pet is about to evolve. Open the app!',
      );

  static Future<void> dailyReward() => show(
        id: 4,
        title: 'Daily reward waiting! 🎁',
        body: 'Log in to claim your daily coins!',
      );
}

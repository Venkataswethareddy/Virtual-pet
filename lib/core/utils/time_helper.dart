/// Helpers for time-of-day detection, elapsed minutes, and formatting.
class TimeHelper {
  TimeHelper._();

  // ── Time-of-day buckets ──────────────────────────────
  /// Returns one of: 'sunrise', 'day', 'sunset', 'night'.
  static String timeOfDay([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour >= 6 && hour < 8) return 'sunrise';
    if (hour >= 8 && hour < 18) return 'day';
    if (hour >= 18 && hour < 20) return 'sunset';
    return 'night';
  }

  static bool isNight([DateTime? now]) => timeOfDay(now) == 'night';
  static bool isDay([DateTime? now]) => timeOfDay(now) == 'day';

  // ── Elapsed time ─────────────────────────────────────
  /// Minutes since [from] until [to] (defaults to now).
  static double minutesSince(DateTime from, [DateTime? to]) {
    final end = to ?? DateTime.now();
    return end.difference(from).inSeconds / 60.0;
  }

  // ── Age helpers ──────────────────────────────────────
  static int daysSinceBirth(DateTime birthDate) {
    return DateTime.now().difference(birthDate).inDays;
  }

  static String formatAge(DateTime birthDate) {
    final days = daysSinceBirth(birthDate);
    if (days == 0) return 'Newborn';
    if (days == 1) return '1 day old';
    return '$days days old';
  }

  /// Friendly "X min ago" / "X hr ago" strings.
  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

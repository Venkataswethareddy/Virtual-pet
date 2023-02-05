import 'dart:math';

/// Personality DNA — generated at birth, affects all behavior modifiers.
///
/// Each trait ranges 0-100:
/// * **bravery** — brave pets don't get scared on phone shake
/// * **activity** — active pets have faster energy drain but more play reward
/// * **friendliness** — friendly pets show more love animations, higher pat bonus
/// * **appetite** — foodie pets have faster hunger drain but gain more from feeding
class PersonalityModel {
  final double bravery;
  final double activity;
  final double friendliness;
  final double appetite;

  const PersonalityModel({
    required this.bravery,
    required this.activity,
    required this.friendliness,
    required this.appetite,
  });

  /// Generate a random personality with values in [10, 95].
  factory PersonalityModel.random() {
    final rng = Random();
    return PersonalityModel(
      bravery: 10 + rng.nextDouble() * 85,
      activity: 10 + rng.nextDouble() * 85,
      friendliness: 10 + rng.nextDouble() * 85,
      appetite: 10 + rng.nextDouble() * 85,
    );
  }

  /// Human-readable label for a trait value.
  static String traitLabel(double value) {
    if (value >= 75) return 'Very High';
    if (value >= 55) return 'High';
    if (value >= 40) return 'Medium';
    if (value >= 20) return 'Low';
    return 'Very Low';
  }

  /// Serialise / deserialise for Hive storage.
  Map<String, dynamic> toMap() => {
        'bravery': bravery,
        'activity': activity,
        'friendliness': friendliness,
        'appetite': appetite,
      };

  factory PersonalityModel.fromMap(Map<dynamic, dynamic> map) => PersonalityModel(
        bravery: (map['bravery'] as num).toDouble(),
        activity: (map['activity'] as num).toDouble(),
        friendliness: (map['friendliness'] as num).toDouble(),
        appetite: (map['appetite'] as num).toDouble(),
      );
}

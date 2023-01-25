import '../constants/pet_constants.dart';

/// Calculates stat decay over elapsed real time, taking personality into account.
///
/// Personality modifiers:
/// - appetite (0-100): higher → hunger drops *faster*
///   formula: hungerRate * (1 + (appetite - 50) / 100)
/// - activity (0-100): higher → energy drops *faster*
///   formula: energyRate * (1 + (activity - 50) / 100)
/// - friendliness: no direct decay effect, affects interaction gains instead
/// - bravery: no decay effect
class DecayCalculator {
  DecayCalculator._();

  /// Returns the new stat value after [elapsedMinutes] of decay.
  /// Clamps result to [0, 100].
  static double decay(double current, double ratePerMinute, double elapsedMinutes) {
    final result = current - (ratePerMinute * elapsedMinutes);
    return result.clamp(PetConstants.statMin, PetConstants.statMax);
  }

  /// Hunger decay with personality modifier.
  static double hungerDecay(double current, double elapsedMinutes, double appetite) {
    // appetite 0 → 0.5× speed, appetite 50 → 1× speed, appetite 100 → 1.5× speed
    final modifier = 1.0 + (appetite - 50) / 100.0;
    final rate = PetConstants.hungerDecayPerMinute * modifier;
    return decay(current, rate, elapsedMinutes);
  }

  /// Happiness decay — flat rate, no personality modifier.
  static double happinessDecay(double current, double elapsedMinutes) {
    return decay(current, PetConstants.happinessDecayPerMinute, elapsedMinutes);
  }

  /// Energy decay with activity modifier.
  static double energyDecay(double current, double elapsedMinutes, double activity) {
    final modifier = 1.0 + (activity - 50) / 100.0;
    final rate = PetConstants.energyDecayPerMinute * modifier;
    return decay(current, rate, elapsedMinutes);
  }

  /// Energy recharge while app is closed (pet sleeping).
  static double energyRecharge(double current, double elapsedMinutes) {
    final result = current + (PetConstants.energyRechargePerMinute * elapsedMinutes);
    return result.clamp(PetConstants.statMin, PetConstants.statMax);
  }

  /// Health drops when hunger OR happiness is below critical.
  static double healthDecay(double current, double elapsedMinutes, double hunger, double happiness) {
    if (hunger > PetConstants.criticalThreshold && happiness > PetConstants.criticalThreshold) {
      return current; // no health loss
    }
    return decay(current, PetConstants.healthDropRate, elapsedMinutes);
  }

  /// Builds a human-readable summary of what happened while user was away.
  static List<String> whileAwaySummary(double hungerBefore, double hungerAfter,
      double happinessBefore, double happinessAfter, double energyBefore, double energyAfter) {
    final messages = <String>[];
    if (hungerAfter < hungerBefore - 10) messages.add('Your pet got hungry');
    if (happinessAfter < happinessBefore - 10) messages.add('Your pet missed you');
    if (energyAfter > energyBefore + 10) messages.add('Your pet took a nap');
    if (messages.isEmpty) messages.add('Your pet waited patiently for you');
    return messages;
  }
}

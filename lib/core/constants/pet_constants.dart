/// Numeric constants governing pet behaviour.
class PetConstants {
  PetConstants._();

  // ── Stat ranges ──────────────────────────────────────
  static const double statMin = 0.0;
  static const double statMax = 100.0;
  static const double statDefault = 80.0;

  // ── Decay rates (points per minute in real time) ────
  static const double hungerDecayPerMinute = 100.0 / (30 * 60);  // full in 30 min → ~0.056/s
  static const double happinessDecayPerMinute = 100.0 / (60 * 60); // full in 1 hr
  static const double energyDecayPerMinute = 100.0 / (90 * 60);   // full in 1.5 hr

  // ── Energy recharge while app closed (faster) ───────
  static const double energyRechargePerMinute = 100.0 / (45 * 60);

  // ── Critical thresholds ──────────────────────────────
  static const double criticalThreshold = 20.0;
  static const double healthDropRate = 0.5; // per minute when starving/sad

  // ── Interaction effects (base, before personality) ──
  static const double feedHungerBase = 15.0;
  static const double playHappinessBase = 15.0;
  static const double sleepEnergyBase = 30.0;
  static const double healHealthBase = 25.0;
  static const double patHappinessBase = 5.0;

  // ── Evolution day thresholds ─────────────────────────
  static const int babyMaxDay = 3;
  static const int teenMaxDay = 7;
  static const int adultMaxDay = 14;

  // ── Coins ────────────────────────────────────────────
  static const int startingCoins = 100;

  // ── Misc ─────────────────────────────────────────────
  static const Duration thoughtBubbleInterval = Duration(seconds: 12);
  static const Duration statUpdateInterval = Duration(seconds: 10);
}

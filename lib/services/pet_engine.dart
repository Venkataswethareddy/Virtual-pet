import 'dart:async';
import '../core/enums/pet_mood.dart';
import '../core/enums/pet_stage.dart';
import '../core/constants/pet_constants.dart';
import '../core/utils/decay_calculator.dart';
import '../core/utils/evolution_logic.dart';
import '../core/utils/time_helper.dart';
import '../models/pet_model.dart';

/// The core engine that drives all pet behaviour: stat decay, mood calculation,
/// evolution checks, and interaction effects with personality modifiers.
class PetEngine {
  PetEngine._();

  // ─────────────────────────────────────────────────────
  // STAT UPDATES
  // ─────────────────────────────────────────────────────

  /// Tick the pet's stats forward by the time elapsed since [pet.lastUpdated].
  /// Call this on a timer (every ~10s) AND when the app resumes from background.
  static List<String> updateStats(PetModel pet) {
    final now = DateTime.now();
    final elapsed = TimeHelper.minutesSince(pet.lastUpdated, now);
    if (elapsed <= 0) return [];

    // Snapshot old values for while-away summary
    final oldHunger = pet.hunger;
    final oldHappiness = pet.happiness;
    final oldEnergy = pet.energy;

    // Apply decay (or recharge if sleeping)
    pet.hunger = DecayCalculator.hungerDecay(
      pet.hunger, elapsed, pet.personality.appetite,
    );
    pet.happiness = DecayCalculator.happinessDecay(pet.happiness, elapsed);

    if (pet.isSleeping) {
      pet.energy = DecayCalculator.energyRecharge(pet.energy, elapsed);
    } else {
      pet.energy = DecayCalculator.energyDecay(
        pet.energy, elapsed, pet.personality.activity,
      );
    }

    // Health drops when hunger or happiness are critical
    pet.health = DecayCalculator.healthDecay(
      pet.health, elapsed, pet.hunger, pet.happiness,
    );

    // Update mood
    pet.mood = calculateMood(pet);

    // Check evolution
    final ageDays = TimeHelper.daysSinceBirth(pet.birthDate);
    final targetStage = EvolutionLogic.stageForAge(ageDays);
    final neglectStage = EvolutionLogic.checkNeglect(pet.health, pet.stage);

    if (neglectStage != pet.stage) {
      pet.stage = neglectStage;
    } else if (targetStage.index > pet.stage.index &&
        pet.stage != PetStage.sadForm &&
        pet.stage != PetStage.ghostForm) {
      pet.stage = targetStage;
      // Determine/update path when reaching teen stage
      if (targetStage == PetStage.teen || targetStage == PetStage.adult || targetStage == PetStage.legendary) {
        pet.petType = EvolutionLogic.determinePath(
          pet.feedCount, pet.playCount, pet.sleepCount,
        );
      }
      pet.evolutionHistory.add(EvolutionLogic.formLabel(pet.petType, pet.stage));
    }

    pet.lastUpdated = now;

    // Build while-away summary
    return DecayCalculator.whileAwaySummary(
      oldHunger, pet.hunger,
      oldHappiness, pet.happiness,
      oldEnergy, pet.energy,
    );
  }

  // ─────────────────────────────────────────────────────
  // MOOD CALCULATION
  // ─────────────────────────────────────────────────────

  /// Derive mood from current stats. Priority order matters.
  static PetMood calculateMood(PetModel pet) {
    if (pet.isSleeping) return PetMood.sleeping;
    if (pet.health < 20) return PetMood.sick;
    if (pet.hunger < 20) return PetMood.hungry;
    if (pet.happiness < 20) return PetMood.sad;
    if (pet.happiness > 80 && pet.hunger > 60) return PetMood.excited;
    if (pet.happiness > 50) return PetMood.happy;
    return PetMood.sad;
  }

  // ─────────────────────────────────────────────────────
  // INTERACTIONS (with personality modifiers)
  // ─────────────────────────────────────────────────────

  /// Feed the pet. Foodie pets (high appetite) gain more from feeding.
  static void feed(PetModel pet, double amount) {
    // appetite 100 → 1.5× gain; appetite 0 → 0.5× gain
    final modifier = 1.0 + (pet.personality.appetite - 50) / 100.0;
    pet.hunger = (pet.hunger + amount * modifier).clamp(0, 100);
    pet.lastFed = DateTime.now();
    pet.feedCount++;
    pet.mood = calculateMood(pet);
  }

  /// Play with the pet. Active pets (high activity) gain more from playing.
  static void play(PetModel pet) {
    final modifier = 1.0 + (pet.personality.activity - 50) / 100.0;
    pet.happiness = (pet.happiness + PetConstants.playHappinessBase * modifier).clamp(0, 100);
    pet.energy = (pet.energy - 5).clamp(0, 100); // playing costs a bit of energy
    pet.lastPlayed = DateTime.now();
    pet.playCount++;
    pet.mood = calculateMood(pet);
  }

  /// Put the pet to sleep.
  static void sleep(PetModel pet) {
    pet.isSleeping = true;
    pet.lastSlept = DateTime.now();
    pet.sleepCount++;
    pet.mood = PetMood.sleeping;
  }

  /// Wake the pet up.
  static void wake(PetModel pet) {
    pet.isSleeping = false;
    pet.mood = calculateMood(pet);
  }

  /// Heal the pet.
  static void heal(PetModel pet, double amount) {
    pet.health = (pet.health + amount).clamp(0, 100);
    pet.mood = calculateMood(pet);
  }

  /// Pat the pet. Friendly pets gain more.
  static void pat(PetModel pet) {
    final modifier = 1.0 + (pet.personality.friendliness - 50) / 100.0;
    pet.happiness = (pet.happiness + PetConstants.patHappinessBase * modifier).clamp(0, 100);
    pet.mood = calculateMood(pet);
  }

  /// Reaction to phone shake — based on bravery.
  /// Returns true if pet is scared (low bravery), false if excited.
  static bool shakeReaction(PetModel pet) {
    final isScared = pet.personality.bravery < 50;
    if (isScared) {
      pet.mood = PetMood.scared;
      pet.happiness = (pet.happiness - 3).clamp(0, 100);
    } else {
      pet.mood = PetMood.excited;
      pet.happiness = (pet.happiness + 3).clamp(0, 100);
    }
    return isScared;
  }
}

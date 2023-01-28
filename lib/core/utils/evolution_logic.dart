import '../enums/pet_stage.dart';
import '../enums/pet_type.dart';
import '../constants/pet_constants.dart';

/// Determines evolution stage and path based on care history and age.
///
/// Evolution paths:
/// - **Cat path** (fed most): egg → baby → kitten(teen) → cat(adult) → lion(legendary)
/// - **Dog path** (played most): egg → baby → puppy(teen) → dog(adult) → wolf(legendary)
/// - **Bunny path** (slept most): egg → baby → bunny kit(teen) → bunny(adult) → fox(legendary)
///
/// Neglect path: any form → sadForm → ghostForm (recoverable by caring)
class EvolutionLogic {
  EvolutionLogic._();

  /// Returns the [PetType] (evolution path) based on cumulative care counts.
  /// The dominant action determines the path. Ties default to cat > dog > bunny.
  static PetType determinePath(int feedCount, int playCount, int sleepCount) {
    if (feedCount >= playCount && feedCount >= sleepCount) return PetType.cat;
    if (playCount >= feedCount && playCount >= sleepCount) return PetType.dog;
    return PetType.bunny;
  }

  /// Returns the [PetStage] the pet should be at given its age in days.
  static PetStage stageForAge(int ageDays) {
    if (ageDays < 1) return PetStage.egg;
    if (ageDays <= PetConstants.babyMaxDay) return PetStage.baby;
    if (ageDays <= PetConstants.teenMaxDay) return PetStage.teen;
    if (ageDays <= PetConstants.adultMaxDay) return PetStage.adult;
    return PetStage.legendary;
  }

  /// Whether the pet should enter or stay in the neglect path.
  /// Neglect = health below 15 for sadForm, below 5 for ghostForm.
  static PetStage checkNeglect(double health, PetStage currentStage) {
    if (health <= 5) return PetStage.ghostForm;
    if (health <= 15) return PetStage.sadForm;
    // If recovering from ghostForm/sadForm, revert to normal stage
    if (currentStage == PetStage.ghostForm || currentStage == PetStage.sadForm) {
      if (health > 30) return PetStage.baby; // will be re-evaluated by caller
    }
    return currentStage;
  }

  /// Checks if the pet should evolve, returns true when stage changes.
  static bool shouldEvolve(PetStage currentStage, int ageDays) {
    final target = stageForAge(ageDays);
    return target != currentStage &&
        currentStage != PetStage.sadForm &&
        currentStage != PetStage.ghostForm;
  }

  /// Label for the pet's current form combining type + stage.
  /// e.g. "Kitten" (cat teen), "Puppy" (dog teen), "Wolf" (dog legendary)
  static String formLabel(PetType type, PetStage stage) {
    switch (stage) {
      case PetStage.egg:
        return 'Egg';
      case PetStage.baby:
        return 'Baby';
      case PetStage.sadForm:
        return 'Sad Form';
      case PetStage.ghostForm:
        return 'Ghost Form';
      case PetStage.teen:
        switch (type) {
          case PetType.cat:
            return 'Kitten';
          case PetType.dog:
            return 'Puppy';
          case PetType.bunny:
            return 'Bunny Kit';
          case PetType.undecided:
            return 'Teen';
        }
      case PetStage.adult:
        switch (type) {
          case PetType.cat:
            return 'Cat';
          case PetType.dog:
            return 'Dog';
          case PetType.bunny:
            return 'Bunny';
          case PetType.undecided:
            return 'Adult';
        }
      case PetStage.legendary:
        switch (type) {
          case PetType.cat:
            return 'Lion';
          case PetType.dog:
            return 'Wolf';
          case PetType.bunny:
            return 'Fox';
          case PetType.undecided:
            return 'Legendary';
        }
    }
  }
}

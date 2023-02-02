import '../core/enums/pet_mood.dart';
import '../core/enums/pet_stage.dart';
import '../core/enums/pet_type.dart';
import '../core/constants/pet_constants.dart';
import 'personality_model.dart';

/// The main pet data model. Holds all stats, personality, evolution, and tracking data.
class PetModel {
  String name;
  DateTime birthDate;

  // ── Stats (0-100) ────────────────────────────────────
  double hunger;
  double happiness;
  double energy;
  double health;

  // ── Mood (derived, but cached for display) ───────────
  PetMood mood;

  // ── Personality DNA ──────────────────────────────────
  PersonalityModel personality;

  // ── Evolution ────────────────────────────────────────
  PetType petType;
  PetStage stage;
  List<String> evolutionHistory;

  // ── Care tracking (for evolution path determination) ─
  int feedCount;
  int playCount;
  int sleepCount;

  // ── Timestamps ───────────────────────────────────────
  DateTime lastFed;
  DateTime lastPlayed;
  DateTime lastSlept;
  DateTime lastUpdated;

  // ── Economy ──────────────────────────────────────────
  int coins;

  // ── Cosmetics ────────────────────────────────────────
  String? costumeId;

  // ── Sleeping state ───────────────────────────────────
  bool isSleeping;

  PetModel({
    required this.name,
    required this.birthDate,
    this.hunger = PetConstants.statDefault,
    this.happiness = PetConstants.statDefault,
    this.energy = PetConstants.statDefault,
    this.health = PetConstants.statDefault,
    this.mood = PetMood.happy,
    required this.personality,
    this.petType = PetType.undecided,
    this.stage = PetStage.egg,
    List<String>? evolutionHistory,
    this.feedCount = 0,
    this.playCount = 0,
    this.sleepCount = 0,
    DateTime? lastFed,
    DateTime? lastPlayed,
    DateTime? lastSlept,
    DateTime? lastUpdated,
    int? coins,
    this.costumeId,
    this.isSleeping = false,
  })  : evolutionHistory = evolutionHistory ?? [],
        lastFed = lastFed ?? DateTime.now(),
        lastPlayed = lastPlayed ?? DateTime.now(),
        lastSlept = lastSlept ?? DateTime.now(),
        lastUpdated = lastUpdated ?? DateTime.now(),
        coins = coins ?? PetConstants.startingCoins;

  /// Serialise to a map for Hive storage.
  Map<String, dynamic> toMap() => {
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'hunger': hunger,
        'happiness': happiness,
        'energy': energy,
        'health': health,
        'mood': mood.index,
        'personality': personality.toMap(),
        'petType': petType.index,
        'stage': stage.index,
        'evolutionHistory': evolutionHistory,
        'feedCount': feedCount,
        'playCount': playCount,
        'sleepCount': sleepCount,
        'lastFed': lastFed.toIso8601String(),
        'lastPlayed': lastPlayed.toIso8601String(),
        'lastSlept': lastSlept.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
        'coins': coins,
        'costumeId': costumeId,
        'isSleeping': isSleeping,
      };

  factory PetModel.fromMap(Map<dynamic, dynamic> map) => PetModel(
        name: map['name'] as String,
        birthDate: DateTime.parse(map['birthDate'] as String),
        hunger: (map['hunger'] as num).toDouble(),
        happiness: (map['happiness'] as num).toDouble(),
        energy: (map['energy'] as num).toDouble(),
        health: (map['health'] as num).toDouble(),
        mood: PetMood.values[map['mood'] as int],
        personality: PersonalityModel.fromMap(map['personality'] as Map),
        petType: PetType.values[map['petType'] as int],
        stage: PetStage.values[map['stage'] as int],
        evolutionHistory: List<String>.from(map['evolutionHistory'] ?? []),
        feedCount: map['feedCount'] as int? ?? 0,
        playCount: map['playCount'] as int? ?? 0,
        sleepCount: map['sleepCount'] as int? ?? 0,
        lastFed: DateTime.parse(map['lastFed'] as String),
        lastPlayed: DateTime.parse(map['lastPlayed'] as String),
        lastSlept: DateTime.parse(map['lastSlept'] as String),
        lastUpdated: DateTime.parse(map['lastUpdated'] as String),
        coins: map['coins'] as int? ?? PetConstants.startingCoins,
        costumeId: map['costumeId'] as String?,
        isSleeping: map['isSleeping'] as bool? ?? false,
      );
}

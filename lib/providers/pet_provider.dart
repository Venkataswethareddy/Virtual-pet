import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/pet_constants.dart';
import '../core/constants/app_strings.dart';
import '../core/enums/pet_mood.dart';
import '../core/enums/pet_stage.dart';
import '../core/utils/time_helper.dart';
import '../models/pet_model.dart';
import '../models/personality_model.dart';
import '../models/shop_item_model.dart';
import '../services/pet_engine.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';

/// Central provider managing the pet's lifecycle, stats, interactions, and persistence.
class PetProvider extends ChangeNotifier {
  PetModel? _pet;
  Timer? _statTimer;
  Timer? _thoughtTimer;
  String _currentThought = '';
  List<String> _whileAwaySummary = [];
  bool _showEvolution = false;

  PetModel? get pet => _pet;
  String get currentThought => _currentThought;
  List<String> get whileAwaySummary => _whileAwaySummary;
  bool get showEvolution => _showEvolution;
  bool get hasPet => _pet != null;

  void clearEvolution() {
    _showEvolution = false;
    notifyListeners();
  }

  void clearWhileAway() {
    _whileAwaySummary = [];
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────
  // INITIALISATION
  // ─────────────────────────────────────────────────────

  /// Load existing pet from storage, apply time-away decay.
  Future<void> loadPet() async {
    _pet = StorageService.loadPet();
    if (_pet != null) {
      // Apply decay for time away
      _whileAwaySummary = PetEngine.updateStats(_pet!);
      await _save();
      _startTimers();
    }
    notifyListeners();
  }

  /// Create a brand new pet.
  Future<void> createPet(String name) async {
    _pet = PetModel(
      name: name,
      birthDate: DateTime.now(),
      personality: PersonalityModel.random(),
      stage: PetStage.baby,
    );
    _pet!.evolutionHistory.add('Baby');
    await _save();
    _startTimers();
    notifyListeners();
  }

  /// Reset / delete the pet.
  Future<void> resetPet() async {
    _stopTimers();
    _pet = null;
    await StorageService.deletePet();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────
  // PERIODIC STAT UPDATES
  // ─────────────────────────────────────────────────────

  void _startTimers() {
    _statTimer?.cancel();
    _thoughtTimer?.cancel();

    _statTimer = Timer.periodic(PetConstants.statUpdateInterval, (_) {
      if (_pet == null) return;
      final oldStage = _pet!.stage;
      PetEngine.updateStats(_pet!);
      if (_pet!.stage != oldStage) {
        _showEvolution = true;
        AudioService.playEvolve();
      }
      _save();
      notifyListeners();
    });

    _thoughtTimer = Timer.periodic(PetConstants.thoughtBubbleInterval, (_) {
      _updateThought();
    });
  }

  void _stopTimers() {
    _statTimer?.cancel();
    _thoughtTimer?.cancel();
    _statTimer = null;
    _thoughtTimer = null;
  }

  void _updateThought() {
    if (_pet == null) return;
    final rng = Random();
    List<String> pool;
    switch (_pet!.mood) {
      case PetMood.hungry:
        pool = AppStrings.hungryThoughts;
        break;
      case PetMood.sad:
        pool = AppStrings.sadThoughts;
        break;
      case PetMood.sleeping:
        pool = AppStrings.sleepyThoughts;
        break;
      case PetMood.sick:
        pool = AppStrings.sickThoughts;
        break;
      default:
        pool = AppStrings.happyThoughts;
    }
    _currentThought = pool[rng.nextInt(pool.length)];
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────
  // INTERACTIONS
  // ─────────────────────────────────────────────────────

  Future<void> feedPet(double amount) async {
    if (_pet == null) return;
    PetEngine.feed(_pet!, amount);
    AudioService.playEat();
    await _save();
    notifyListeners();
  }

  Future<void> playWithPet() async {
    if (_pet == null) return;
    PetEngine.play(_pet!);
    AudioService.playHappy();
    await _save();
    notifyListeners();
  }

  Future<void> sleepPet() async {
    if (_pet == null) return;
    if (_pet!.isSleeping) {
      PetEngine.wake(_pet!);
    } else {
      PetEngine.sleep(_pet!);
      AudioService.playSleep();
    }
    await _save();
    notifyListeners();
  }

  Future<void> healPet(double amount) async {
    if (_pet == null) return;
    PetEngine.heal(_pet!, amount);
    await _save();
    notifyListeners();
  }

  Future<void> patPet() async {
    if (_pet == null) return;
    PetEngine.pat(_pet!);
    AudioService.playTap();
    await _save();
    notifyListeners();
  }

  /// Returns true if pet was scared.
  Future<bool> shakePet() async {
    if (_pet == null) return false;
    final scared = PetEngine.shakeReaction(_pet!);
    await _save();
    notifyListeners();
    return scared;
  }

  // ─────────────────────────────────────────────────────
  // ECONOMY
  // ─────────────────────────────────────────────────────

  void addCoins(int amount) {
    if (_pet == null) return;
    _pet!.coins += amount;
    _save();
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_pet == null) return false;
    if (_pet!.coins < amount) return false;
    _pet!.coins -= amount;
    _save();
    notifyListeners();
    return true;
  }

  // ─────────────────────────────────────────────────────
  // COSTUMES
  // ─────────────────────────────────────────────────────

  void setCostume(String? costumeId) {
    if (_pet == null) return;
    _pet!.costumeId = costumeId;
    _save();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────
  // Use item from shop (food / toy / medicine)
  // ─────────────────────────────────────────────────────
  Future<void> useShopItem(ShopItemModel item) async {
    if (_pet == null) return;
    switch (item.type.name) {
      case 'food':
        await feedPet(item.effectValue);
        if (item.secondaryEffect > 0) {
          _pet!.happiness = (_pet!.happiness + item.secondaryEffect).clamp(0, 100);
        }
        break;
      case 'toy':
        _pet!.happiness = (_pet!.happiness + item.effectValue).clamp(0, 100);
        _pet!.playCount++;
        break;
      case 'medicine':
        await healPet(item.effectValue);
        break;
      default:
        break;
    }
    await _save();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────
  // PERSISTENCE
  // ─────────────────────────────────────────────────────

  Future<void> _save() async {
    if (_pet != null) {
      await StorageService.savePet(_pet!);
    }
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }
}

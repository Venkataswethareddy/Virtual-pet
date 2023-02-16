import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet_model.dart';
import '../models/room_model.dart';
import '../models/inventory_model.dart';
import '../models/game_score_model.dart';

/// Hive-backed local storage for all persistent data.
class StorageService {
  static const String _petBoxName = 'pet_box';
  static const String _roomBoxName = 'room_box';
  static const String _inventoryBoxName = 'inventory_box';
  static const String _scoresBoxName = 'scores_box';
  static const String _settingsBoxName = 'settings_box';

  static late Box _petBox;
  static late Box _roomBox;
  static late Box _inventoryBox;
  static late Box _scoresBox;
  static late Box _settingsBox;

  /// Initialise Hive and open all boxes. Call once at app startup.
  static Future<void> init() async {
    await Hive.initFlutter();
    _petBox = await Hive.openBox(_petBoxName);
    _roomBox = await Hive.openBox(_roomBoxName);
    _inventoryBox = await Hive.openBox(_inventoryBoxName);
    _scoresBox = await Hive.openBox(_scoresBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // ── Pet ──────────────────────────────────────────────

  static Future<void> savePet(PetModel pet) async {
    await _petBox.put('pet', pet.toMap());
  }

  static PetModel? loadPet() {
    final data = _petBox.get('pet');
    if (data == null) return null;
    return PetModel.fromMap(Map<dynamic, dynamic>.from(data));
  }

  static Future<void> deletePet() async {
    await _petBox.delete('pet');
  }

  static bool hasPet() => _petBox.containsKey('pet');

  // ── Room ─────────────────────────────────────────────

  static Future<void> saveRoom(RoomModel room) async {
    await _roomBox.put('room', room.toMap());
  }

  static RoomModel loadRoom() {
    final data = _roomBox.get('room');
    if (data == null) return RoomModel();
    return RoomModel.fromMap(Map<dynamic, dynamic>.from(data));
  }

  // ── Inventory ────────────────────────────────────────

  static Future<void> saveInventory(InventoryModel inv) async {
    await _inventoryBox.put('inventory', inv.toMap());
  }

  static InventoryModel loadInventory() {
    final data = _inventoryBox.get('inventory');
    if (data == null) return InventoryModel();
    return InventoryModel.fromMap(Map<dynamic, dynamic>.from(data));
  }

  // ── Game scores ──────────────────────────────────────

  static Future<void> saveScore(GameScoreModel score) async {
    await _scoresBox.put(score.gameId, score.toMap());
  }

  static GameScoreModel loadScore(String gameId) {
    final data = _scoresBox.get(gameId);
    if (data == null) return GameScoreModel(gameId: gameId);
    return GameScoreModel.fromMap(Map<dynamic, dynamic>.from(data));
  }

  // ── Settings ─────────────────────────────────────────

  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static T? getSetting<T>(String key) => _settingsBox.get(key) as T?;

  // ── Nuke everything ──────────────────────────────────

  static Future<void> clearAll() async {
    await _petBox.clear();
    await _roomBox.clear();
    await _inventoryBox.clear();
    await _scoresBox.clear();
    await _settingsBox.clear();
  }
}

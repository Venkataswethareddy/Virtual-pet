import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../services/storage_service.dart';

/// Manages room decorations and themes.
class RoomProvider extends ChangeNotifier {
  RoomModel _room = RoomModel();

  RoomModel get room => _room;
  List<PlacedDecoration> get decorations => _room.decorations;
  String get currentTheme => _room.currentTheme;

  Future<void> loadRoom() async {
    _room = StorageService.loadRoom();
    notifyListeners();
  }

  Future<void> addDecoration(String itemId) async {
    _room.decorations.add(PlacedDecoration(itemId: itemId));
    await _save();
    notifyListeners();
  }

  Future<void> moveDecoration(int index, double dx, double dy) async {
    if (index >= 0 && index < _room.decorations.length) {
      _room.decorations[index].dx = dx;
      _room.decorations[index].dy = dy;
      await _save();
      notifyListeners();
    }
  }

  Future<void> removeDecoration(int index) async {
    if (index >= 0 && index < _room.decorations.length) {
      _room.decorations.removeAt(index);
      await _save();
      notifyListeners();
    }
  }

  Future<void> setTheme(String themeId) async {
    _room.currentTheme = themeId;
    if (!_room.unlockedThemes.contains(themeId)) {
      _room.unlockedThemes.add(themeId);
    }
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await StorageService.saveRoom(_room);
  }
}

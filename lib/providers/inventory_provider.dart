import 'package:flutter/material.dart';
import '../models/inventory_model.dart';
import '../models/shop_item_model.dart';
import '../services/storage_service.dart';

/// Manages the player's inventory of purchased items.
class InventoryProvider extends ChangeNotifier {
  InventoryModel _inventory = InventoryModel();

  InventoryModel get inventory => _inventory;
  Map<String, int> get items => _inventory.items;

  Future<void> loadInventory() async {
    _inventory = StorageService.loadInventory();
    notifyListeners();
  }

  Future<void> addItem(String itemId, [int qty = 1]) async {
    _inventory.addItem(itemId, qty);
    await _save();
    notifyListeners();
  }

  bool hasItem(String itemId) => _inventory.hasItem(itemId);

  Future<bool> useItem(String itemId) async {
    final success = _inventory.useItem(itemId);
    if (success) {
      await _save();
      notifyListeners();
    }
    return success;
  }

  int quantityOf(String itemId) => _inventory.quantityOf(itemId);

  /// Get all items in inventory grouped by type.
  List<MapEntry<ShopItemModel, int>> get itemsWithDetails {
    final result = <MapEntry<ShopItemModel, int>>[];
    for (final entry in _inventory.items.entries) {
      final item = ShopItemModel.findById(entry.key);
      if (item != null) {
        result.add(MapEntry(item, entry.value));
      }
    }
    return result;
  }

  Future<void> _save() async {
    await StorageService.saveInventory(_inventory);
  }
}

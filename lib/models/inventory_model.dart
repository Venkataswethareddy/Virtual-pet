/// Player inventory — maps item IDs to quantities owned.
class InventoryModel {
  /// { itemId : quantity }
  Map<String, int> items;

  InventoryModel({Map<String, int>? items}) : items = items ?? {};

  void addItem(String itemId, [int qty = 1]) {
    items[itemId] = (items[itemId] ?? 0) + qty;
  }

  bool hasItem(String itemId) => (items[itemId] ?? 0) > 0;

  /// Consume one unit, returns false if none left.
  bool useItem(String itemId) {
    if (!hasItem(itemId)) return false;
    items[itemId] = items[itemId]! - 1;
    if (items[itemId]! <= 0) items.remove(itemId);
    return true;
  }

  int quantityOf(String itemId) => items[itemId] ?? 0;

  Map<String, dynamic> toMap() => {'items': items};

  factory InventoryModel.fromMap(Map<dynamic, dynamic> map) {
    final raw = map['items'] as Map<dynamic, dynamic>? ?? {};
    return InventoryModel(
      items: raw.map((k, v) => MapEntry(k.toString(), v as int)),
    );
  }
}

import '../core/enums/item_type.dart';

/// An item available in the shop.
class ShopItemModel {
  final String id;
  final String name;
  final String emoji;
  final ItemType type;
  final int price;

  /// Effect values – meaning depends on [type]:
  /// food → hunger boost, toy → happiness boost, medicine → health boost
  /// costume / decoration → 0 (cosmetic only)
  final double effectValue;

  /// Optional secondary effect (e.g. cake gives +happiness too).
  final double secondaryEffect;

  const ShopItemModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.type,
    required this.price,
    this.effectValue = 0,
    this.secondaryEffect = 0,
  });

  /// Pre-defined shop catalog.
  static List<ShopItemModel> get catalog => const [
        // ── Food ─────────────────────────────────────────
        ShopItemModel(
          id: 'apple',
          name: 'Apple',
          emoji: '🍎',
          type: ItemType.food,
          price: 10,
          effectValue: 10,
        ),
        ShopItemModel(
          id: 'steak',
          name: 'Steak',
          emoji: '🥩',
          type: ItemType.food,
          price: 25,
          effectValue: 25,
        ),
        ShopItemModel(
          id: 'cake',
          name: 'Cake',
          emoji: '🎂',
          type: ItemType.food,
          price: 50,
          effectValue: 40,
          secondaryEffect: 10, // +10 happiness
        ),

        // ── Toys ─────────────────────────────────────────
        ShopItemModel(
          id: 'ball',
          name: 'Ball',
          emoji: '⚽',
          type: ItemType.toy,
          price: 30,
          effectValue: 15,
        ),
        ShopItemModel(
          id: 'teddy',
          name: 'Teddy',
          emoji: '🧸',
          type: ItemType.toy,
          price: 60,
          effectValue: 30,
        ),

        // ── Medicine ─────────────────────────────────────
        ShopItemModel(
          id: 'bandage',
          name: 'Bandage',
          emoji: '🩹',
          type: ItemType.medicine,
          price: 20,
          effectValue: 20,
        ),
        ShopItemModel(
          id: 'potion',
          name: 'Potion',
          emoji: '🧪',
          type: ItemType.medicine,
          price: 50,
          effectValue: 50,
        ),

        // ── Costumes ─────────────────────────────────────
        ShopItemModel(
          id: 'hat',
          name: 'Hat',
          emoji: '🎩',
          type: ItemType.costume,
          price: 100,
        ),
        ShopItemModel(
          id: 'bowtie',
          name: 'Bow Tie',
          emoji: '🎀',
          type: ItemType.costume,
          price: 150,
        ),
        ShopItemModel(
          id: 'crown',
          name: 'Crown',
          emoji: '👑',
          type: ItemType.costume,
          price: 500,
        ),

        // ── Decorations ──────────────────────────────────
        ShopItemModel(
          id: 'plant',
          name: 'Plant',
          emoji: '🪴',
          type: ItemType.decoration,
          price: 80,
        ),
        ShopItemModel(
          id: 'lamp',
          name: 'Lamp',
          emoji: '💡',
          type: ItemType.decoration,
          price: 120,
        ),
        ShopItemModel(
          id: 'poster',
          name: 'Poster',
          emoji: '🖼️',
          type: ItemType.decoration,
          price: 90,
        ),
      ];

  /// Find an item by id from the catalog.
  static ShopItemModel? findById(String id) {
    try {
      return catalog.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}

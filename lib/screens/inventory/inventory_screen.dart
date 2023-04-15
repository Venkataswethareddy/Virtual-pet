import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/enums/item_type.dart';
import '../../models/shop_item_model.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/room_provider.dart';

/// Inventory screen — use or equip items the player owns.
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inv = context.watch<InventoryProvider>();
    final items = inv.itemsWithDetails;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Nothing here yet.\nBuy items from the Shop!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i].key;
                final qty = items[i].value;
                return _InventoryTile(item: item, quantity: qty);
              },
            ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  final ShopItemModel item;
  final int quantity;

  const _InventoryTile({required this.item, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text('×$quantity',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _useItem(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(_buttonLabel),
          ),
        ],
      ),
    );
  }

  String get _buttonLabel {
    switch (item.type) {
      case ItemType.food:
      case ItemType.toy:
      case ItemType.medicine:
        return 'Use';
      case ItemType.costume:
        return 'Equip';
      case ItemType.decoration:
        return 'Place';
    }
  }

  void _useItem(BuildContext context) {
    final inv = context.read<InventoryProvider>();
    final pet = context.read<PetProvider>();
    final room = context.read<RoomProvider>();

    switch (item.type) {
      case ItemType.food:
      case ItemType.toy:
      case ItemType.medicine:
        inv.useItem(item.id).then((used) {
          if (used) pet.useShopItem(item);
        });
        break;
      case ItemType.costume:
        pet.setCostume(item.id);
        break;
      case ItemType.decoration:
        inv.useItem(item.id).then((used) {
          if (used) room.addDecoration(item.id);
        });
        break;
    }
  }
}

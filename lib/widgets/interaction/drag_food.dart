import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/shop_item_model.dart';

/// Draggable food item that can be dropped onto the pet.
class DragFood extends StatelessWidget {
  final ShopItemModel item;
  final VoidCallback? onFed;

  const DragFood({super.key, required this.item, this.onFed});

  @override
  Widget build(BuildContext context) {
    return Draggable<ShopItemModel>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Text(
          item.emoji,
          style: const TextStyle(fontSize: 48),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildChip(),
      ),
      child: _buildChip(),
    );
  }

  Widget _buildChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 6),
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

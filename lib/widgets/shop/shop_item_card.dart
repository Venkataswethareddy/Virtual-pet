import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/shop_item_model.dart';

/// Card widget for displaying a shop item with buy button.
class ShopItemCard extends StatelessWidget {
  final ShopItemModel item;
  final int owned;
  final bool canAfford;
  final VoidCallback? onBuy;

  const ShopItemCard({
    super.key,
    required this.item,
    this.owned = 0,
    this.canAfford = true,
    this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 6),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (item.effectValue > 0) ...[
              const SizedBox(height: 2),
              Text(
                '+${item.effectValue.toInt()} ${item.type.name}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (owned > 0)
              Text(
                'Owned: $owned',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: canAfford ? onBuy : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  gradient: canAfford ? AppColors.goldGradient : null,
                  color: canAfford ? null : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${item.price}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: canAfford ? Colors.brown.shade900 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

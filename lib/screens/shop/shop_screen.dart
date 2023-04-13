import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/enums/item_type.dart';
import '../../models/shop_item_model.dart';
import '../../providers/pet_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../services/haptic_service.dart';
import '../../widgets/shop/shop_item_card.dart';
import '../../widgets/common/coin_display.dart';

/// Shop screen with tabbed categories.
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ItemType> _tabs = [
    ItemType.food,
    ItemType.toy,
    ItemType.medicine,
    ItemType.costume,
    ItemType.decoration,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _buyItem(ShopItemModel item) {
    final petProvider = context.read<PetProvider>();
    final invProvider = context.read<InventoryProvider>();
    final success = petProvider.spendCoins(item.price);
    if (success) {
      invProvider.addItem(item.id);
      HapticService.lightTap();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.emoji} ${AppStrings.purchased}'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.notEnoughCoins),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetProvider>().pet;
    final inv = context.watch<InventoryProvider>();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                const Text(
                  AppStrings.shopTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                CoinDisplay(coins: pet?.coins ?? 0),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            tabs: const [
              Tab(text: '🍎 Food'),
              Tab(text: '⚽ Toys'),
              Tab(text: '🩹 Med'),
              Tab(text: '🎩 Style'),
              Tab(text: '🪴 Decor'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((type) {
                final items = ShopItemModel.catalog
                    .where((i) => i.type == type)
                    .toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return ShopItemCard(
                      item: item,
                      owned: inv.quantityOf(item.id),
                      canAfford: (pet?.coins ?? 0) >= item.price,
                      onBuy: () => _buyItem(item),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/shop_item_model.dart';
import '../../providers/room_provider.dart';

/// Room editor — drag decorations to reposition them.
class RoomEditorScreen extends StatelessWidget {
  const RoomEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final room = context.watch<RoomProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bgTop,
                      AppColors.bgBottom,
                    ],
                  ),
                ),
              ),
              // Decorations
              ...List.generate(room.decorations.length, (i) {
                final deco = room.decorations[i];
                final item = ShopItemModel.findById(deco.itemId);
                if (item == null) return const SizedBox.shrink();

                return Positioned(
                  left: deco.dx * constraints.maxWidth - 25,
                  top: deco.dy * constraints.maxHeight - 25,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final newDx = (deco.dx +
                              details.delta.dx / constraints.maxWidth)
                          .clamp(0.05, 0.95);
                      final newDy = (deco.dy +
                              details.delta.dy / constraints.maxHeight)
                          .clamp(0.05, 0.95);
                      room.moveDecoration(i, newDx, newDy);
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Remove?'),
                          content: Text('Remove ${item.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                room.removeDecoration(i);
                                Navigator.pop(context);
                              },
                              child: const Text('Remove',
                                  style: TextStyle(color: AppColors.danger)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.emoji, style: const TextStyle(fontSize: 40)),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // Empty hint
              if (room.decorations.isEmpty)
                const Center(
                  child: Text(
                    'No decorations yet.\nBuy some from the Shop!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

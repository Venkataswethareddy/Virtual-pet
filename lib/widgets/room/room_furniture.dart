import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import '../../models/shop_item_model.dart';

/// Renders placed decorations in the room at their (dx, dy) positions.
class RoomFurniture extends StatelessWidget {
  final List<PlacedDecoration> decorations;

  const RoomFurniture({super.key, required this.decorations});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: decorations.map((deco) {
            final item = ShopItemModel.findById(deco.itemId);
            if (item == null) return const SizedBox.shrink();
            return Positioned(
              left: deco.dx * constraints.maxWidth - 20,
              top: deco.dy * constraints.maxHeight - 20,
              child: Text(
                item.emoji,
                style: const TextStyle(fontSize: 36),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

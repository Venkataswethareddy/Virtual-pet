import 'package:flutter/material.dart';

/// Overlays a cosmetic costume on the pet. Uses emoji/text-based visuals.
class PetCostume extends StatelessWidget {
  final String costumeId;
  final double size;

  const PetCostume({super.key, required this.costumeId, required this.size});

  @override
  Widget build(BuildContext context) {
    switch (costumeId) {
      case 'hat':
        return Positioned(
          top: size * 0.02,
          child: Text('🎩', style: TextStyle(fontSize: size * 0.22)),
        );
      case 'bowtie':
        return Positioned(
          bottom: size * 0.25,
          child: Text('🎀', style: TextStyle(fontSize: size * 0.16)),
        );
      case 'crown':
        return Positioned(
          top: size * 0.0,
          child: Text('👑', style: TextStyle(fontSize: size * 0.22)),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

import 'package:flutter/material.dart';
import '../../providers/pet_provider.dart';
import '../../services/haptic_service.dart';
import '../common/particle_effect.dart';
import 'package:provider/provider.dart';

/// Wraps the pet widget with tap-to-pat detection and heart particle effects.
class PetTouch extends StatefulWidget {
  final Widget child;

  const PetTouch({super.key, required this.child});

  @override
  State<PetTouch> createState() => _PetTouchState();
}

class _PetTouchState extends State<PetTouch> {
  final List<Offset> _heartPositions = [];

  void _onTap(TapDownDetails details) {
    final petProvider = context.read<PetProvider>();
    petProvider.patPet();
    HapticService.lightTap();
    setState(() {
      _heartPositions.add(details.localPosition);
    });
    // Remove after animation
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          if (_heartPositions.isNotEmpty) _heartPositions.removeAt(0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          ..._heartPositions.map(
            (pos) => Positioned(
              left: pos.dx - 15,
              top: pos.dy - 15,
              child: const ParticleEffect(
                emoji: '❤️',
                count: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

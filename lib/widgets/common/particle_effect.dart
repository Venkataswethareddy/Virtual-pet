import 'dart:math';
import 'package:flutter/material.dart';

/// Bursts emoji particles upward with fade-out and scale animation.
/// Used for hearts on pat, sparkles on feed, etc.
class ParticleEffect extends StatefulWidget {
  final String emoji;
  final int count;

  const ParticleEffect({super.key, this.emoji = '❤️', this.count = 5});

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _particles = List.generate(widget.count, (_) {
      return _Particle(
        dx: (_rng.nextDouble() - 0.5) * 60,
        dy: -_rng.nextDouble() * 80 - 20,
        rotation: _rng.nextDouble() * pi,
        scale: 0.5 + _rng.nextDouble() * 0.8,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ParticleAnimWidget(
      animation: _controller,
      builder: (_, __) {
        return SizedBox(
          width: 80,
          height: 100,
          child: Stack(
            clipBehavior: Clip.none,
            children: _particles.map((p) {
              final t = _controller.value;
              return Positioned(
                left: 40 + p.dx * t,
                top: 50 + p.dy * t,
                child: Opacity(
                  opacity: (1.0 - t).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: p.scale * (1.0 - t * 0.5),
                    child: Transform.rotate(
                      angle: p.rotation * t,
                      child: Text(
                        widget.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _ParticleAnimWidget extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const _ParticleAnimWidget({
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => builder(context, child);
}

class _Particle {
  final double dx;
  final double dy;
  final double rotation;
  final double scale;

  _Particle({
    required this.dx,
    required this.dy,
    required this.rotation,
    required this.scale,
  });
}

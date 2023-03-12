import 'package:flutter/material.dart';

/// Purely decorative sky widget with animated clouds.
class SkyWidget extends StatefulWidget {
  const SkyWidget({super.key});

  @override
  State<SkyWidget> createState() => _SkyWidgetState();
}

class _SkyWidgetState extends State<SkyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _CloudPainter(_controller.value),
        );
      },
    );
  }
}

/// Re-usable AnimatedBuilder using AnimatedWidget pattern.
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => builder(context, child);
}

class _CloudPainter extends CustomPainter {
  final double progress; // 0 → 1

  _CloudPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.15);
    // Cloud 1 — moves right
    final x1 = (progress * size.width * 1.5) % (size.width + 100) - 50;
    _drawCloud(canvas, Offset(x1, size.height * 0.08), 40, paint);

    // Cloud 2 — moves slower
    final x2 = (progress * size.width * 0.8 + size.width * 0.3) % (size.width + 100) - 50;
    _drawCloud(canvas, Offset(x2, size.height * 0.18), 30, paint);
  }

  void _drawCloud(Canvas canvas, Offset center, double r, Paint paint) {
    canvas.drawCircle(center, r, paint);
    canvas.drawCircle(Offset(center.dx - r * 0.7, center.dy + r * 0.1), r * 0.7, paint);
    canvas.drawCircle(Offset(center.dx + r * 0.7, center.dy + r * 0.1), r * 0.7, paint);
    canvas.drawCircle(Offset(center.dx - r * 0.3, center.dy - r * 0.4), r * 0.6, paint);
    canvas.drawCircle(Offset(center.dx + r * 0.3, center.dy - r * 0.3), r * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant _CloudPainter old) => old.progress != progress;
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/time_helper.dart';

/// Animated room background that changes with real-world time of day.
/// Sunrise → Day → Sunset → Night with gradient transitions, stars, and moon.
class RoomBackground extends StatelessWidget {
  const RoomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final tod = TimeHelper.timeOfDay();
    final List<Color> colors;
    switch (tod) {
      case 'sunrise':
        colors = [AppColors.sunriseTop, AppColors.sunriseBottom];
        break;
      case 'day':
        colors = [AppColors.dayTop, AppColors.dayBottom];
        break;
      case 'sunset':
        colors = [AppColors.sunsetTop, AppColors.sunsetBottom];
        break;
      default:
        colors = [AppColors.nightTop, AppColors.nightBottom];
    }

    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          if (tod == 'night') const _Stars(),
          if (tod == 'night') const _Moon(),
          if (tod == 'sunrise' || tod == 'sunset') const _Sun(),
          // Floor
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.brown.shade800.withOpacity(0.6),
                    Colors.brown.shade900.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _StarPainter(),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    // Deterministic star positions
    final positions = [
      Offset(size.width * 0.1, size.height * 0.05),
      Offset(size.width * 0.25, size.height * 0.12),
      Offset(size.width * 0.45, size.height * 0.03),
      Offset(size.width * 0.6, size.height * 0.15),
      Offset(size.width * 0.8, size.height * 0.08),
      Offset(size.width * 0.15, size.height * 0.22),
      Offset(size.width * 0.35, size.height * 0.18),
      Offset(size.width * 0.7, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.2),
      Offset(size.width * 0.55, size.height * 0.28),
      Offset(size.width * 0.05, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.32),
    ];
    final sizes = [1.5, 1.0, 2.0, 1.0, 1.5, 0.8, 1.2, 1.8, 1.0, 0.7, 1.3, 1.5];
    for (int i = 0; i < positions.length; i++) {
      paint.color = Colors.white.withOpacity(i.isEven ? 0.9 : 0.6);
      canvas.drawCircle(positions[i], sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Moon extends StatelessWidget {
  const _Moon();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 40,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFF9C4),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFF9C4).withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class _Sun extends StatelessWidget {
  const _Sun();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right: 60,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFE082),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFAB00).withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 15,
            ),
          ],
        ),
      ),
    );
  }
}

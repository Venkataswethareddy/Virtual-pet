import 'dart:math';
import 'package:flutter/material.dart';

/// Static helper methods that draw various pet facial expressions on a Canvas.
/// Called by [_PetPainter] to render mood-specific eyes and mouths.
class PetExpressions {
  PetExpressions._();

  // ─────────────────────────────────────────────────────
  // EYES
  // ─────────────────────────────────────────────────────

  static void drawNormalEyes(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(Offset(cx - r * 1.2, cy), r, paint);
    canvas.drawCircle(Offset(cx + r * 1.2, cy), r, paint);

    // Sparkle highlight
    final sparkle = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - r * 1.2 + r * 0.3, cy - r * 0.3), r * 0.35, sparkle);
    canvas.drawCircle(Offset(cx + r * 1.2 + r * 0.3, cy - r * 0.3), r * 0.35, sparkle);
  }

  static void drawClosedEyes(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.4
      ..strokeCap = StrokeCap.round;
    // Simple arcs for closed eyes
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - r * 1.2, cy), width: r * 1.6, height: r),
      0, pi, false, paint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + r * 1.2, cy), width: r * 1.6, height: r),
      0, pi, false, paint,
    );
  }

  static void drawSadEyes(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(Offset(cx - r * 1.2, cy), r * 0.8, paint);
    canvas.drawCircle(Offset(cx + r * 1.2, cy), r * 0.8, paint);

    // Droopy eyebrows
    final browPaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.25
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - r * 1.8, cy - r * 0.8),
      Offset(cx - r * 0.6, cy - r * 1.1),
      browPaint,
    );
    canvas.drawLine(
      Offset(cx + r * 0.6, cy - r * 1.1),
      Offset(cx + r * 1.8, cy - r * 0.8),
      browPaint,
    );

    // Tear drop
    final tearPaint = Paint()..color = const Color(0xFF4FC3F7);
    canvas.drawCircle(Offset(cx - r * 1.2, cy + r * 1.2), r * 0.25, tearPaint);
  }

  static void drawSickEyes(Canvas canvas, double cx, double cy, double r) {
    // Spiral/dizzy eyes
    final paint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.2;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - r * 1.2, cy), width: r * 1.2, height: r * 1.2),
      0, pi * 1.5, false, paint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + r * 1.2, cy), width: r * 1.2, height: r * 1.2),
      0, pi * 1.5, false, paint,
    );
  }

  static void drawScaredEyes(Canvas canvas, double cx, double cy, double r) {
    // Big wide eyes
    final white = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - r * 1.2, cy), r * 1.1, white);
    canvas.drawCircle(Offset(cx + r * 1.2, cy), r * 1.1, white);
    final pupil = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(Offset(cx - r * 1.2, cy + r * 0.15), r * 0.5, pupil);
    canvas.drawCircle(Offset(cx + r * 1.2, cy + r * 0.15), r * 0.5, pupil);
  }

  static void drawStarEyes(Canvas canvas, double cx, double cy, double r) {
    // Star-shaped eyes for excitement
    final paint = Paint()..color = const Color(0xFFFFD700);
    _drawStar(canvas, Offset(cx - r * 1.2, cy), r, paint);
    _drawStar(canvas, Offset(cx + r * 1.2, cy), r, paint);
  }

  static void drawXEyes(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.3
      ..strokeCap = StrokeCap.round;
    // Left X
    canvas.drawLine(
      Offset(cx - r * 1.8, cy - r * 0.5),
      Offset(cx - r * 0.6, cy + r * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(cx - r * 0.6, cy - r * 0.5),
      Offset(cx - r * 1.8, cy + r * 0.5),
      paint,
    );
    // Right X
    canvas.drawLine(
      Offset(cx + r * 0.6, cy - r * 0.5),
      Offset(cx + r * 1.8, cy + r * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(cx + r * 1.8, cy - r * 0.5),
      Offset(cx + r * 0.6, cy + r * 0.5),
      paint,
    );
  }

  // ─────────────────────────────────────────────────────
  // MOUTHS
  // ─────────────────────────────────────────────────────

  static void drawSmile(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.5, height: r),
      0.1, pi - 0.2, false, paint,
    );
  }

  static void drawBigSmile(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = const Color(0xFF212121);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.8, height: r * 1.2),
      0, pi, true, paint,
    );
    // Tongue
    final tongue = Paint()..color = const Color(0xFFEF5350);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.4), width: r * 0.5, height: r * 0.3),
      tongue,
    );
  }

  static void drawSadMouth(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.5), width: r * 1.2, height: r),
      pi + 0.3, pi - 0.6, false, paint,
    );
  }

  static void drawOpenMouth(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = const Color(0xFF212121);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.0, height: r * 0.8),
      paint,
    );
  }

  static void drawSickMouth(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.15;
    // Wavy line for sick expression
    final path = Path()..moveTo(cx - r * 0.6, cy);
    for (int i = 0; i < 4; i++) {
      path.quadraticBezierTo(
        cx - r * 0.6 + (i + 0.5) * r * 0.3, cy + (i.isEven ? -r * 0.2 : r * 0.2),
        cx - r * 0.6 + (i + 1) * r * 0.3, cy,
      );
    }
    canvas.drawPath(path, paint);
  }

  // ─────────────────────────────────────────────────────
  // ZZZ for sleeping
  // ─────────────────────────────────────────────────────

  static void drawSleepZzz(Canvas canvas, double x, double y, double size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Z z z',
        style: TextStyle(
          color: const Color(0xFF90CAF9),
          fontSize: size * 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x, y));
  }

  // ─────────────────────────────────────────────────────
  // STAR HELPER
  // ─────────────────────────────────────────────────────

  static void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * pi / 5) - pi / 2;
      final point = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}

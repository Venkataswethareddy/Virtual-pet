import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/enums/pet_stage.dart';
import '../../core/enums/pet_type.dart';
import '../../core/enums/pet_mood.dart';
import 'pet_expressions.dart';
import 'pet_costume.dart';

/// Draws the pet character entirely with [CustomPainter]. No external image assets.
/// The look changes based on stage, type, and mood.
class PetCharacter extends StatefulWidget {
  final PetStage stage;
  final PetType petType;
  final PetMood mood;
  final String? costumeId;
  final double tiltX;
  final double size;

  const PetCharacter({
    super.key,
    required this.stage,
    required this.petType,
    required this.mood,
    this.costumeId,
    this.tiltX = 0.0,
    this.size = 200,
  });

  @override
  State<PetCharacter> createState() => _PetCharacterState();
}

class _PetCharacterState extends State<PetCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _breathAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BreathAnimWidget(
      animation: _breathAnim,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(widget.tiltX * 15, 0),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _PetPainter(
                    stage: widget.stage,
                    petType: widget.petType,
                    mood: widget.mood,
                    breathPhase: _breathAnim.value,
                  ),
                ),
                if (widget.costumeId != null)
                  PetCostume(
                    costumeId: widget.costumeId!,
                    size: widget.size,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Reusable animated widget that rebuilds on animation tick.
class _BreathAnimWidget extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const _BreathAnimWidget({
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => builder(context, child);
}

/// Custom painter that draws the pet character.
class _PetPainter extends CustomPainter {
  final PetStage stage;
  final PetType petType;
  final PetMood mood;
  final double breathPhase; // 0-1, used for breathing animation

  _PetPainter({
    required this.stage,
    required this.petType,
    required this.mood,
    required this.breathPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (stage) {
      case PetStage.egg:
        _drawEgg(canvas, size);
        break;
      case PetStage.ghostForm:
        _drawGhost(canvas, size);
        break;
      case PetStage.sadForm:
        _drawSadForm(canvas, size);
        break;
      default:
        _drawPet(canvas, size);
    }
  }

  void _drawEgg(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.3;

    // Egg body
    final eggPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFF3E0), const Color(0xFFFFCC80)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.6, height: r * 2.0),
      eggPaint,
    );

    // Zigzag crack
    final crackPaint = Paint()
      ..color = const Color(0xFFBCAAA4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final path = Path()
      ..moveTo(cx - r * 0.4, cy - r * 0.1)
      ..lineTo(cx - r * 0.1, cy - r * 0.3)
      ..lineTo(cx + r * 0.15, cy)
      ..lineTo(cx + r * 0.4, cy - r * 0.15);
    canvas.drawPath(path, crackPaint);

    // Blush spots on egg
    final blush = Paint()..color = const Color(0x40FF8A80);
    canvas.drawCircle(Offset(cx - r * 0.35, cy + r * 0.4), r * 0.15, blush);
    canvas.drawCircle(Offset(cx + r * 0.35, cy + r * 0.4), r * 0.15, blush);
  }

  void _drawGhost(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.3;

    // Translucent ghost body
    final ghostPaint = Paint()
      ..color = const Color(0x60B0BEC5)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - r * 0.2), width: r * 1.8, height: r * 2.2),
      ghostPaint,
    );

    // Wavy bottom
    final wavePath = Path();
    wavePath.moveTo(cx - r * 0.9, cy + r * 0.8);
    for (int i = 0; i < 5; i++) {
      final x = cx - r * 0.9 + (i * r * 0.45);
      wavePath.quadraticBezierTo(
        x + r * 0.12, cy + r * (i.isEven ? 1.1 : 0.9),
        x + r * 0.22, cy + r * 0.8,
      );
    }
    canvas.drawPath(wavePath, ghostPaint);

    // X eyes
    PetExpressions.drawXEyes(canvas, cx, cy - r * 0.3, r * 0.15);
  }

  void _drawSadForm(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.3;

    // Grey-ish body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFF90A4AE), const Color(0xFF607D8B)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.8, height: r * 2.0),
      bodyPaint,
    );

    // Sad eyes (drooping)
    PetExpressions.drawSadEyes(canvas, cx, cy - r * 0.2, r * 0.15);
    PetExpressions.drawSadMouth(canvas, cx, cy + r * 0.3, r * 0.2);
  }

  void _drawPet(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.3;

    // Breathing scale — body gets slightly bigger
    final breathScale = 1.0 + breathPhase * 0.03;

    // ── Body colour based on pet type ──────────────────
    final List<Color> bodyColors;
    switch (petType) {
      case PetType.cat:
        bodyColors = [const Color(0xFFFFB74D), const Color(0xFFF57C00)];
        break;
      case PetType.dog:
        bodyColors = [const Color(0xFF8D6E63), const Color(0xFF5D4037)];
        break;
      case PetType.bunny:
        bodyColors = [const Color(0xFFCE93D8), const Color(0xFF9C27B0)];
        break;
      default:
        bodyColors = [const Color(0xFF81D4FA), const Color(0xFF29B6F6)];
    }

    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: bodyColors,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));

    // ── Ears (type-specific) ────────────────────────────
    _drawEars(canvas, cx, cy, r, bodyPaint);

    // ── Body ────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: r * 1.8 * breathScale,
        height: r * 2.0 * breathScale,
      ),
      bodyPaint,
    );

    // ── Belly (lighter) ─────────────────────────────────
    final bellyPaint = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy + r * 0.25),
        width: r * 1.0,
        height: r * 1.2,
      ),
      bellyPaint,
    );

    // ── Face ────────────────────────────────────────────
    _drawFace(canvas, cx, cy, r);

    // ── Feet ────────────────────────────────────────────
    _drawFeet(canvas, cx, cy, r, bodyPaint);

    // ── Tail (type-specific) ────────────────────────────
    _drawTail(canvas, cx, cy, r, bodyPaint);
  }

  void _drawEars(Canvas canvas, double cx, double cy, double r, Paint paint) {
    switch (petType) {
      case PetType.cat:
        // Pointy triangle ears
        final ear1 = Path()
          ..moveTo(cx - r * 0.6, cy - r * 0.7)
          ..lineTo(cx - r * 0.3, cy - r * 1.3)
          ..lineTo(cx - r * 0.05, cy - r * 0.7)
          ..close();
        final ear2 = Path()
          ..moveTo(cx + r * 0.05, cy - r * 0.7)
          ..lineTo(cx + r * 0.3, cy - r * 1.3)
          ..lineTo(cx + r * 0.6, cy - r * 0.7)
          ..close();
        canvas.drawPath(ear1, paint);
        canvas.drawPath(ear2, paint);
        // Inner ear
        final innerPaint = Paint()..color = const Color(0xFFFFCDD2);
        final inner1 = Path()
          ..moveTo(cx - r * 0.5, cy - r * 0.75)
          ..lineTo(cx - r * 0.3, cy - r * 1.15)
          ..lineTo(cx - r * 0.1, cy - r * 0.75)
          ..close();
        canvas.drawPath(inner1, innerPaint);
        break;
      case PetType.dog:
        // Floppy round ears
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx - r * 0.6, cy - r * 0.5), width: r * 0.5, height: r * 0.8),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx + r * 0.6, cy - r * 0.5), width: r * 0.5, height: r * 0.8),
          paint,
        );
        break;
      case PetType.bunny:
        // Long bunny ears
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx - r * 0.3, cy - r * 1.3), width: r * 0.3, height: r * 1.0),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx + r * 0.3, cy - r * 1.3), width: r * 0.3, height: r * 1.0),
          paint,
        );
        final innerPaint = Paint()..color = const Color(0xFFFFCDD2);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx - r * 0.3, cy - r * 1.3), width: r * 0.15, height: r * 0.7),
          innerPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx + r * 0.3, cy - r * 1.3), width: r * 0.15, height: r * 0.7),
          innerPaint,
        );
        break;
      default:
        // Undecided — small round bumps
        canvas.drawCircle(Offset(cx - r * 0.4, cy - r * 0.85), r * 0.2, paint);
        canvas.drawCircle(Offset(cx + r * 0.4, cy - r * 0.85), r * 0.2, paint);
    }
  }

  void _drawFace(Canvas canvas, double cx, double cy, double r) {
    switch (mood) {
      case PetMood.sleeping:
        PetExpressions.drawClosedEyes(canvas, cx, cy - r * 0.2, r * 0.12);
        PetExpressions.drawSleepZzz(canvas, cx + r * 0.5, cy - r * 0.5, r * 0.15);
        break;
      case PetMood.sick:
        PetExpressions.drawSickEyes(canvas, cx, cy - r * 0.2, r * 0.12);
        PetExpressions.drawSickMouth(canvas, cx, cy + r * 0.2, r * 0.15);
        break;
      case PetMood.hungry:
        PetExpressions.drawNormalEyes(canvas, cx, cy - r * 0.2, r * 0.12);
        PetExpressions.drawOpenMouth(canvas, cx, cy + r * 0.25, r * 0.12);
        break;
      case PetMood.sad:
        PetExpressions.drawSadEyes(canvas, cx, cy - r * 0.2, r * 0.12);
        PetExpressions.drawSadMouth(canvas, cx, cy + r * 0.25, r * 0.15);
        break;
      case PetMood.scared:
        PetExpressions.drawScaredEyes(canvas, cx, cy - r * 0.2, r * 0.15);
        PetExpressions.drawOpenMouth(canvas, cx, cy + r * 0.25, r * 0.12);
        break;
      case PetMood.excited:
        PetExpressions.drawStarEyes(canvas, cx, cy - r * 0.2, r * 0.15);
        PetExpressions.drawBigSmile(canvas, cx, cy + r * 0.25, r * 0.2);
        break;
      default: // happy
        PetExpressions.drawNormalEyes(canvas, cx, cy - r * 0.2, r * 0.12);
        PetExpressions.drawSmile(canvas, cx, cy + r * 0.25, r * 0.15);
    }

    // Blush (always)
    final blush = Paint()..color = const Color(0x30FF8A80);
    canvas.drawCircle(Offset(cx - r * 0.35, cy + r * 0.05), r * 0.12, blush);
    canvas.drawCircle(Offset(cx + r * 0.35, cy + r * 0.05), r * 0.12, blush);

    // Nose
    final nosePaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.05), width: r * 0.12, height: r * 0.08),
      nosePaint,
    );
  }

  void _drawFeet(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final footPaint = Paint()..color = paint.color ?? const Color(0xFF8D6E63);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - r * 0.35, cy + r * 0.9), width: r * 0.35, height: r * 0.2),
      footPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + r * 0.35, cy + r * 0.9), width: r * 0.35, height: r * 0.2),
      footPaint,
    );
  }

  void _drawTail(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final tailPaint = Paint()
      ..color = paint.color ?? const Color(0xFF8D6E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.12
      ..strokeCap = StrokeCap.round;

    switch (petType) {
      case PetType.cat:
        // Curvy cat tail
        final path = Path()
          ..moveTo(cx + r * 0.8, cy + r * 0.3)
          ..quadraticBezierTo(cx + r * 1.3, cy - r * 0.5, cx + r * 1.0, cy - r * 0.8);
        canvas.drawPath(path, tailPaint);
        break;
      case PetType.dog:
        // Wagging tail (uses breath phase for wag)
        final wagAngle = breathPhase * 0.5 - 0.25;
        final path = Path()
          ..moveTo(cx + r * 0.7, cy + r * 0.1)
          ..quadraticBezierTo(
            cx + r * 1.1 + wagAngle * r,
            cy - r * 0.3,
            cx + r * 0.9 + wagAngle * r * 0.5,
            cy - r * 0.6,
          );
        canvas.drawPath(path, tailPaint);
        break;
      case PetType.bunny:
        // Fluffy ball tail
        final tailFill = Paint()..color = Colors.white.withOpacity(0.8);
        canvas.drawCircle(Offset(cx + r * 0.7, cy + r * 0.4), r * 0.18, tailFill);
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PetPainter old) =>
      old.stage != stage ||
      old.petType != petType ||
      old.mood != mood ||
      old.breathPhase != breathPhase;
}

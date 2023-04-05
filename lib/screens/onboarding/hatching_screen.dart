import 'package:flutter/material.dart';
import 'package:confetti_widget/confetti_widget.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/pet_provider.dart';
import '../../services/haptic_service.dart';
import '../home/home_screen.dart';

/// Onboarding flow: Tap egg to hatch → name your pet → celebrate.
class HatchingScreen extends StatefulWidget {
  const HatchingScreen({super.key});

  @override
  State<HatchingScreen> createState() => _HatchingScreenState();
}

class _HatchingScreenState extends State<HatchingScreen>
    with TickerProviderStateMixin {
  int _tapCount = 0;
  bool _hatched = false;
  bool _named = false;
  final _nameController = TextEditingController();
  late ConfettiController _confettiController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _shakeAnim = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onEggTap() {
    HapticService.lightTap();
    _shakeController.forward().then((_) => _shakeController.reverse());
    setState(() {
      _tapCount++;
      if (_tapCount >= 5) {
        _hatched = true;
        _confettiController.play();
        HapticService.heavy();
      }
    });
  }

  Future<void> _onConfirm() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final petProvider = context.read<PetProvider>();
    await petProvider.createPet(name);
    setState(() => _named = true);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgMiddle, AppColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!_hatched) _buildEggPhase(),
              if (_hatched && !_named) _buildNamePhase(),
              if (_named) _buildCelebration(),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 30,
                  maxBlastForce: 20,
                  minBlastForce: 5,
                  colors: const [
                    AppColors.primary,
                    AppColors.accent,
                    AppColors.coin,
                    AppColors.success,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEggPhase() {
    final progress = (_tapCount / 5).clamp(0.0, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.tapToHatch,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: _onEggTap,
          child: _ShakeAnimWidget(
            animation: _shakeAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(_shakeAnim.value, 0),
              child: child,
            ),
            child: Column(
              children: [
                Text(
                  '🥚',
                  style: TextStyle(fontSize: 100 + progress * 20),
                ),
                const SizedBox(height: 16),
                // Progress dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _tapCount
                            ? AppColors.accent
                            : AppColors.glassWhite,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNamePhase() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐣', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 20),
          Text(
            AppStrings.congratulations,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.nameYourPet,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: TextField(
              controller: _nameController,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: AppStrings.namePetHint,
                hintStyle: TextStyle(color: AppColors.textMuted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              AppStrings.confirm,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebration() {
    final petProvider = context.watch<PetProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🎉', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text(
          '${petProvider.pet?.name ?? "Your pet"} ${AppStrings.petBorn}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Private animated widget for shake animation.
class _ShakeAnimWidget extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const _ShakeAnimWidget({
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => builder(context, child);
}

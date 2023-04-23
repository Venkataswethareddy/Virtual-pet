import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/game_provider.dart';
import '../../providers/pet_provider.dart';
import '../../services/sensor_service.dart';
import '../../services/haptic_service.dart';

/// Shake Challenge — shake phone as many times as possible in 10 seconds.
class ShakeChallengeScreen extends StatefulWidget {
  const ShakeChallengeScreen({super.key});

  @override
  State<ShakeChallengeScreen> createState() => _ShakeChallengeScreenState();
}

class _ShakeChallengeScreenState extends State<ShakeChallengeScreen> {
  static const _duration = 10; // seconds
  int _timeLeft = _duration;
  int _shakes = 0;
  bool _gameOver = false;
  bool _started = false;
  Timer? _gameTimer;
  Function()? _previousShakeHandler;

  @override
  void dispose() {
    _gameTimer?.cancel();
    // Restore previous shake handler
    SensorService.onShake = _previousShakeHandler;
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _started = true;
      _shakes = 0;
      _timeLeft = _duration;
      _gameOver = false;
    });

    // Save and override shake handler
    _previousShakeHandler = SensorService.onShake;
    SensorService.onShake = _onShake;

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });
  }

  void _onShake() {
    if (_gameOver) return;
    HapticService.lightTap();
    setState(() => _shakes++);
  }

  void _endGame() {
    _gameTimer?.cancel();
    SensorService.onShake = _previousShakeHandler;
    setState(() => _gameOver = true);

    // Score = shakes * 10
    final score = _shakes * 10;
    final gp = context.read<GameProvider>();
    final pp = context.read<PetProvider>();
    gp.submitResult('shake_challenge', score).then((coins) {
      pp.addCoins(coins);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: !_started
              ? _buildStartScreen()
              : _gameOver
                  ? _buildResultScreen()
                  : _buildGameScreen(),
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📱', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            AppStrings.shakeChallenge,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Shake your phone as fast as you can!\n10 seconds on the clock.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _startGame,
            child: const Text('Start!'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$_timeLeft',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'SHAKE!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 30),
          // Shake counter
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$_shakes',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'shakes',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 30),
          // Manual tap fallback (for emulators)
          GestureDetector(
            onTap: _onShake,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Tap here if no accelerometer',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final score = _shakes * 10;
    final coins = (score / 10).ceil().clamp(1, 999);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💪', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text(AppStrings.gameOver,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Text('$_shakes shakes!',
              style: const TextStyle(fontSize: 22, color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${AppStrings.score}: $score',
              style: const TextStyle(fontSize: 20, color: AppColors.coin, fontWeight: FontWeight.bold)),
          Text('${AppStrings.coinsEarned}: $coins 🪙',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _startGame,
            child: const Text(AppStrings.playAgain),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }
}

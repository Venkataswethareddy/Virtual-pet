import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/game_provider.dart';
import '../../providers/pet_provider.dart';
import '../../services/sensor_service.dart';

/// Feed Frenzy — food falls from top, tilt phone to move pet and catch it.
class FeedFrenzyScreen extends StatefulWidget {
  const FeedFrenzyScreen({super.key});

  @override
  State<FeedFrenzyScreen> createState() => _FeedFrenzyScreenState();
}

class _FeedFrenzyScreenState extends State<FeedFrenzyScreen> {
  static const _duration = 30; // seconds
  int _timeLeft = _duration;
  int _score = 0;
  bool _gameOver = false;
  bool _started = false;
  Timer? _gameTimer;
  Timer? _spawnTimer;
  final List<_FallingFood> _foods = [];
  double _petX = 0.5; // 0-1
  final _rng = Random();

  final List<String> _foodEmojis = ['🍎', '🍕', '🍔', '🍩', '🍗', '🍰', '🌮'];

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _started = true;
      _score = 0;
      _timeLeft = _duration;
      _gameOver = false;
      _foods.clear();
    });

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });

    _spawnTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (_gameOver) return;
      setState(() {
        _foods.add(_FallingFood(
          emoji: _foodEmojis[_rng.nextInt(_foodEmojis.length)],
          x: _rng.nextDouble(),
          y: 0,
        ));
      });
    });

    // Game loop — update food positions
    _tick();
  }

  void _tick() {
    if (_gameOver) return;
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted || _gameOver) return;
      setState(() {
        // Update pet position from tilt sensor
        _petX = (_petX - SensorService.tiltX * 0.03).clamp(0.05, 0.95);

        // Move food down
        for (int i = _foods.length - 1; i >= 0; i--) {
          _foods[i].y += 0.015;

          // Check catch
          if (_foods[i].y > 0.8 && _foods[i].y < 0.92) {
            if ((_foods[i].x - _petX).abs() < 0.1) {
              _score += 10;
              _foods.removeAt(i);
              continue;
            }
          }

          // Remove if off screen
          if (_foods[i].y > 1.1) {
            _foods.removeAt(i);
          }
        }
      });
      _tick();
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    setState(() => _gameOver = true);

    // Submit score
    final gp = context.read<GameProvider>();
    final pp = context.read<PetProvider>();
    gp.submitResult('feed_frenzy', _score).then((coins) {
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
          const Text('🍔', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            AppStrings.feedFrenzy,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tilt your phone to catch falling food!\n30 seconds to score as much as possible.',
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Timer and score
            Positioned(
              top: 10,
              left: 16,
              child: Text(
                '⏱ $_timeLeft s',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            Positioned(
              top: 10,
              right: 16,
              child: Text(
                '${AppStrings.score}: $_score',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.coin),
              ),
            ),

            // Falling food
            ..._foods.map((food) => Positioned(
                  left: food.x * constraints.maxWidth - 15,
                  top: food.y * constraints.maxHeight - 15,
                  child: Text(food.emoji, style: const TextStyle(fontSize: 30)),
                )),

            // Pet catcher
            Positioned(
              bottom: 40,
              left: _petX * constraints.maxWidth - 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('😋', style: TextStyle(fontSize: 30)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultScreen() {
    final coins = (_score / 10).ceil().clamp(1, 999);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppStrings.gameOver,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Text('${AppStrings.score}: $_score',
              style: const TextStyle(fontSize: 22, color: AppColors.coin, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${AppStrings.coinsEarned}: $coins 🪙',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
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

class _FallingFood {
  final String emoji;
  final double x;
  double y;
  _FallingFood({required this.emoji, required this.x, required this.y});
}

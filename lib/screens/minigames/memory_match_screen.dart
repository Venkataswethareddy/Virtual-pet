import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/game_provider.dart';
import '../../providers/pet_provider.dart';

/// Memory Match — 4x4 grid of cards, flip 2 at a time to find pairs.
class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  late List<String> _cards;
  late List<bool> _revealed;
  late List<bool> _matched;
  int _firstIndex = -1;
  int _moves = 0;
  bool _processing = false;
  bool _gameOver = false;
  bool _started = false;
  final Stopwatch _stopwatch = Stopwatch();

  final List<String> _emojis = ['🐱', '🐶', '🐰', '🦊', '🐸', '🐧', '🦁', '🐼'];

  void _startGame() {
    final rng = Random();
    final pairs = List<String>.from(_emojis)..shuffle(rng);
    _cards = [...pairs, ...pairs]..shuffle(rng);
    _revealed = List.filled(16, false);
    _matched = List.filled(16, false);
    _firstIndex = -1;
    _moves = 0;
    _gameOver = false;
    _processing = false;
    _stopwatch.reset();
    _stopwatch.start();
    setState(() => _started = true);
  }

  void _onCardTap(int index) {
    if (_processing || _revealed[index] || _matched[index] || _gameOver) return;

    setState(() => _revealed[index] = true);

    if (_firstIndex == -1) {
      _firstIndex = index;
      return;
    }

    // Second card flipped
    _moves++;
    _processing = true;

    if (_cards[_firstIndex] == _cards[index]) {
      // Match!
      setState(() {
        _matched[_firstIndex] = true;
        _matched[index] = true;
      });
      _firstIndex = -1;
      _processing = false;

      // Check win
      if (_matched.every((m) => m)) {
        _stopwatch.stop();
        setState(() => _gameOver = true);

        // Score = max(500 - moves * 10 - seconds * 5, 50)
        final seconds = _stopwatch.elapsed.inSeconds;
        final score = (500 - _moves * 10 - seconds * 5).clamp(50, 500);

        final gp = context.read<GameProvider>();
        final pp = context.read<PetProvider>();
        gp.submitResult('memory_match', score).then((coins) {
          pp.addCoins(coins);
        });
      }
    } else {
      // No match — hide after delay
      final first = _firstIndex;
      _firstIndex = -1;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _revealed[first] = false;
          _revealed[index] = false;
          _processing = false;
        });
      });
    }
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
          const Text('🃏', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            AppStrings.memoryMatch,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Flip cards to find matching pairs.\nFewer moves = higher score!',
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Moves: $_moves',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 16,
              itemBuilder: (context, i) {
                final show = _revealed[i] || _matched[i];
                return GestureDetector(
                  onTap: () => _onCardTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _matched[i]
                          ? AppColors.success.withOpacity(0.3)
                          : show
                              ? AppColors.primary.withOpacity(0.3)
                              : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _matched[i]
                            ? AppColors.success
                            : show
                                ? AppColors.primary
                                : AppColors.glassBorder,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          show ? _cards[i] : '?',
                          key: ValueKey(show ? _cards[i] : '?_$i'),
                          style: TextStyle(fontSize: show ? 32 : 28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final seconds = _stopwatch.elapsed.inSeconds;
    final score = (500 - _moves * 10 - seconds * 5).clamp(50, 500);
    final coins = (score / 10).ceil().clamp(1, 999);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text('You Win!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Text('Moves: $_moves  •  Time: ${seconds}s',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          Text('${AppStrings.score}: $score',
              style: const TextStyle(fontSize: 22, color: AppColors.coin, fontWeight: FontWeight.bold)),
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

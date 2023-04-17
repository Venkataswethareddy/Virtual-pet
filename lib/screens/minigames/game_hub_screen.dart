import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/game_provider.dart';
import '../../widgets/games/game_card.dart';
import '../../widgets/common/coin_display.dart';
import '../../providers/pet_provider.dart';
import 'feed_frenzy_screen.dart';
import 'memory_match_screen.dart';
import 'shake_challenge_screen.dart';

/// Game hub — lists all mini-games.
class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final pet = context.watch<PetProvider>().pet;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Mini Games',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                CoinDisplay(coins: pet?.coins ?? 0),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Play games to earn coins for your pet!',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            GameCard(
              title: AppStrings.feedFrenzy,
              emoji: '🍔',
              description: 'Catch falling food! Tilt to move.',
              highScore: gameProvider.highScore('feed_frenzy'),
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedFrenzyScreen()),
              ),
            ),
            GameCard(
              title: AppStrings.memoryMatch,
              emoji: '🃏',
              description: 'Flip cards to find matching pairs.',
              highScore: gameProvider.highScore('memory_match'),
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MemoryMatchScreen()),
              ),
            ),
            GameCard(
              title: AppStrings.shakeChallenge,
              emoji: '📱',
              description: 'Shake your phone as fast as you can!',
              highScore: gameProvider.highScore('shake_challenge'),
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShakeChallengeScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

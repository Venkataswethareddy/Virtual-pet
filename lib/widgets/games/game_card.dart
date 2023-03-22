import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Card widget for a mini-game entry in the game hub.
class GameCard extends StatelessWidget {
  final String title;
  final String emoji;
  final String description;
  final int highScore;
  final VoidCallback onPlay;

  const GameCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.description,
    this.highScore = 0,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 42)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (highScore > 0) ...[
                    const SizedBox(height: 6),
                    Text(
                      '🏆 High Score: $highScore',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.coin,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_fill,
              color: AppColors.primary,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}

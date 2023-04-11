import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/enums/pet_mood.dart';
import '../../core/utils/time_helper.dart';
import '../../core/utils/evolution_logic.dart';
import '../../models/personality_model.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/stats/stat_bar.dart';
import '../../widgets/stats/mood_indicator.dart';
import '../../widgets/stats/age_display.dart';

/// Detailed stats screen with personality traits, evolution history, and timestamps.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        final pet = petProvider.pet;
        if (pet == null) return const Center(child: Text('No pet'));

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Pet Stats',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Name, mood, age
              Row(
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  MoodIndicator(mood: pet.mood),
                ],
              ),
              const SizedBox(height: 8),
              AgeDisplay(birthDate: pet.birthDate),
              const SizedBox(height: 6),
              Text(
                'Form: ${EvolutionLogic.formLabel(pet.petType, pet.stage)}',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 24),

              // Stat bars
              StatBar(label: AppStrings.hunger, value: pet.hunger, color: AppColors.hungerBar, icon: Icons.restaurant),
              StatBar(label: AppStrings.happiness, value: pet.happiness, color: AppColors.happinessBar, icon: Icons.sentiment_very_satisfied),
              StatBar(label: AppStrings.energy, value: pet.energy, color: AppColors.energyBar, icon: Icons.bolt),
              StatBar(label: AppStrings.health, value: pet.health, color: AppColors.healthBar, icon: Icons.favorite),

              const SizedBox(height: 28),

              // Personality DNA
              _sectionTitle('Personality DNA'),
              const SizedBox(height: 8),
              _personalityRow(AppStrings.bravery, pet.personality.bravery, Colors.orange),
              _personalityRow(AppStrings.activity, pet.personality.activity, Colors.green),
              _personalityRow(AppStrings.friendliness, pet.personality.friendliness, Colors.pink),
              _personalityRow(AppStrings.appetite, pet.personality.appetite, Colors.red),

              const SizedBox(height: 28),

              // Care history
              _sectionTitle('Care History'),
              const SizedBox(height: 8),
              _infoRow('Times Fed', '${pet.feedCount}'),
              _infoRow('Times Played', '${pet.playCount}'),
              _infoRow('Times Slept', '${pet.sleepCount}'),
              _infoRow('Last Fed', TimeHelper.timeAgo(pet.lastFed)),
              _infoRow('Last Played', TimeHelper.timeAgo(pet.lastPlayed)),

              const SizedBox(height: 28),

              // Evolution history
              if (pet.evolutionHistory.isNotEmpty) ...[
                _sectionTitle('Evolution History'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pet.evolutionHistory
                      .map((e) => Chip(
                            label: Text(e),
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            labelStyle: const TextStyle(color: AppColors.textPrimary),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.accent,
        ),
      );

  Widget _personalityRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 55,
            child: Text(
              PersonalityModel.traitLabel(value),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

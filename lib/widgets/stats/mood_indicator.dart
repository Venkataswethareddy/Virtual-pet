import 'package:flutter/material.dart';
import '../../core/enums/pet_mood.dart';
import '../../core/constants/app_strings.dart';

/// Displays the pet's current mood with an icon and label.
class MoodIndicator extends StatelessWidget {
  final PetMood mood;

  const MoodIndicator({super.key, required this.mood});

  String get _label {
    switch (mood) {
      case PetMood.happy: return AppStrings.moodHappy;
      case PetMood.sad: return AppStrings.moodSad;
      case PetMood.hungry: return AppStrings.moodHungry;
      case PetMood.sick: return AppStrings.moodSick;
      case PetMood.sleeping: return AppStrings.moodSleeping;
      case PetMood.excited: return AppStrings.moodExcited;
      case PetMood.scared: return AppStrings.moodScared;
    }
  }

  Color get _color {
    switch (mood) {
      case PetMood.happy: return const Color(0xFF66BB6A);
      case PetMood.sad: return const Color(0xFF42A5F5);
      case PetMood.hungry: return const Color(0xFFFF7043);
      case PetMood.sick: return const Color(0xFFEF5350);
      case PetMood.sleeping: return const Color(0xFF7E57C2);
      case PetMood.excited: return const Color(0xFFFFCA28);
      case PetMood.scared: return const Color(0xFF78909C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(mood),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color.withOpacity(0.5)),
        ),
        child: Text(
          _label,
          style: TextStyle(
            color: _color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

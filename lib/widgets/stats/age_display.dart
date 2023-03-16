import 'package:flutter/material.dart';
import '../../core/utils/time_helper.dart';
import '../../core/constants/app_colors.dart';

/// Displays pet age and birth date.
class AgeDisplay extends StatelessWidget {
  final DateTime birthDate;

  const AgeDisplay({super.key, required this.birthDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cake_rounded, color: AppColors.accent, size: 18),
          const SizedBox(width: 6),
          Text(
            TimeHelper.formatAge(birthDate),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

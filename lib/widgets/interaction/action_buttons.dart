import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Row of action buttons: Play, Sleep, Heal.
class ActionButtons extends StatelessWidget {
  final VoidCallback? onPlay;
  final VoidCallback? onSleep;
  final VoidCallback? onHeal;
  final bool isSleeping;
  final bool needsHeal;

  const ActionButtons({
    super.key,
    this.onPlay,
    this.onSleep,
    this.onHeal,
    this.isSleeping = false,
    this.needsHeal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionBtn(
          icon: Icons.sports_esports,
          label: 'Play',
          color: AppColors.happinessBar,
          onTap: isSleeping ? null : onPlay,
        ),
        const SizedBox(width: 12),
        _ActionBtn(
          icon: isSleeping ? Icons.wb_sunny : Icons.nightlight_round,
          label: isSleeping ? 'Wake' : 'Sleep',
          color: const Color(0xFF7E57C2),
          onTap: onSleep,
        ),
        if (needsHeal) ...[
          const SizedBox(width: 12),
          _ActionBtn(
            icon: Icons.healing,
            label: 'Heal',
            color: AppColors.healthBar,
            onTap: onHeal,
          ),
        ],
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4)),
            boxShadow: enabled
                ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

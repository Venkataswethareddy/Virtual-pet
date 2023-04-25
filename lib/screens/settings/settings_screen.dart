import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/pet_provider.dart';
import '../../services/audio_service.dart';
import '../onboarding/hatching_screen.dart';

/// Settings screen with sound toggle, notification toggle, and pet reset.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = AudioService.enabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Sound toggle
          _settingsTile(
            icon: Icons.volume_up,
            title: AppStrings.soundEffects,
            trailing: Switch(
              value: _soundEnabled,
              activeColor: AppColors.primary,
              onChanged: (v) {
                setState(() {
                  _soundEnabled = v;
                  AudioService.enabled = v;
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // Reset pet
          _settingsTile(
            icon: Icons.delete_forever,
            title: AppStrings.resetPet,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
            onTap: () => _confirmReset(context),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppStrings.resetPet,
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(AppStrings.resetConfirm,
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<PetProvider>().resetPet();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HatchingScreen()),
                (_) => false,
              );
            },
            child: const Text('Reset', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

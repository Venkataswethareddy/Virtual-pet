import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti_widget/confetti_widget.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/enums/pet_mood.dart';
import '../../models/shop_item_model.dart';
import '../../providers/pet_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/room_provider.dart';
import '../../services/sensor_service.dart';
import '../../services/haptic_service.dart';
import '../../widgets/pet/pet_character.dart';
import '../../widgets/pet/pet_bubble.dart';
import '../../widgets/interaction/pet_touch.dart';
import '../../widgets/interaction/action_buttons.dart';
import '../../widgets/interaction/drag_food.dart';
import '../../widgets/room/room_background.dart';
import '../../widgets/room/room_furniture.dart';
import '../../widgets/stats/stat_bar.dart';
import '../../widgets/stats/mood_indicator.dart';
import '../../widgets/common/coin_display.dart';
import '../stats/stats_screen.dart';
import '../shop/shop_screen.dart';
import '../minigames/game_hub_screen.dart';
import '../settings/settings_screen.dart';

/// Main screen - the pet lives here.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _navIndex = 0;
  late ConfettiController _confettiController;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    // Init providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().loadPet();
      context.read<InventoryProvider>().loadInventory();
      context.read<RoomProvider>().loadRoom();
    });

    // Start sensors
    SensorService.start();
    SensorService.onShake = _onShake;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _confettiController.dispose();
    SensorService.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-apply decay when user returns
      context.read<PetProvider>().loadPet();
    }
  }

  void _onShake() {
    final petProvider = context.read<PetProvider>();
    petProvider.shakePet();
    HapticService.medium();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        if (petProvider.pet == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Show while-away dialog
        if (petProvider.whileAwaySummary.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showWhileAwayDialog(petProvider.whileAwaySummary);
            petProvider.clearWhileAway();
          });
        }

        // Show evolution celebration
        if (petProvider.showEvolution) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _confettiController.play();
            HapticService.success();
            petProvider.clearEvolution();
          });
        }

        final pages = [
          _buildHomePage(petProvider),
          const GameHubScreen(),
          const ShopScreen(),
          const StatsScreen(),
        ];

        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              IndexedStack(index: _navIndex, children: pages),
              // Confetti overlay
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 40,
                  colors: const [
                    AppColors.primary,
                    AppColors.accent,
                    AppColors.coin,
                    AppColors.success,
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: BottomNavigationBar(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: AppStrings.home),
                  BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: AppStrings.games),
                  BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: AppStrings.shop),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: AppStrings.stats),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePage(PetProvider petProvider) {
    final pet = petProvider.pet!;
    final inventory = context.watch<InventoryProvider>();
    final room = context.watch<RoomProvider>();

    // Get food items from inventory for drag-to-feed
    final foodItems = inventory.itemsWithDetails
        .where((e) => e.key.type.name == 'food')
        .toList();

    return Stack(
      children: [
        // Room background (day/night)
        const RoomBackground(),

        // Room furniture / decorations
        RoomFurniture(decorations: room.decorations),

        // Main content
        SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    MoodIndicator(mood: pet.mood),
                    const Spacer(),
                    CoinDisplay(coins: pet.coins),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.settings, color: AppColors.textSecondary),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              // Thought bubble
              if (petProvider.currentThought.isNotEmpty)
                PetBubble(text: petProvider.currentThought),

              const Spacer(),

              // Pet character — drop target for food
              DragTarget<ShopItemModel>(
                onAcceptWithDetails: (details) async {
                  final item = details.data;
                  final used = await inventory.useItem(item.id);
                  if (used) {
                    await petProvider.useShopItem(item);
                    HapticService.medium();
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return PetTouch(
                    child: AnimatedScale(
                      scale: candidateData.isNotEmpty ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: PetCharacter(
                        stage: pet.stage,
                        petType: pet.petType,
                        mood: pet.mood,
                        costumeId: pet.costumeId,
                        tiltX: SensorService.tiltX,
                        size: 200,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Quick stat bars
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    StatBar(label: 'Hunger', value: pet.hunger, color: AppColors.hungerBar, icon: Icons.restaurant),
                    StatBar(label: 'Happy', value: pet.happiness, color: AppColors.happinessBar, icon: Icons.sentiment_very_satisfied),
                    StatBar(label: 'Energy', value: pet.energy, color: AppColors.energyBar, icon: Icons.bolt),
                    StatBar(label: 'Health', value: pet.health, color: AppColors.healthBar, icon: Icons.favorite),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Action buttons
              ActionButtons(
                onPlay: () => petProvider.playWithPet(),
                onSleep: () => petProvider.sleepPet(),
                isSleeping: pet.isSleeping,
                needsHeal: pet.health < 50,
                onHeal: () => petProvider.healPet(25),
              ),

              const SizedBox(height: 10),

              // Food tray (drag from here)
              if (foodItems.isNotEmpty)
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: foodItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => DragFood(item: foodItems[i].key),
                  ),
                ),

              const SizedBox(height: 90), // space for bottom nav
            ],
          ),
        ),
      ],
    );
  }

  void _showWhileAwayDialog(List<String> messages) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          AppStrings.whileYouWereAway,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: messages
              .map((m) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Text('• ', style: TextStyle(color: AppColors.accent)),
                        Expanded(
                          child: Text(m, style: const TextStyle(color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

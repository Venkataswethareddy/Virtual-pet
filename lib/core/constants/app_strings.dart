/// All user-facing strings centralised here for easy i18n later.
class AppStrings {
  AppStrings._();

  // ── App ──────────────────────────────────────────────
  static const String appName = 'TAMAGO ALIVE';
  static const String appTagline = 'Your pet, alive & unique';

  // ── Onboarding ───────────────────────────────────────
  static const String tapToHatch = 'Tap the egg to hatch your pet!';
  static const String nameYourPet = 'Name your new friend';
  static const String namePetHint = 'Enter a name…';
  static const String confirm = 'Confirm';
  static const String congratulations = 'Congratulations!';
  static const String petBorn = 'Your pet has been born!';

  // ── Nav ──────────────────────────────────────────────
  static const String home = 'Home';
  static const String games = 'Games';
  static const String shop = 'Shop';
  static const String stats = 'Stats';

  // ── Stats ────────────────────────────────────────────
  static const String hunger = 'Hunger';
  static const String happiness = 'Happiness';
  static const String energy = 'Energy';
  static const String health = 'Health';

  // ── Mood labels ──────────────────────────────────────
  static const String moodHappy = 'Happy 😊';
  static const String moodSad = 'Sad 😢';
  static const String moodHungry = 'Hungry 🍔';
  static const String moodSick = 'Sick 🤒';
  static const String moodSleeping = 'Sleeping 😴';
  static const String moodExcited = 'Excited 🤩';
  static const String moodScared = 'Scared 😨';

  // ── Interactions ─────────────────────────────────────
  static const String feed = 'Feed';
  static const String play = 'Play';
  static const String sleep = 'Sleep';
  static const String heal = 'Heal';
  static const String pat = 'Pat';

  // ── While-away summary ───────────────────────────────
  static const String whileYouWereAway = 'While you were away…';
  static const String petGotHungry = 'Your pet got hungry';
  static const String petTookNap = 'Your pet took a nap';
  static const String petMissedYou = 'Your pet missed you!';

  // ── Shop ─────────────────────────────────────────────
  static const String shopTitle = 'Shop';
  static const String buy = 'Buy';
  static const String notEnoughCoins = 'Not enough coins!';
  static const String purchased = 'Purchased!';

  // ── Mini-games ───────────────────────────────────────
  static const String feedFrenzy = 'Feed Frenzy';
  static const String memoryMatch = 'Memory Match';
  static const String shakeChallenge = 'Shake Challenge';
  static const String gameOver = 'Game Over!';
  static const String score = 'Score';
  static const String highScore = 'High Score';
  static const String coinsEarned = 'Coins Earned';
  static const String playAgain = 'Play Again';

  // ── Evolution ────────────────────────────────────────
  static const String evolving = 'Your pet is evolving!';

  // ── Personality ──────────────────────────────────────
  static const String bravery = 'Bravery';
  static const String activity = 'Activity';
  static const String friendliness = 'Friendliness';
  static const String appetite = 'Appetite';

  // ── Settings ─────────────────────────────────────────
  static const String settings = 'Settings';
  static const String resetPet = 'Reset Pet';
  static const String resetConfirm = 'This will delete your pet forever. Are you sure?';
  static const String soundEffects = 'Sound Effects';
  static const String notifications = 'Notifications';

  // ── Thought bubbles ──────────────────────────────────
  static const List<String> hungryThoughts = [
    "I'm hungry… 🍕",
    "Feed me please!",
    "My tummy is rumbling…",
  ];
  static const List<String> happyThoughts = [
    "I love you! ❤️",
    "Life is great! ✨",
    "Yay! 🎉",
  ];
  static const List<String> sadThoughts = [
    "I'm lonely… 😢",
    "Play with me…",
    "I feel sad…",
  ];
  static const List<String> sleepyThoughts = [
    "So sleepy… 💤",
    "I need a nap…",
    "Zzzzz…",
  ];
  static const List<String> sickThoughts = [
    "I don't feel well… 🤒",
    "Help me…",
    "I need medicine…",
  ];
}

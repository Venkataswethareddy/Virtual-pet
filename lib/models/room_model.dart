/// The pet's room — tracks placed decorations and unlocked themes.
class RoomModel {
  /// Currently placed decoration item IDs with position offsets.
  List<PlacedDecoration> decorations;

  /// Unlocked room theme IDs.
  List<String> unlockedThemes;

  /// Current room theme ID.
  String currentTheme;

  RoomModel({
    List<PlacedDecoration>? decorations,
    List<String>? unlockedThemes,
    this.currentTheme = 'default',
  })  : decorations = decorations ?? [],
        unlockedThemes = unlockedThemes ?? ['default'];

  Map<String, dynamic> toMap() => {
        'decorations': decorations.map((d) => d.toMap()).toList(),
        'unlockedThemes': unlockedThemes,
        'currentTheme': currentTheme,
      };

  factory RoomModel.fromMap(Map<dynamic, dynamic> map) => RoomModel(
        decorations: (map['decorations'] as List?)
                ?.map((d) => PlacedDecoration.fromMap(d as Map))
                .toList() ??
            [],
        unlockedThemes: List<String>.from(map['unlockedThemes'] ?? ['default']),
        currentTheme: map['currentTheme'] as String? ?? 'default',
      );
}

/// A decoration placed in the room at a relative (dx, dy) position.
class PlacedDecoration {
  final String itemId;
  double dx; // 0.0 – 1.0 fraction of screen width
  double dy; // 0.0 – 1.0 fraction of screen height

  PlacedDecoration({required this.itemId, this.dx = 0.5, this.dy = 0.5});

  Map<String, dynamic> toMap() => {'itemId': itemId, 'dx': dx, 'dy': dy};

  factory PlacedDecoration.fromMap(Map<dynamic, dynamic> map) => PlacedDecoration(
        itemId: map['itemId'] as String,
        dx: (map['dx'] as num).toDouble(),
        dy: (map['dy'] as num).toDouble(),
      );
}

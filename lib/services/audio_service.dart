import 'package:audioplayers/audioplayers.dart';
import '../core/constants/asset_paths.dart';

/// Wrapper around [AudioPlayer] for pet sound effects.
/// Currently configured with placeholder paths — swap in real .mp3 assets later.
class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _enabled = true;

  static bool get enabled => _enabled;
  static set enabled(bool value) => _enabled = value;

  /// Play an asset audio file. Silently fails if file not found or audio disabled.
  static Future<void> _play(String assetPath) async {
    if (!_enabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } catch (e) {
      // Audio files not yet added — fail silently
      print('AudioService: could not play $assetPath ($e)');
    }
  }

  static Future<void> playHappy() => _play(AssetPaths.audioHappy);
  static Future<void> playSad() => _play(AssetPaths.audioSad);
  static Future<void> playEat() => _play(AssetPaths.audioEat);
  static Future<void> playSleep() => _play(AssetPaths.audioSleep);
  static Future<void> playEvolve() => _play(AssetPaths.audioEvolve);
  static Future<void> playCoin() => _play(AssetPaths.audioCoin);
  static Future<void> playTap() => _play(AssetPaths.audioTap);

  static Future<void> dispose() async {
    await _player.dispose();
  }
}

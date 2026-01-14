import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Notifier for Map values
class MapNotifier<K, V> extends ValueNotifier<Map<K, V>> {
  MapNotifier(super.value);

  void add(K key, V value) {
    if (value == this.value[key]) return;
    final newMap = Map<K, V>.from(this.value);
    newMap[key] = value;
    this.value = newMap;
    // notifyListeners() is called automatically by ValueNotifier when value changes
  }

  void remove(K key) {
    if (!value.containsKey(key)) return;
    final newMap = Map<K, V>.from(value);
    newMap.remove(key);
    value = newMap;
  }

  void clear() {
    if (value.isEmpty) return;
    value = {};
  }
}

/// Factory class for managing audio player controllers and state.
class AudioPlayerFactory {
  static final MapNotifier<String, int> _audioPositions = MapNotifier({});
  static final MapNotifier<String, int> _audioDurationsInSeconds = MapNotifier(
    {},
  );
  static final Map<String, AudioPlayer> _controllers = {};
  static final ValueNotifier<String?> currentAudioMessageId =
      ValueNotifier(null);

  /// Gets the audio positions notifier.
  static MapNotifier<String, int> get audioPositions => _audioPositions;

  /// Gets the audio durations notifier.
  static MapNotifier<String, int> get audioDurationsInSeconds =>
      _audioDurationsInSeconds;

  /// Gets all active audio controllers.
  static Map<String, AudioPlayer> get controllers =>
      Map.unmodifiable(_controllers);

  /// Gets the count of active controllers.
  static int get controllersCount => _controllers.length;

  /// Creates or retrieves an audio player for a message.
  static AudioPlayer create(
    String id, {
    String? filePath,
    String? url,
  }) {
    return _controllers.putIfAbsent(id, () {
      final audioPlayer = AudioPlayer();
      final currentPosition =
          _audioPositions.value[id] ?? audioPlayer.position.inSeconds;
      final duration = Duration(seconds: currentPosition);

      if (filePath != null) {
        audioPlayer.setFilePath(filePath, initialPosition: duration);
      } else if (url != null) {
        audioPlayer.setUrl(url, initialPosition: duration);
      }

      return audioPlayer;
    });
  }

  /// Plays an audio file.
  static void play(
    String id, {
    String? filePath,
    String? url,
  }) {
    final audioPlayer = create(id, filePath: filePath, url: url);

    // Pause any currently playing audio.
    pauseCurrentAudio();

    audioPlayer.play();
  }

  /// Pauses the current audio.
  static void pauseCurrentAudio() {
    final currentId = currentAudioMessageId.value;
    if (currentId != null) pause(currentId);
  }

  /// Pauses an audio player.
  static void pause(String id) {
    _controllers[id]?.pause();
    currentAudioMessageId.value = null;
  }

  /// Seeks to a specific position.
  static void seek(String id, Duration position) {
    _controllers[id]?.seek(position);
    _audioPositions.add(id, position.inSeconds);
  }

  /// Stores audio duration.
  static void setDuration(String id, int duration) {
    _audioDurationsInSeconds.add(id, duration);
  }

  /// Disposes a specific audio controller.
  static bool dispose(String id) {
    final controller = _controllers.remove(id);
    if (controller == null) return false;

    controller.pause();
    controller.dispose();

    _audioPositions.remove(id);
    _audioDurationsInSeconds.remove(id);

    if (currentAudioMessageId.value == id) {
      currentAudioMessageId.value = null;
    }

    return true;
  }

  /// Disposes all audio controllers.
  static int disposeAll() {
    final count = _controllers.length;
    for (final controller in _controllers.values) {
      controller.pause();
      controller.dispose();
    }
    _controllers.clear();
    _audioPositions.clear();
    _audioDurationsInSeconds.clear();
    currentAudioMessageId.value = null;
    return count;
  }

  /// Pauses all currently playing audio.
  static void pauseAll() {
    for (final controller in _controllers.values) {
      controller.pause();
    }
    currentAudioMessageId.value = null;
  }
}

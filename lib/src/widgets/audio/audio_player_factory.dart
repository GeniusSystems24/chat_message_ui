import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Playback state for audio players.
enum AudioPlaybackState {
  /// Audio is stopped/not started.
  stopped,

  /// Audio is currently playing.
  playing,

  /// Audio is paused.
  paused,

  /// Audio is loading/buffering.
  loading,

  /// Audio playback completed.
  completed,

  /// Error occurred during playback.
  error,
}

/// Repeat mode for audio playback.
enum AudioRepeatMode {
  /// No repeat - stop after playing.
  none,

  /// Repeat current audio.
  one,

  /// Repeat all in queue.
  all,
}

/// Audio player configuration.
class AudioPlayerConfig {
  /// Initial volume (0.0 - 1.0).
  final double volume;

  /// Initial playback speed (0.5 - 2.0).
  final double speed;

  /// Whether to auto-play when loaded.
  final bool autoPlay;

  /// Repeat mode.
  final AudioRepeatMode repeatMode;

  const AudioPlayerConfig({
    this.volume = 1.0,
    this.speed = 1.0,
    this.autoPlay = false,
    this.repeatMode = AudioRepeatMode.none,
  });

  static const AudioPlayerConfig defaultConfig = AudioPlayerConfig();
}

/// State snapshot for an audio player.
class AudioPlayerState {
  /// Unique identifier.
  final String id;

  /// Current playback state.
  final AudioPlaybackState state;

  /// Current position in seconds.
  final int positionInSeconds;

  /// Total duration in seconds.
  final int durationInSeconds;

  /// Current volume (0.0 - 1.0).
  final double volume;

  /// Current playback speed.
  final double speed;

  /// Current repeat mode.
  final AudioRepeatMode repeatMode;

  /// Whether audio is buffering.
  final bool isBuffering;

  /// Error message if any.
  final String? errorMessage;

  const AudioPlayerState({
    required this.id,
    this.state = AudioPlaybackState.stopped,
    this.positionInSeconds = 0,
    this.durationInSeconds = 0,
    this.volume = 1.0,
    this.speed = 1.0,
    this.repeatMode = AudioRepeatMode.none,
    this.isBuffering = false,
    this.errorMessage,
  });

  /// Progress as a value between 0.0 and 1.0.
  double get progress =>
      durationInSeconds > 0 ? positionInSeconds / durationInSeconds : 0.0;

  /// Whether audio is currently playing.
  bool get isPlaying => state == AudioPlaybackState.playing;

  /// Whether audio is paused.
  bool get isPaused => state == AudioPlaybackState.paused;

  /// Whether audio has completed.
  bool get isCompleted => state == AudioPlaybackState.completed;

  AudioPlayerState copyWith({
    AudioPlaybackState? state,
    int? positionInSeconds,
    int? durationInSeconds,
    double? volume,
    double? speed,
    AudioRepeatMode? repeatMode,
    bool? isBuffering,
    String? errorMessage,
  }) {
    return AudioPlayerState(
      id: id,
      state: state ?? this.state,
      positionInSeconds: positionInSeconds ?? this.positionInSeconds,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      repeatMode: repeatMode ?? this.repeatMode,
      isBuffering: isBuffering ?? this.isBuffering,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier for Map values.
class MapNotifier<K, V> extends ValueNotifier<Map<K, V>> {
  MapNotifier(super.value);

  void add(K key, V value) {
    if (value == this.value[key]) return;
    final newMap = Map<K, V>.from(this.value);
    newMap[key] = value;
    this.value = newMap;
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

  V? operator [](K key) => value[key];
}

/// Factory class for managing audio player controllers and state.
///
/// Provides centralized audio playback management with features like:
/// - Play/pause/stop controls
/// - Seek functionality
/// - Volume and speed control
/// - Repeat modes
/// - Queue management
/// - State notifications via streams
class AudioPlayerFactory {
  // Private state
  static final MapNotifier<String, int> _audioPositions = MapNotifier({});
  static final MapNotifier<String, int> _audioDurationsInSeconds =
      MapNotifier({});
  static final Map<String, AudioPlayer> _controllers = {};
  static final Map<String, AudioPlayerState> _playerStates = {};
  static final Map<String, List<StreamSubscription>> _subscriptions = {};

  // Stream controllers for state changes
  static final StreamController<AudioPlayerState> _stateController =
      StreamController<AudioPlayerState>.broadcast();
  static final StreamController<String?> _currentAudioController =
      StreamController<String?>.broadcast();

  // Current audio and queue
  static final ValueNotifier<String?> currentAudioMessageId =
      ValueNotifier(null);
  static final List<String> _playQueue = [];
  static int _currentQueueIndex = -1;

  // Global settings
  static double _globalVolume = 1.0;
  static double _globalSpeed = 1.0;
  static AudioRepeatMode _globalRepeatMode = AudioRepeatMode.none;

  // ============ Getters ============

  /// Stream of audio player state changes.
  static Stream<AudioPlayerState> get stateStream => _stateController.stream;

  /// Stream of current audio ID changes.
  static Stream<String?> get currentAudioStream =>
      _currentAudioController.stream;

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

  /// Gets the current play queue.
  static List<String> get playQueue => List.unmodifiable(_playQueue);

  /// Gets the current queue index.
  static int get currentQueueIndex => _currentQueueIndex;

  /// Gets global volume setting.
  static double get globalVolume => _globalVolume;

  /// Gets global speed setting.
  static double get globalSpeed => _globalSpeed;

  /// Gets global repeat mode.
  static AudioRepeatMode get globalRepeatMode => _globalRepeatMode;

  /// Gets the state for a specific audio player.
  static AudioPlayerState? getState(String id) => _playerStates[id];

  // ============ Core Methods ============

  /// Creates or retrieves an audio player for a message.
  static AudioPlayer create(
    String id, {
    String? filePath,
    String? url,
    AudioPlayerConfig config = AudioPlayerConfig.defaultConfig,
  }) {
    return _controllers.putIfAbsent(id, () {
      final audioPlayer = AudioPlayer();

      // Initialize state
      _playerStates[id] = AudioPlayerState(
        id: id,
        volume: config.volume,
        speed: config.speed,
        repeatMode: config.repeatMode,
      );

      // Set initial volume and speed
      audioPlayer.setVolume(config.volume);
      audioPlayer.setSpeed(config.speed);

      // Get initial position
      final currentPosition =
          _audioPositions.value[id] ?? audioPlayer.position.inSeconds;
      final duration = Duration(seconds: currentPosition);

      // Set audio source
      if (filePath != null) {
        audioPlayer.setFilePath(filePath, initialPosition: duration);
      } else if (url != null) {
        audioPlayer.setUrl(url, initialPosition: duration);
      }

      // Set up listeners
      _setupListeners(id, audioPlayer, config);

      return audioPlayer;
    });
  }

  /// Sets up stream listeners for an audio player.
  static void _setupListeners(
    String id,
    AudioPlayer player,
    AudioPlayerConfig config,
  ) {
    final subs = <StreamSubscription>[];

    // Position stream
    subs.add(player.positionStream.listen((position) {
      _audioPositions.add(id, position.inSeconds);
      _updateState(id, positionInSeconds: position.inSeconds);
    }));

    // Duration stream
    subs.add(player.durationStream.listen((duration) {
      if (duration != null) {
        _audioDurationsInSeconds.add(id, duration.inSeconds);
        _updateState(id, durationInSeconds: duration.inSeconds);
      }
    }));

    // Player state stream
    subs.add(player.playerStateStream.listen((state) {
      AudioPlaybackState playbackState;
      switch (state.processingState) {
        case ProcessingState.idle:
          playbackState = AudioPlaybackState.stopped;
          break;
        case ProcessingState.loading:
          playbackState = AudioPlaybackState.loading;
          break;
        case ProcessingState.buffering:
          playbackState = AudioPlaybackState.loading;
          break;
        case ProcessingState.ready:
          playbackState =
              state.playing ? AudioPlaybackState.playing : AudioPlaybackState.paused;
          break;
        case ProcessingState.completed:
          playbackState = AudioPlaybackState.completed;
          _handlePlaybackCompleted(id, config);
          break;
      }
      _updateState(
        id,
        state: playbackState,
        isBuffering: state.processingState == ProcessingState.buffering,
      );
    }));

    _subscriptions[id] = subs;
  }

  /// Handles playback completion based on repeat mode.
  static void _handlePlaybackCompleted(String id, AudioPlayerConfig config) {
    final repeatMode = _playerStates[id]?.repeatMode ?? config.repeatMode;

    switch (repeatMode) {
      case AudioRepeatMode.one:
        // Replay the same audio
        seek(id, Duration.zero);
        play(id);
        break;
      case AudioRepeatMode.all:
        // Play next in queue or restart queue
        if (_playQueue.isNotEmpty) {
          playNext();
        }
        break;
      case AudioRepeatMode.none:
        // Stop and reset
        currentAudioMessageId.value = null;
        _currentAudioController.add(null);
        break;
    }
  }

  /// Updates player state and notifies listeners.
  static void _updateState(
    String id, {
    AudioPlaybackState? state,
    int? positionInSeconds,
    int? durationInSeconds,
    double? volume,
    double? speed,
    AudioRepeatMode? repeatMode,
    bool? isBuffering,
    String? errorMessage,
  }) {
    final currentState = _playerStates[id];
    if (currentState == null) return;

    final newState = currentState.copyWith(
      state: state,
      positionInSeconds: positionInSeconds,
      durationInSeconds: durationInSeconds,
      volume: volume,
      speed: speed,
      repeatMode: repeatMode,
      isBuffering: isBuffering,
      errorMessage: errorMessage,
    );

    _playerStates[id] = newState;
    _stateController.add(newState);
  }

  // ============ Playback Controls ============

  /// Plays an audio file.
  static Future<void> play(
    String id, {
    String? filePath,
    String? url,
    AudioPlayerConfig config = AudioPlayerConfig.defaultConfig,
  }) async {
    final audioPlayer = create(id, filePath: filePath, url: url, config: config);

    // Pause any currently playing audio
    pauseCurrentAudio();

    // Update current audio
    currentAudioMessageId.value = id;
    _currentAudioController.add(id);

    await audioPlayer.play();
  }

  /// Pauses an audio player.
  static Future<void> pause(String id) async {
    await _controllers[id]?.pause();
    if (currentAudioMessageId.value == id) {
      currentAudioMessageId.value = null;
      _currentAudioController.add(null);
    }
  }

  /// Stops an audio player and resets position.
  static Future<void> stop(String id) async {
    final controller = _controllers[id];
    if (controller == null) return;

    await controller.stop();
    await controller.seek(Duration.zero);
    _audioPositions.add(id, 0);
    _updateState(id, state: AudioPlaybackState.stopped, positionInSeconds: 0);

    if (currentAudioMessageId.value == id) {
      currentAudioMessageId.value = null;
      _currentAudioController.add(null);
    }
  }

  /// Toggles play/pause for an audio player.
  static Future<void> togglePlayPause(
    String id, {
    String? filePath,
    String? url,
  }) async {
    final state = _playerStates[id];
    if (state?.isPlaying == true) {
      await pause(id);
    } else {
      await play(id, filePath: filePath, url: url);
    }
  }

  /// Pauses the current audio.
  static void pauseCurrentAudio() {
    final currentId = currentAudioMessageId.value;
    if (currentId != null) pause(currentId);
  }

  /// Pauses all currently playing audio.
  static Future<void> pauseAll() async {
    for (final controller in _controllers.values) {
      await controller.pause();
    }
    currentAudioMessageId.value = null;
    _currentAudioController.add(null);
  }

  // ============ Seek Controls ============

  /// Seeks to a specific position.
  static Future<void> seek(String id, Duration position) async {
    await _controllers[id]?.seek(position);
    _audioPositions.add(id, position.inSeconds);
  }

  /// Seeks forward by a specified duration.
  static Future<void> seekForward(String id, {Duration duration = const Duration(seconds: 10)}) async {
    final controller = _controllers[id];
    if (controller == null) return;

    final currentPos = controller.position;
    final totalDuration = controller.duration ?? Duration.zero;
    final newPos = currentPos + duration;

    if (newPos < totalDuration) {
      await seek(id, newPos);
    } else {
      await seek(id, totalDuration);
    }
  }

  /// Seeks backward by a specified duration.
  static Future<void> seekBackward(String id, {Duration duration = const Duration(seconds: 10)}) async {
    final controller = _controllers[id];
    if (controller == null) return;

    final currentPos = controller.position;
    final newPos = currentPos - duration;

    if (newPos > Duration.zero) {
      await seek(id, newPos);
    } else {
      await seek(id, Duration.zero);
    }
  }

  /// Seeks to a percentage of the total duration.
  static Future<void> seekToPercent(String id, double percent) async {
    final controller = _controllers[id];
    if (controller == null) return;

    final totalDuration = controller.duration ?? Duration.zero;
    final newPos = Duration(
      milliseconds: (totalDuration.inMilliseconds * percent.clamp(0.0, 1.0)).round(),
    );
    await seek(id, newPos);
  }

  // ============ Volume Controls ============

  /// Sets volume for a specific player (0.0 - 1.0).
  static Future<void> setVolume(String id, double volume) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    await _controllers[id]?.setVolume(clampedVolume);
    _updateState(id, volume: clampedVolume);
  }

  /// Sets global volume for all players.
  static Future<void> setGlobalVolume(double volume) async {
    _globalVolume = volume.clamp(0.0, 1.0);
    for (final entry in _controllers.entries) {
      await entry.value.setVolume(_globalVolume);
      _updateState(entry.key, volume: _globalVolume);
    }
  }

  /// Mutes a specific player.
  static Future<void> mute(String id) async {
    await setVolume(id, 0.0);
  }

  /// Unmutes a specific player to global volume.
  static Future<void> unmute(String id) async {
    await setVolume(id, _globalVolume);
  }

  // ============ Speed Controls ============

  /// Sets playback speed for a specific player (0.5 - 2.0).
  static Future<void> setSpeed(String id, double speed) async {
    final clampedSpeed = speed.clamp(0.5, 2.0);
    await _controllers[id]?.setSpeed(clampedSpeed);
    _updateState(id, speed: clampedSpeed);
  }

  /// Sets global playback speed for all players.
  static Future<void> setGlobalSpeed(double speed) async {
    _globalSpeed = speed.clamp(0.5, 2.0);
    for (final entry in _controllers.entries) {
      await entry.value.setSpeed(_globalSpeed);
      _updateState(entry.key, speed: _globalSpeed);
    }
  }

  /// Common playback speeds.
  static const List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  // ============ Repeat Mode ============

  /// Sets repeat mode for a specific player.
  static void setRepeatMode(String id, AudioRepeatMode mode) {
    _updateState(id, repeatMode: mode);
  }

  /// Sets global repeat mode.
  static void setGlobalRepeatMode(AudioRepeatMode mode) {
    _globalRepeatMode = mode;
    for (final id in _playerStates.keys) {
      _updateState(id, repeatMode: mode);
    }
  }

  /// Cycles through repeat modes.
  static AudioRepeatMode cycleRepeatMode(String id) {
    final currentMode = _playerStates[id]?.repeatMode ?? AudioRepeatMode.none;
    final nextMode = AudioRepeatMode.values[
        (currentMode.index + 1) % AudioRepeatMode.values.length];
    setRepeatMode(id, nextMode);
    return nextMode;
  }

  // ============ Queue Management ============

  /// Sets the play queue.
  static void setQueue(List<String> queue) {
    _playQueue.clear();
    _playQueue.addAll(queue);
    _currentQueueIndex = queue.isNotEmpty ? 0 : -1;
  }

  /// Adds an item to the queue.
  static void addToQueue(String id) {
    if (!_playQueue.contains(id)) {
      _playQueue.add(id);
    }
  }

  /// Removes an item from the queue.
  static void removeFromQueue(String id) {
    final index = _playQueue.indexOf(id);
    if (index != -1) {
      _playQueue.removeAt(index);
      if (_currentQueueIndex >= index && _currentQueueIndex > 0) {
        _currentQueueIndex--;
      }
    }
  }

  /// Clears the queue.
  static void clearQueue() {
    _playQueue.clear();
    _currentQueueIndex = -1;
  }

  /// Plays the next item in queue.
  static Future<void> playNext() async {
    if (_playQueue.isEmpty) return;

    if (_currentQueueIndex < _playQueue.length - 1) {
      _currentQueueIndex++;
    } else if (_globalRepeatMode == AudioRepeatMode.all) {
      _currentQueueIndex = 0;
    } else {
      return;
    }

    final nextId = _playQueue[_currentQueueIndex];
    await play(nextId);
  }

  /// Plays the previous item in queue.
  static Future<void> playPrevious() async {
    if (_playQueue.isEmpty) return;

    if (_currentQueueIndex > 0) {
      _currentQueueIndex--;
    } else if (_globalRepeatMode == AudioRepeatMode.all) {
      _currentQueueIndex = _playQueue.length - 1;
    } else {
      return;
    }

    final prevId = _playQueue[_currentQueueIndex];
    await play(prevId);
  }

  /// Shuffles the queue.
  static void shuffleQueue() {
    if (_playQueue.length < 2) return;

    final currentId =
        _currentQueueIndex >= 0 ? _playQueue[_currentQueueIndex] : null;
    _playQueue.shuffle();

    if (currentId != null) {
      _currentQueueIndex = _playQueue.indexOf(currentId);
    }
  }

  // ============ Duration Helpers ============

  /// Stores audio duration.
  static void setDuration(String id, int duration) {
    _audioDurationsInSeconds.add(id, duration);
    _updateState(id, durationInSeconds: duration);
  }

  /// Gets the duration for an audio player.
  static int? getDuration(String id) => _audioDurationsInSeconds[id];

  /// Gets the current position for an audio player.
  static int? getPosition(String id) => _audioPositions[id];

  // ============ Cleanup ============

  /// Disposes a specific audio controller.
  static Future<bool> dispose(String id) async {
    // Cancel subscriptions
    final subs = _subscriptions.remove(id);
    if (subs != null) {
      for (final sub in subs) {
        await sub.cancel();
      }
    }

    // Remove controller
    final controller = _controllers.remove(id);
    if (controller == null) return false;

    await controller.pause();
    await controller.dispose();

    // Clean up state
    _audioPositions.remove(id);
    _audioDurationsInSeconds.remove(id);
    _playerStates.remove(id);

    if (currentAudioMessageId.value == id) {
      currentAudioMessageId.value = null;
      _currentAudioController.add(null);
    }

    // Remove from queue
    removeFromQueue(id);

    return true;
  }

  /// Disposes all audio controllers.
  static Future<int> disposeAll() async {
    final count = _controllers.length;

    // Cancel all subscriptions
    for (final subs in _subscriptions.values) {
      for (final sub in subs) {
        await sub.cancel();
      }
    }
    _subscriptions.clear();

    // Dispose all controllers
    for (final controller in _controllers.values) {
      await controller.pause();
      await controller.dispose();
    }
    _controllers.clear();

    // Clear state
    _audioPositions.clear();
    _audioDurationsInSeconds.clear();
    _playerStates.clear();
    currentAudioMessageId.value = null;
    _currentAudioController.add(null);

    // Clear queue
    clearQueue();

    return count;
  }

  /// Disposes the factory's stream controllers.
  /// Call this when the app is closing.
  static Future<void> disposeFactory() async {
    await disposeAll();
    await _stateController.close();
    await _currentAudioController.close();
  }
}

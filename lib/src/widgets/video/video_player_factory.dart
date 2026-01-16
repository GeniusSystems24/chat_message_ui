import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../audio/audio_player_factory.dart';

/// Playback state for video players.
enum VideoPlaybackState {
  /// Video is uninitialized.
  uninitialized,

  /// Video is initializing/loading.
  initializing,

  /// Video is ready but not playing.
  ready,

  /// Video is currently playing.
  playing,

  /// Video is paused.
  paused,

  /// Video is buffering.
  buffering,

  /// Video playback completed.
  completed,

  /// Error occurred during playback.
  error,
}

/// Video quality options.
enum VideoQuality {
  auto,
  low, // 360p
  medium, // 480p
  high, // 720p
  hd, // 1080p
}

/// Video player configuration.
class VideoPlayerConfig {
  /// Initial volume (0.0 - 1.0).
  final double volume;

  /// Initial playback speed (0.5 - 2.0).
  final double speed;

  /// Whether to auto-play when initialized.
  final bool autoPlay;

  /// Whether to loop the video.
  final bool loop;

  /// Whether to show controls.
  final bool showControls;

  /// Whether to allow background audio.
  final bool allowBackgroundAudio;

  const VideoPlayerConfig({
    this.volume = 1.0,
    this.speed = 1.0,
    this.autoPlay = false,
    this.loop = false,
    this.showControls = true,
    this.allowBackgroundAudio = false,
  });

  static const VideoPlayerConfig defaultConfig = VideoPlayerConfig();
}

/// State snapshot for a video player.
class VideoPlayerState {
  /// Unique identifier.
  final String id;

  /// Current playback state.
  final VideoPlaybackState state;

  /// Current position in milliseconds.
  final int positionMs;

  /// Total duration in milliseconds.
  final int durationMs;

  /// Buffered position in milliseconds.
  final int bufferedMs;

  /// Current volume (0.0 - 1.0).
  final double volume;

  /// Current playback speed.
  final double speed;

  /// Whether video is looping.
  final bool isLooping;

  /// Video aspect ratio.
  final double aspectRatio;

  /// Video size.
  final Size? videoSize;

  /// Error message if any.
  final String? errorMessage;

  const VideoPlayerState({
    required this.id,
    this.state = VideoPlaybackState.uninitialized,
    this.positionMs = 0,
    this.durationMs = 0,
    this.bufferedMs = 0,
    this.volume = 1.0,
    this.speed = 1.0,
    this.isLooping = false,
    this.aspectRatio = 16 / 9,
    this.videoSize,
    this.errorMessage,
  });

  /// Progress as a value between 0.0 and 1.0.
  double get progress => durationMs > 0 ? positionMs / durationMs : 0.0;

  /// Buffered progress as a value between 0.0 and 1.0.
  double get bufferedProgress => durationMs > 0 ? bufferedMs / durationMs : 0.0;

  /// Position in seconds.
  int get positionInSeconds => positionMs ~/ 1000;

  /// Duration in seconds.
  int get durationInSeconds => durationMs ~/ 1000;

  /// Whether video is playing.
  bool get isPlaying => state == VideoPlaybackState.playing;

  /// Whether video is paused.
  bool get isPaused => state == VideoPlaybackState.paused;

  /// Whether video is buffering.
  bool get isBuffering => state == VideoPlaybackState.buffering;

  /// Whether video is ready.
  bool get isReady => state == VideoPlaybackState.ready ||
      state == VideoPlaybackState.playing ||
      state == VideoPlaybackState.paused;

  /// Whether video has error.
  bool get hasError => state == VideoPlaybackState.error;

  /// Formatted position string (MM:SS or HH:MM:SS).
  String get formattedPosition => _formatDuration(positionInSeconds);

  /// Formatted duration string (MM:SS or HH:MM:SS).
  String get formattedDuration => _formatDuration(durationInSeconds);

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0:00';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  VideoPlayerState copyWith({
    VideoPlaybackState? state,
    int? positionMs,
    int? durationMs,
    int? bufferedMs,
    double? volume,
    double? speed,
    bool? isLooping,
    double? aspectRatio,
    Size? videoSize,
    String? errorMessage,
  }) {
    return VideoPlayerState(
      id: id,
      state: state ?? this.state,
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      bufferedMs: bufferedMs ?? this.bufferedMs,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      isLooping: isLooping ?? this.isLooping,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      videoSize: videoSize ?? this.videoSize,
      errorMessage: errorMessage,
    );
  }
}

/// Factory class for managing video player controllers and state.
///
/// Provides centralized video playback management with features like:
/// - Play/pause/stop controls
/// - Seek functionality
/// - Volume and speed control
/// - Picture-in-picture support
/// - State notifications via streams
/// - Automatic resource cleanup
class VideoPlayerFactory {
  // Private state
  static final Map<String, VideoPlayerController> _controllers = {};
  static final Map<String, VideoPlayerState> _playerStates = {};
  static final Map<String, List<StreamSubscription>> _subscriptions = {};
  static final Map<String, VideoPlayerConfig> _configs = {};

  // Stream controllers
  static final StreamController<VideoPlayerState> _stateController =
      StreamController<VideoPlayerState>.broadcast();
  static final StreamController<String?> _currentVideoController =
      StreamController<String?>.broadcast();

  // Current video tracking
  static final ValueNotifier<String?> currentVideoId = ValueNotifier(null);

  // Global settings
  static double _globalVolume = 1.0;
  static double _globalSpeed = 1.0;
  static bool _globalMuted = false;

  // ============ Getters ============

  /// Stream of video player state changes.
  static Stream<VideoPlayerState> get stateStream => _stateController.stream;

  /// Stream of current video ID changes.
  static Stream<String?> get currentVideoStream =>
      _currentVideoController.stream;

  /// Gets all active video controllers.
  static Map<String, VideoPlayerController> get controllers =>
      Map.unmodifiable(_controllers);

  /// Gets the count of active controllers.
  static int get controllersCount => _controllers.length;

  /// Gets global volume setting.
  static double get globalVolume => _globalVolume;

  /// Gets global speed setting.
  static double get globalSpeed => _globalSpeed;

  /// Gets global muted state.
  static bool get globalMuted => _globalMuted;

  /// Gets the state for a specific video player.
  static VideoPlayerState? getState(String id) => _playerStates[id];

  /// Gets the controller for a specific video.
  static VideoPlayerController? getController(String id) => _controllers[id];

  /// Checks if a video is initialized.
  static bool isInitialized(String id) =>
      _controllers[id]?.value.isInitialized ?? false;

  // ============ Core Methods ============

  /// Creates and initializes a video player.
  static Future<VideoPlayerController?> create(
    String id, {
    String? filePath,
    String? url,
    VideoPlayerConfig config = VideoPlayerConfig.defaultConfig,
  }) async {
    // Return existing controller if already created
    if (_controllers.containsKey(id)) {
      return _controllers[id];
    }

    // Initialize state
    _playerStates[id] = VideoPlayerState(
      id: id,
      state: VideoPlaybackState.initializing,
      volume: config.volume,
      speed: config.speed,
      isLooping: config.loop,
    );
    _configs[id] = config;
    _notifyStateChange(id);

    try {
      VideoPlayerController controller;

      if (filePath != null) {
        controller = VideoPlayerController.file(File(filePath));
      } else if (url != null) {
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        _updateState(id, state: VideoPlaybackState.error, errorMessage: 'No video source provided');
        return null;
      }

      _controllers[id] = controller;

      // Initialize controller
      await controller.initialize();

      // Apply config
      await controller.setVolume(_globalMuted ? 0.0 : config.volume);
      await controller.setPlaybackSpeed(config.speed);
      await controller.setLooping(config.loop);

      // Setup listeners
      _setupListeners(id, controller);

      // Update state with video info
      _updateState(
        id,
        state: VideoPlaybackState.ready,
        durationMs: controller.value.duration.inMilliseconds,
        aspectRatio: controller.value.aspectRatio,
        videoSize: controller.value.size,
      );

      // Auto-play if configured
      if (config.autoPlay) {
        await play(id);
      }

      return controller;
    } catch (e) {
      _updateState(
        id,
        state: VideoPlaybackState.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Sets up listeners for a video controller.
  static void _setupListeners(String id, VideoPlayerController controller) {
    final subs = <StreamSubscription>[];

    // Listen to controller changes
    void listener() {
      final value = controller.value;

      VideoPlaybackState state;
      if (value.hasError) {
        state = VideoPlaybackState.error;
      } else if (!value.isInitialized) {
        state = VideoPlaybackState.uninitialized;
      } else if (value.isBuffering) {
        state = VideoPlaybackState.buffering;
      } else if (value.isPlaying) {
        state = VideoPlaybackState.playing;
      } else if (value.position >= value.duration && value.duration > Duration.zero) {
        state = VideoPlaybackState.completed;
      } else {
        state = VideoPlaybackState.paused;
      }

      _updateState(
        id,
        state: state,
        positionMs: value.position.inMilliseconds,
        durationMs: value.duration.inMilliseconds,
        bufferedMs: value.buffered.isNotEmpty
            ? value.buffered.last.end.inMilliseconds
            : 0,
        errorMessage: value.errorDescription,
      );
    }

    controller.addListener(listener);

    // Store cleanup function
    _subscriptions[id] = subs;
  }

  /// Updates player state and notifies listeners.
  static void _updateState(
    String id, {
    VideoPlaybackState? state,
    int? positionMs,
    int? durationMs,
    int? bufferedMs,
    double? volume,
    double? speed,
    bool? isLooping,
    double? aspectRatio,
    Size? videoSize,
    String? errorMessage,
  }) {
    final currentState = _playerStates[id];
    if (currentState == null) return;

    final newState = currentState.copyWith(
      state: state,
      positionMs: positionMs,
      durationMs: durationMs,
      bufferedMs: bufferedMs,
      volume: volume,
      speed: speed,
      isLooping: isLooping,
      aspectRatio: aspectRatio,
      videoSize: videoSize,
      errorMessage: errorMessage,
    );

    _playerStates[id] = newState;
    _stateController.add(newState);
  }

  /// Notifies state change.
  static void _notifyStateChange(String id) {
    final state = _playerStates[id];
    if (state != null) {
      _stateController.add(state);
    }
  }

  // ============ Playback Controls ============

  /// Plays a video.
  ///
  /// This will automatically:
  /// - Pause any currently playing audio
  /// - Pause any other playing video
  static Future<void> play(String id, {String? filePath, String? url}) async {
    var controller = _controllers[id];

    if (controller == null) {
      controller = await create(id, filePath: filePath, url: url);
      if (controller == null) return;
    }

    // Pause all currently playing audio
    await AudioPlayerFactory.pauseAll();

    // Pause current video if different
    if (currentVideoId.value != null && currentVideoId.value != id) {
      await pause(currentVideoId.value!);
    }

    currentVideoId.value = id;
    _currentVideoController.add(id);

    await controller.play();
  }

  /// Pauses a video.
  static Future<void> pause(String id) async {
    await _controllers[id]?.pause();
  }

  /// Stops a video and resets position.
  static Future<void> stop(String id) async {
    final controller = _controllers[id];
    if (controller == null) return;

    await controller.pause();
    await controller.seekTo(Duration.zero);
    _updateState(id, positionMs: 0);

    if (currentVideoId.value == id) {
      currentVideoId.value = null;
      _currentVideoController.add(null);
    }
  }

  /// Toggles play/pause.
  static Future<void> togglePlayPause(String id, {String? filePath, String? url}) async {
    final state = _playerStates[id];
    if (state?.isPlaying == true) {
      await pause(id);
    } else {
      await play(id, filePath: filePath, url: url);
    }
  }

  /// Pauses all videos.
  static Future<void> pauseAll() async {
    for (final controller in _controllers.values) {
      await controller.pause();
    }
    currentVideoId.value = null;
    _currentVideoController.add(null);
  }

  // ============ Seek Controls ============

  /// Seeks to a specific position.
  static Future<void> seek(String id, Duration position) async {
    await _controllers[id]?.seekTo(position);
  }

  /// Seeks forward by duration.
  static Future<void> seekForward(String id, {Duration duration = const Duration(seconds: 10)}) async {
    final controller = _controllers[id];
    if (controller == null) return;

    final currentPos = controller.value.position;
    final totalDuration = controller.value.duration;
    final newPos = currentPos + duration;

    await seek(id, newPos < totalDuration ? newPos : totalDuration);
  }

  /// Seeks backward by duration.
  static Future<void> seekBackward(String id, {Duration duration = const Duration(seconds: 10)}) async {
    final controller = _controllers[id];
    if (controller == null) return;

    final currentPos = controller.value.position;
    final newPos = currentPos - duration;

    await seek(id, newPos > Duration.zero ? newPos : Duration.zero);
  }

  /// Seeks to a percentage.
  static Future<void> seekToPercent(String id, double percent) async {
    final controller = _controllers[id];
    if (controller == null) return;

    final duration = controller.value.duration;
    final position = Duration(
      milliseconds: (duration.inMilliseconds * percent.clamp(0.0, 1.0)).round(),
    );
    await seek(id, position);
  }

  // ============ Volume Controls ============

  /// Sets volume for a specific player.
  static Future<void> setVolume(String id, double volume) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    await _controllers[id]?.setVolume(clampedVolume);
    _updateState(id, volume: clampedVolume);
  }

  /// Sets global volume.
  static Future<void> setGlobalVolume(double volume) async {
    _globalVolume = volume.clamp(0.0, 1.0);
    for (final entry in _controllers.entries) {
      await entry.value.setVolume(_globalMuted ? 0.0 : _globalVolume);
      _updateState(entry.key, volume: _globalVolume);
    }
  }

  /// Mutes all players.
  static Future<void> mute() async {
    _globalMuted = true;
    for (final controller in _controllers.values) {
      await controller.setVolume(0.0);
    }
  }

  /// Unmutes all players.
  static Future<void> unmute() async {
    _globalMuted = false;
    for (final entry in _controllers.entries) {
      final config = _configs[entry.key];
      await entry.value.setVolume(config?.volume ?? _globalVolume);
    }
  }

  /// Toggles mute state.
  static Future<void> toggleMute() async {
    if (_globalMuted) {
      await unmute();
    } else {
      await mute();
    }
  }

  // ============ Speed Controls ============

  /// Sets playback speed for a specific player.
  static Future<void> setSpeed(String id, double speed) async {
    final clampedSpeed = speed.clamp(0.25, 2.0);
    await _controllers[id]?.setPlaybackSpeed(clampedSpeed);
    _updateState(id, speed: clampedSpeed);
  }

  /// Sets global playback speed.
  static Future<void> setGlobalSpeed(double speed) async {
    _globalSpeed = speed.clamp(0.25, 2.0);
    for (final entry in _controllers.entries) {
      await entry.value.setPlaybackSpeed(_globalSpeed);
      _updateState(entry.key, speed: _globalSpeed);
    }
  }

  /// Available playback speeds.
  static const List<double> availableSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  // ============ Loop Control ============

  /// Sets looping for a specific player.
  static Future<void> setLooping(String id, bool loop) async {
    await _controllers[id]?.setLooping(loop);
    _updateState(id, isLooping: loop);
  }

  /// Toggles looping.
  static Future<void> toggleLooping(String id) async {
    final currentState = _playerStates[id];
    if (currentState != null) {
      await setLooping(id, !currentState.isLooping);
    }
  }

  // ============ Cleanup ============

  /// Disposes a specific video controller.
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
    _playerStates.remove(id);
    _configs.remove(id);

    if (currentVideoId.value == id) {
      currentVideoId.value = null;
      _currentVideoController.add(null);
    }

    return true;
  }

  /// Disposes all video controllers.
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
    _playerStates.clear();
    _configs.clear();
    currentVideoId.value = null;
    _currentVideoController.add(null);

    return count;
  }

  /// Disposes factory stream controllers.
  static Future<void> disposeFactory() async {
    await disposeAll();
    await _stateController.close();
    await _currentVideoController.close();
  }

  // ============ Utility Methods ============

  /// Preloads a video without playing.
  static Future<bool> preload(String id, {String? filePath, String? url}) async {
    final controller = await create(id, filePath: filePath, url: url);
    return controller != null;
  }

  /// Gets video thumbnail at specific position.
  static Future<void> seekToThumbnail(String id, Duration position) async {
    final controller = _controllers[id];
    if (controller == null || !controller.value.isInitialized) return;

    await controller.seekTo(position);
    await controller.pause();
  }
}

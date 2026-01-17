import 'dart:async';

import 'package:flutter/foundation.dart';

import '../audio/audio_player_factory.dart';
import '../video/video_player_factory.dart';

/// Type of media currently playing.
enum MediaType {
  /// No media playing.
  none,

  /// Audio is playing.
  audio,

  /// Video is playing.
  video,
}

/// State of the current media playback.
class MediaPlaybackState {
  /// Type of media currently active.
  final MediaType type;

  /// ID of the currently playing media.
  final String? mediaId;

  /// Whether media is currently playing.
  final bool isPlaying;

  const MediaPlaybackState({
    this.type = MediaType.none,
    this.mediaId,
    this.isPlaying = false,
  });

  MediaPlaybackState copyWith({
    MediaType? type,
    String? mediaId,
    bool? isPlaying,
  }) {
    return MediaPlaybackState(
      type: type ?? this.type,
      mediaId: mediaId ?? this.mediaId,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  String toString() =>
      'MediaPlaybackState(type: $type, mediaId: $mediaId, isPlaying: $isPlaying)';
}

/// Centralized media playback manager.
///
/// Coordinates between audio and video playback to ensure:
/// - Only one media plays at a time
/// - When video starts, all audio stops
/// - When audio starts, all videos pause
/// - Proper resource cleanup
class MediaPlaybackManager {
  MediaPlaybackManager._();

  static final MediaPlaybackManager _instance = MediaPlaybackManager._();

  /// Singleton instance of the media playback manager.
  static MediaPlaybackManager get instance => _instance;

  // Current state
  final ValueNotifier<MediaPlaybackState> _stateNotifier =
      ValueNotifier(const MediaPlaybackState());

  // Stream controller for state changes
  final StreamController<MediaPlaybackState> _stateController =
      StreamController<MediaPlaybackState>.broadcast();

  // Listeners for audio and video state changes
  StreamSubscription? _audioSubscription;
  StreamSubscription? _videoSubscription;
  bool _isInitialized = false;

  /// Current playback state notifier.
  ValueNotifier<MediaPlaybackState> get stateNotifier => _stateNotifier;

  /// Current playback state.
  MediaPlaybackState get state => _stateNotifier.value;

  /// Stream of playback state changes.
  Stream<MediaPlaybackState> get stateStream => _stateController.stream;

  /// Currently playing media type.
  MediaType get currentMediaType => _stateNotifier.value.type;

  /// Currently playing media ID.
  String? get currentMediaId => _stateNotifier.value.mediaId;

  /// Whether any media is currently playing.
  bool get isPlaying => _stateNotifier.value.isPlaying;

  /// Whether audio is currently playing.
  bool get isAudioPlaying => _stateNotifier.value.type == MediaType.audio;

  /// Whether video is currently playing.
  bool get isVideoPlaying => _stateNotifier.value.type == MediaType.video;

  /// Initializes the manager and sets up listeners.
  void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;

    // Listen to audio player changes
    _audioSubscription = AudioPlayerFactory.stateStream.listen((audioState) {
      if (audioState.isPlaying) {
        _updateState(MediaPlaybackState(
          type: MediaType.audio,
          mediaId: audioState.id,
          isPlaying: true,
        ));
      } else if (_stateNotifier.value.type == MediaType.audio &&
          _stateNotifier.value.mediaId == audioState.id) {
        _updateState(const MediaPlaybackState(
          type: MediaType.none,
          mediaId: null,
          isPlaying: false,
        ));
      }
    });

    // Listen to video player changes
    _videoSubscription = VideoPlayerFactory.stateStream.listen((videoState) {
      if (videoState.isPlaying) {
        _updateState(MediaPlaybackState(
          type: MediaType.video,
          mediaId: videoState.id,
          isPlaying: true,
        ));
      } else if (_stateNotifier.value.type == MediaType.video &&
          _stateNotifier.value.mediaId == videoState.id) {
        _updateState(const MediaPlaybackState(
          type: MediaType.none,
          mediaId: null,
          isPlaying: false,
        ));
      }
    });
  }

  /// Updates the playback state and notifies listeners.
  void _updateState(MediaPlaybackState newState) {
    if (_stateNotifier.value.type != newState.type ||
        _stateNotifier.value.mediaId != newState.mediaId ||
        _stateNotifier.value.isPlaying != newState.isPlaying) {
      _stateNotifier.value = newState;
      _stateController.add(newState);
    }
  }

  /// Plays audio, pausing any currently playing video.
  Future<void> playAudio(
    String id, {
    String? filePath,
    String? url,
  }) async {
    // Pause any playing video first
    await pauseAllVideos();

    // Play the audio
    await AudioPlayerFactory.play(id, filePath: filePath, url: url);
  }

  /// Plays video, pausing any currently playing audio or video.
  Future<void> playVideo(
    String id, {
    String? filePath,
    String? url,
  }) async {
    // Pause all other media first
    await pauseAll();

    // Play the video
    await VideoPlayerFactory.play(id, filePath: filePath, url: url);
  }

  /// Pauses the currently playing audio.
  Future<void> pauseAudio(String id) async {
    await AudioPlayerFactory.pause(id);
  }

  /// Pauses the currently playing video.
  Future<void> pauseVideo(String id) async {
    await VideoPlayerFactory.pause(id);
  }

  /// Pauses all currently playing audio.
  Future<void> pauseAllAudio() async {
    await AudioPlayerFactory.pauseAll();
  }

  /// Pauses all currently playing videos.
  Future<void> pauseAllVideos() async {
    await VideoPlayerFactory.pauseAll();
  }

  /// Pauses all media (audio and video).
  Future<void> pauseAll() async {
    await Future.wait([
      pauseAllAudio(),
      pauseAllVideos(),
    ]);

    _updateState(const MediaPlaybackState(
      type: MediaType.none,
      mediaId: null,
      isPlaying: false,
    ));
  }

  /// Stops all media and cleans up resources.
  Future<void> stopAll() async {
    // Stop all audio
    final currentAudioId = AudioPlayerFactory.currentAudioMessageId.value;
    if (currentAudioId != null) {
      await AudioPlayerFactory.stop(currentAudioId);
    }

    // Stop all video
    final currentVideoId = VideoPlayerFactory.currentVideoId.value;
    if (currentVideoId != null) {
      await VideoPlayerFactory.stop(currentVideoId);
    }

    _updateState(const MediaPlaybackState(
      type: MediaType.none,
      mediaId: null,
      isPlaying: false,
    ));
  }

  /// Toggles play/pause for audio.
  Future<void> toggleAudio(
    String id, {
    String? filePath,
    String? url,
  }) async {
    final audioState = AudioPlayerFactory.getState(id);
    if (audioState?.isPlaying == true) {
      await pauseAudio(id);
    } else {
      await playAudio(id, filePath: filePath, url: url);
    }
  }

  /// Toggles play/pause for video.
  Future<void> toggleVideo(
    String id, {
    String? filePath,
    String? url,
  }) async {
    final videoState = VideoPlayerFactory.getState(id);
    if (videoState?.isPlaying == true) {
      await pauseVideo(id);
    } else {
      await playVideo(id, filePath: filePath, url: url);
    }
  }

  /// Disposes resources and cleans up.
  Future<void> dispose() async {
    await _audioSubscription?.cancel();
    await _videoSubscription?.cancel();
    await _stateController.close();
    _isInitialized = false;
  }
}

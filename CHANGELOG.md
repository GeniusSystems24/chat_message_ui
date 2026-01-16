# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- ChatScreen input callbacks for audio recording lifecycle, polling requests,
  and suggestion providers.
- Selection action callbacks for reply, copy, forward, and message info.
- Optional pinned messages region below the app bar with WhatsApp-style bar.
- `PinnedMessagesBar` widget and pinned list cycling with `onScrollToMessage`.
- Message grouping configuration (mode + timeout) in pagination config.
- Poll bubble rendering support in attachment builder with vote callbacks.
- New `MediaPlaybackManager` for centralized audio/video playback coordination.
  - Ensures only one media (audio or video) plays at a time.
  - Automatically pauses audio when video starts and vice versa.
  - Provides unified API for controlling all media playback.
- Inline video player in `VideoBubble` with native controls overlay.
  - Interactive progress bar with seek functionality.
  - Auto-hiding controls overlay.
  - Full-screen mode with gesture controls.

### Changed

- ChatScreen default selection app bar now exposes reply/copy/forward/info hooks.
- Video bubble supports network streaming when local file is unavailable.
- Video thumbnails fall back to a default placeholder when none is provided.
- Video thumbnail file path handling now avoids passing remote URLs as files.
- Example screens refreshed with pinned messages, grouping configuration,
  and new input callbacks.
- `VideoBubble` now uses `VideoPlayerFactory` for state management instead of
  direct Chewie controller management.
- `VideoPlayerFactory.play()` now automatically pauses all playing audio.
- `AudioPlayerFactory.play()` now automatically pauses all playing videos.
- Improved video controls with animated play/pause button.
- Enhanced full-screen video player with buffering indicator.

### Fixed

- Recording callbacks now forward waveform data consistently.
- Fixed video player resource cleanup on widget disposal.
- Fixed state synchronization between inline and full-screen video players.

## [1.2.0] - 2026-01-15

### Added

- TransferKit bridge initialization helpers and a shared transfer controller
  for cache-first media downloads and upload task handling.
- Configurable auto-download policies per media type with defaults
  (image/video/document: never, audio: always).
- Cache-first download flows in image, video, audio, and document bubbles
  with TransferKit download cards and local file open support.
- `ChatMediaData.metadata` support with fallback getters for file details
  (file name, size, duration, aspect ratio, thumbnail, waveform, page count).
- `ChatMessageUiConfig` with global defaults and per-screen overrides for
  suggestions, text preview, pagination, and bubble theme.
- TooltipCard-driven floating suggestions anchored to the input row with a
  unified payload builder.

### Changed

- Suggestion rendering now uses a single TooltipCard around the input row.
- `ChatScreen` accepts optional UI configuration and forwards settings to
  input and message list widgets.

## [1.1.0] - 2026-01-15

### Added

- Real-time waveform visualization during audio recording
  - `RecordingWaveform` widget for live amplitude display
  - `LockedRecordingWaveform` widget for locked recording state
  - Animated pulse effect on recent waveform bars
- Waveform data capture and callback support
  - `onRecordingComplete` now includes optional `waveform` parameter
  - Recorded amplitudes can be stored and displayed in audio bubbles
- Enhanced `AudioPlayerFactory` with advanced controls
  - Playback speed control (0.5x - 2.0x)
  - Volume control
  - Repeat mode (none, one, all)
  - Shuffle support for playlists
  - Queue management for sequential playback
  - Stream-based state notifications
  - Playback state tracking (playing, paused, stopped, loading)
- New configuration options for `WhatsAppVoiceRecorder`
  - `waveformColor` - customize waveform bar color
  - `showWaveform` - toggle waveform visibility
- Enhanced `AudioBubble` widget
  - Custom waveform data support via `waveformData` parameter
  - Playback speed control button (optional)
  - Animated loading indicator with rotating ring
  - Smooth play/pause icon transitions with scale animation
  - Glow effect on play button when playing
  - File size display
  - Custom primary color support
- Enhanced `ImageBubble` widget
  - Shimmer loading placeholder animation
  - Blurred thumbnail preview while loading
  - Download progress indicator with percentage
  - Tap animation feedback (scale effect)
  - File size overlay (optional)
  - Gallery indicator for multiple images
  - Long press callback support
- Enhanced `ImageViewerFullScreen`
  - Double-tap to zoom in/out
  - Swipe down to dismiss with fade effect
  - Tap to toggle controls visibility
  - File name and size display in top bar
  - Share and download action buttons
  - Loading progress with percentage
- New `VideoPlayerFactory` for centralized video management
  - `VideoPlaybackState` enum for tracking playback state
  - `VideoQuality` enum for quality selection
  - `VideoPlayerConfig` class for configuration options
  - `VideoPlayerState` class with state snapshot and helpers
  - Play/pause/stop/togglePlayPause controls
  - Seek controls (seek, seekForward, seekBackward, seekToPercent)
  - Volume controls (setVolume, setGlobalVolume, mute, unmute, toggleMute)
  - Speed controls (setSpeed, setGlobalSpeed) with 0.25x - 2.0x range
  - Loop control (setLooping, toggleLooping)
  - Stream-based state notifications
  - Preload support for buffering
  - Automatic resource cleanup
- Enhanced `VideoBubble` widget
  - Shimmer loading placeholder animation
  - Blurred thumbnail preview while loading
  - Buffering progress indicator with percentage
  - Tap animation feedback (scale effect)
  - Mini player inline option (`showMiniPlayer`)
  - Auto-play support (`autoPlay`)
  - Muted by default option (`muted`)
  - Play/pause/long press callbacks
  - Enhanced full-screen player with controls toggle
  - Top bar with title and close button
  - Bottom actions bar with share/download buttons
  - Gradient overlays for better UI contrast
  - Video info chips (duration, file size)

### Changed

- Improved duration formatting with proper zero-padding (MM:SS format)
- Enhanced locked recording UI with full waveform history display
- Better resource cleanup in voice recorder
- Improved image loading with frame-based animation
- Better error states with rounded icons

### Fixed

- Added `mounted` check before setState in async callbacks
- Proper cleanup of amplitude stream subscriptions

## [1.0.0] - Initial Release

### Added

- Complete chat UI library with support for multiple message types
- Audio playback with waveform visualization
- WhatsApp-style voice recording with lock, pause, and cancel features
- Image and video message bubbles
- Document sharing support
- Location sharing
- Contact sharing
- Poll/voting messages
- Reply message preview
- Floating suggestions (mentions, hashtags, quick replies)
- Text data preview (links, emails, phone numbers)
- Customizable theming system
- RTL language support

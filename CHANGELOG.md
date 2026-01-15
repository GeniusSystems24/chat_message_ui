# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

### Changed
- Improved duration formatting with proper zero-padding (MM:SS format)
- Enhanced locked recording UI with full waveform history display
- Better resource cleanup in voice recorder

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

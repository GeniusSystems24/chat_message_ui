import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing all AudioBubble features and properties.
class AudioBubbleExample extends StatelessWidget {
  const AudioBubbleExample({super.key});

  static const String _sampleAudioUrl =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/WhatsApp%20Ptt%202026-01-06%20at%2019.11.56.mp3?alt=media&token=8bc5b4c3-d4d1-4fb5-a207-63f0744079b1';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'AudioBubble',
      subtitle: 'Audio player widget with waveform',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.audiotrack_outlined,
            lines: [
              'Highlights voice and audio playback with waveforms.',
              'Covers speed controls, duration labels, and file sizes.',
              'Validates styling for both voice notes and audio files.',
            ],
          ),
          const SizedBox(height: 16),
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Play audio with waveform visualization and controls',
            icon: Icons.audiotrack_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Audio Player
          DemoContainer(
            title: 'Basic Voice Message',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_1',
                duration: 24,
              ),
              isVoiceMessage: true,
            ),
          ),
          const SizedBox(height: 24),

          // With Speed Control
          const ExampleSectionHeader(
            title: 'Speed Control',
            description: 'Playback speed adjustment (0.5x to 2x)',
            icon: Icons.speed_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'showSpeedControl: true',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_2',
                duration: 45,
              ),
              showSpeedControl: true,
              isVoiceMessage: true,
            ),
          ),
          const SizedBox(height: 24),

          // Music Mode
          const ExampleSectionHeader(
            title: 'Audio Types',
            description: 'Voice message vs music/audio file mode',
            icon: Icons.music_note_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Voice Message (isVoiceMessage: true)',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_3',
                duration: 30,
              ),
              isVoiceMessage: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Audio File (isVoiceMessage: false)',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_4',
                duration: 180,
                fileSize: 3145728,
              ),
              isVoiceMessage: false,
              showSpeedControl: true,
            ),
          ),
          const SizedBox(height: 24),

          // Custom Colors
          const ExampleSectionHeader(
            title: 'Custom Colors',
            description: 'Customize the player accent color',
            icon: Icons.palette_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Primary Color: Purple',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_5',
                duration: 20,
              ),
              primaryColor: Colors.purple,
              isVoiceMessage: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Primary Color: Teal',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_6',
                duration: 35,
              ),
              primaryColor: Colors.teal,
              isVoiceMessage: true,
              showSpeedControl: true,
            ),
          ),
          const SizedBox(height: 24),

          // With File Size
          const ExampleSectionHeader(
            title: 'File Size Display',
            description: 'Shows file size below the waveform',
            icon: Icons.storage_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'With File Size',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_7',
                duration: 60,
                fileSize: 1048576, // 1 MB
              ),
              isVoiceMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // Different Durations
          const ExampleSectionHeader(
            title: 'Duration Variations',
            description: 'Waveform adapts to different durations',
            icon: Icons.timer_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Short (10 seconds)',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_8',
                duration: 10,
              ),
              isVoiceMessage: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Medium (60 seconds)',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_9',
                duration: 60,
              ),
              isVoiceMessage: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Long (5 minutes)',
            child: AudioBubble(
              message: _createAudioMessage(
                id: 'audio_10',
                duration: 300,
              ),
              isVoiceMessage: true,
              showSpeedControl: true,
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available AudioBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'Message data with audio URL and duration',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isVoiceMessage',
            value: 'bool (default: true)',
            description: 'Shows mic icon for voice, music note for audio',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showSpeedControl',
            value: 'bool (default: false)',
            description: 'Enable playback speed control button',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'primaryColor',
            value: 'Color?',
            description: 'Custom accent color for the player',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'waveformData',
            value: 'List<double>?',
            description: 'Custom waveform data points',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'filePath',
            value: 'String?',
            description: 'Local file path (overrides URL)',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''AudioBubble(
  message: message,
  isVoiceMessage: true,
  showSpeedControl: true,
  primaryColor: Colors.blue,
  waveformData: [0.2, 0.5, 0.8, 0.3, ...],
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createAudioMessage({
    required String id,
    required int duration,
    int fileSize = 0,
  }) {
    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: 'user_1',
      type: ChatMessageType.audio,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
      mediaData: ChatMediaData(
        url: _sampleAudioUrl,
        mediaType: ChatMessageType.audio,
        duration: duration,
        fileSize: fileSize,
      ),
    );
  }
}

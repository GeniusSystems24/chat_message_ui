import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing all VideoBubble features and properties.
class VideoBubbleExample extends StatelessWidget {
  const VideoBubbleExample({super.key});

  static const String _sampleVideoUrl =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/What%20are%20Chatbots-.mp4?alt=media&token=68b7385c-8394-48d3-9ac3-2b26b22abb1d';

  static const String _sampleThumbnailUrl =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/primary_sys%2F%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AC%D8%A7%D8%AA%2F125.jpg?alt=media&token=a3694a14-7774-411d-aeee-7d9ccaa732c5';

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.light();

    return ExampleScaffold(
      title: 'VideoBubble',
      subtitle: 'Video player widget with thumbnail',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.videocam_outlined,
            lines: [
              'Demonstrates inline video playback with thumbnails.',
              'Shows duration, file size, and aspect ratio handling.',
              'Validates mini player and full-screen behaviors.',
            ],
          ),
          const SizedBox(height: 16),
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Play videos inline or full-screen with Chewie integration',
            icon: Icons.videocam_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Video
          DemoContainer(
            title: 'Basic Video with Thumbnail',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_1',
                    duration: 90,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // With Duration and Size
          const ExampleSectionHeader(
            title: 'Video Info Overlay',
            description: 'Duration and file size badges',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Duration & File Size',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_2',
                    duration: 180,
                    fileSize: 15728640, // 15 MB
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Different Aspect Ratios
          const ExampleSectionHeader(
            title: 'Aspect Ratios',
            description: 'VideoBubble adapts to video dimensions',
            icon: Icons.aspect_ratio_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Wide Video (16:9)',
            child: Center(
              child: SizedBox(
                width: 320,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_3',
                    duration: 60,
                    aspectRatio: 16 / 9,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Square Video (1:1)',
            child: Center(
              child: SizedBox(
                width: 250,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_4',
                    duration: 45,
                    aspectRatio: 1.0,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Portrait Video (9:16)',
            child: Center(
              child: SizedBox(
                width: 180,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_5',
                    duration: 30,
                    aspectRatio: 9 / 16,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Mini Player Mode
          const ExampleSectionHeader(
            title: 'Player Modes',
            description: 'Inline mini player or tap for full-screen',
            icon: Icons.play_circle_outline,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Default (Tap to Play)',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_6',
                    duration: 120,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                  showMiniPlayer: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Mini Player Mode',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_7',
                    duration: 90,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: true,
                  showMiniPlayer: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available VideoBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'Message data with video URL and metadata',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'chatTheme',
            value: 'ChatThemeData',
            description: 'Theme configuration for styling',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isMyMessage',
            value: 'bool',
            description: 'Whether the message is from current user',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showMiniPlayer',
            value: 'bool (default: false)',
            description: 'Play video inline instead of full-screen',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'autoPlay',
            value: 'bool (default: false)',
            description: 'Start playing automatically',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'muted',
            value: 'bool (default: false)',
            description: 'Start muted by default',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onPlay',
            value: 'VoidCallback?',
            description: 'Called when video starts playing',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onPause',
            value: 'VoidCallback?',
            description: 'Called when video is paused',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''VideoBubble(
  message: message,
  chatTheme: ChatThemeData.light(),
  isMyMessage: false,
  showMiniPlayer: true,
  autoPlay: false,
  muted: false,
  onPlay: () => print('Playing'),
  onPause: () => print('Paused'),
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createVideoMessage({
    required String id,
    required int duration,
    double aspectRatio = 16 / 9,
    int fileSize = 0,
  }) {
    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: 'user_1',
      type: ChatMessageType.video,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
      mediaData: ChatMediaData(
        url: _sampleVideoUrl,
        thumbnailUrl: _sampleThumbnailUrl,
        mediaType: ChatMessageType.video,
        duration: duration,
        aspectRatio: aspectRatio,
        fileSize: fileSize,
      ),
    );
  }
}

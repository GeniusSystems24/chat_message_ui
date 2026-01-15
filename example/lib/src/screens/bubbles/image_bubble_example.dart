import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing all ImageBubble features and properties.
class ImageBubbleExample extends StatelessWidget {
  const ImageBubbleExample({super.key});

  static const String _sampleImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/operation.png?alt=media&token=6e1d3457-f2f3-43db-bcf3-70332e19d298';

  static const String _sampleImageUrl2 =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/primary_sys%2F%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AC%D8%A7%D8%AA%2F125.jpg?alt=media&token=a3694a14-7774-411d-aeee-7d9ccaa732c5';

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.light();

    return ExampleScaffold(
      title: 'ImageBubble',
      subtitle: 'Image message display widget',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Display images with loading states, zoom, and gallery support',
            icon: Icons.image_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Image
          DemoContainer(
            title: 'Basic Image',
            child: Center(
              child: ImageBubble(
                message: _createImageMessage(
                  id: 'img_1',
                  url: _sampleImageUrl,
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // With File Size Overlay
          const ExampleSectionHeader(
            title: 'File Size Overlay',
            description: 'Shows file size badge on the image',
            icon: Icons.storage_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'showFileSize: true',
            child: Center(
              child: ImageBubble(
                message: _createImageMessage(
                  id: 'img_2',
                  url: _sampleImageUrl,
                  fileSize: 2457600,
                ),
                chatTheme: chatTheme,
                isMyMessage: true,
                showFileSize: true,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Gallery Mode
          const ExampleSectionHeader(
            title: 'Gallery Mode',
            description: 'Multiple images indicator for galleries',
            icon: Icons.photo_library_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Gallery Indicator (3 images)',
            child: Center(
              child: ImageBubble(
                message: _createImageMessage(
                  id: 'img_3',
                  url: _sampleImageUrl2,
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
                galleryCount: 3,
                galleryIndex: 0,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Different Aspect Ratios
          const ExampleSectionHeader(
            title: 'Aspect Ratios',
            description: 'ImageBubble adapts to different image dimensions',
            icon: Icons.aspect_ratio_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Wide Image (aspectRatio: 1.6)',
            child: Center(
              child: SizedBox(
                width: 300,
                child: ImageBubble(
                  message: _createImageMessage(
                    id: 'img_4',
                    url: _sampleImageUrl,
                    aspectRatio: 1.6,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Square Image (aspectRatio: 1.0)',
            child: Center(
              child: SizedBox(
                width: 200,
                child: ImageBubble(
                  message: _createImageMessage(
                    id: 'img_5',
                    url: _sampleImageUrl2,
                    aspectRatio: 1.0,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // With Progress Indicator
          const ExampleSectionHeader(
            title: 'Loading States',
            description: 'Progress indicator during image download',
            icon: Icons.downloading_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Progress Indicator',
            child: Center(
              child: ImageBubble(
                message: _createImageMessage(
                  id: 'img_6',
                  url: _sampleImageUrl,
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
                showProgress: true,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available ImageBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'Message data containing image URL',
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
            property: 'showFileSize',
            value: 'bool (default: false)',
            description: 'Show file size overlay badge',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showProgress',
            value: 'bool (default: true)',
            description: 'Show download progress indicator',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'galleryCount',
            value: 'int (default: 1)',
            description: 'Total images in gallery',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'galleryIndex',
            value: 'int (default: 0)',
            description: 'Current image index in gallery',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onTap',
            value: 'VoidCallback?',
            description: 'Custom tap handler',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onLongPress',
            value: 'VoidCallback?',
            description: 'Long press handler',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''ImageBubble(
  message: message,
  chatTheme: ChatThemeData.light(),
  isMyMessage: false,
  showFileSize: true,
  showProgress: true,
  galleryCount: 3,
  galleryIndex: 0,
  onTap: () => showFullScreen(),
  onLongPress: () => showOptions(),
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createImageMessage({
    required String id,
    required String url,
    double aspectRatio = 0.8,
    int fileSize = 0,
  }) {
    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: 'user_1',
      type: ChatMessageType.image,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
      mediaData: ChatMediaData(
        url: url,
        mediaType: ChatMessageType.image,
        aspectRatio: aspectRatio,
        fileSize: fileSize,
      ),
    );
  }
}

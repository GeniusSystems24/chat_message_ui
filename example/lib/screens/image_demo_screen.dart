import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

/// Demo screen for image features.
class ImageDemoScreen extends StatelessWidget {
  const ImageDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Features'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Image Bubbles
          Text(
            'Image Bubble Variants',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Standard image bubble
          _ImageBubbleDemo(
            title: 'Standard Image Bubble',
            child: ImageBubble(
              imageUrl: 'https://picsum.photos/800/600',
              isMe: false,
              onTap: () => _openFullScreen(
                context,
                'https://picsum.photos/800/600',
                'Sample Image',
              ),
            ),
          ),

          // With thumbnail
          _ImageBubbleDemo(
            title: 'With Blurred Thumbnail',
            child: ImageBubble(
              imageUrl: 'https://picsum.photos/1200/800',
              thumbnailUrl: 'https://picsum.photos/120/80',
              isMe: true,
              onTap: () => _openFullScreen(
                context,
                'https://picsum.photos/1200/800',
                'High Resolution Image',
              ),
            ),
          ),

          // With file size
          _ImageBubbleDemo(
            title: 'With File Size Display',
            child: ImageBubble(
              imageUrl: 'https://picsum.photos/600/800',
              isMe: false,
              fileSize: 1024 * 750, // 750 KB
              showFileSize: true,
              onTap: () => _openFullScreen(
                context,
                'https://picsum.photos/600/800',
                'Portrait Image',
              ),
            ),
          ),

          // With progress indicator
          _ImageBubbleDemo(
            title: 'With Download Progress',
            child: ImageBubble(
              imageUrl: 'https://picsum.photos/900/600',
              isMe: true,
              showProgress: true,
              progress: 0.65,
              onTap: () {},
            ),
          ),

          // Gallery indicator
          _ImageBubbleDemo(
            title: 'Gallery Indicator (3 images)',
            child: ImageBubble(
              imageUrl: 'https://picsum.photos/800/600',
              isMe: false,
              galleryCount: 3,
              galleryIndex: 0,
              onTap: () => _openFullScreen(
                context,
                'https://picsum.photos/800/600',
                'Gallery Image 1/3',
              ),
            ),
          ),

          // With long press
          _ImageBubbleDemo(
            title: 'With Long Press Action',
            child: ImageBubble(
              imageUrl: 'https://picsum.photos/700/500',
              isMe: true,
              onTap: () => _openFullScreen(
                context,
                'https://picsum.photos/700/500',
                'Image with Actions',
              ),
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Long pressed! Show options menu')),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Full Screen Image Viewer Features
          Text(
            'Full Screen Viewer Features',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeatureRow(
                    icon: Icons.touch_app,
                    title: 'Double-tap to Zoom',
                    description: 'Quick zoom in/out with double tap gesture',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.swipe_down,
                    title: 'Swipe Down to Dismiss',
                    description: 'Drag down to close with fade animation',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.visibility,
                    title: 'Toggle Controls',
                    description: 'Tap to show/hide top and bottom bars',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.zoom_in,
                    title: 'Pinch to Zoom',
                    description: 'Interactive zoom with pinch gesture',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.share,
                    title: 'Share & Download',
                    description: 'Action buttons for sharing and downloading',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.info_outline,
                    title: 'File Info Display',
                    description: 'Show file name and size in top bar',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Try full screen button
          ElevatedButton.icon(
            onPressed: () => _openFullScreen(
              context,
              'https://picsum.photos/1920/1080',
              'Full HD Image',
              fileSize: 1024 * 1024 * 2,
            ),
            icon: const Icon(Icons.fullscreen),
            label: const Text('Open Full Screen Viewer'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _openFullScreen(
    BuildContext context,
    String imageUrl,
    String title, {
    int? fileSize,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewerFullScreen(
          imageUrl: imageUrl,
          heroTag: imageUrl,
          fileName: title,
          fileSize: fileSize,
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share image')),
            );
          },
          onDownload: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download image')),
            );
          },
        ),
      ),
    );
  }
}

class _ImageBubbleDemo extends StatelessWidget {
  final String title;
  final Widget child;

  const _ImageBubbleDemo({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Center(child: child),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../../data/example_message.dart';
import '../../data/example_pagination.dart';
import '../../data/example_sample_data.dart';
import '../shared/example_scaffold.dart';

/// Example demonstrating custom bubble builders.
///
/// Shows how to customize the rendering of different message types
/// using the BubbleBuilders class.
class CustomBuildersExample extends StatefulWidget {
  const CustomBuildersExample({super.key});

  @override
  State<CustomBuildersExample> createState() => _CustomBuildersExampleState();
}

class _CustomBuildersExampleState extends State<CustomBuildersExample> {
  late final List<ExampleMessage> _messages;
  late final ExamplePaginationHelper<ExampleMessage> _pagination;
  bool _useCustomBuilders = true;

  @override
  void initState() {
    super.initState();
    _messages =
        ExampleSampleData.buildMessages().take(10).toList().reversed.toList();
    _pagination = ExamplePaginationHelper<ExampleMessage>(
      items: _messages,
      pageSize: 20,
    );
    _pagination.cubit.fetchPaginatedList();
  }

  @override
  void dispose() {
    _pagination.dispose();
    super.dispose();
  }

  /// Custom builders for demonstration
  BubbleBuilders get _customBuilders => BubbleBuilders(
        // Custom image bubble with gradient border
        imageBubbleBuilder: (context, builderContext, media) {
          return _CustomImageBubble(
            media: media,
            isMyMessage: builderContext.isMyMessage,
          );
        },

        // Custom audio bubble with different style
        audioBubbleBuilder: (context, builderContext, media) {
          return _CustomAudioBubble(
            media: media,
            isMyMessage: builderContext.isMyMessage,
          );
        },

        // Custom video bubble
        videoBubbleBuilder: (context, builderContext, media) {
          return _CustomVideoBubble(
            media: media,
            isMyMessage: builderContext.isMyMessage,
          );
        },

        // Custom document bubble
        documentBubbleBuilder: (context, builderContext, media) {
          return _CustomDocumentBubble(
            media: media,
            isMyMessage: builderContext.isMyMessage,
          );
        },

        // Custom location bubble
        locationBubbleBuilder: (context, builderContext, location) {
          return _CustomLocationBubble(
            location: location,
            isMyMessage: builderContext.isMyMessage,
          );
        },

        // Custom contact bubble
        contactBubbleBuilder: (context, builderContext, contact) {
          return _CustomContactBubble(
            contact: contact,
            isMyMessage: builderContext.isMyMessage,
          );
        },

        // Custom context menu
        contextMenuBuilder: (context, builderContext) async {
          return _showCustomContextMenu(context, builderContext);
        },
      );

  Future<MessageContextMenuResult?> _showCustomContextMenu(
    BuildContext context,
    ContextMenuBuilderContext builderContext,
  ) async {
    // Show a custom styled context menu
    return showModalBottomSheet<MessageContextMenuResult>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomContextMenuSheet(
        onReaction: (emoji) {
          Navigator.of(context).pop(MessageContextMenuResult(reaction: emoji));
        },
        onAction: (action) {
          Navigator.of(context).pop(MessageContextMenuResult(action: action));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Builders'),
        actions: [
          IconButton(
            icon: Icon(_useCustomBuilders ? Icons.toggle_on : Icons.toggle_off),
            tooltip: _useCustomBuilders ? 'Using Custom' : 'Using Default',
            onPressed: () {
              setState(() => _useCustomBuilders = !_useCustomBuilders);
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Screen Overview',
            onPressed: () => ExampleDescription.showAsBottomSheet(
              context,
              title: 'Custom Builders Demo',
              icon: Icons.build_outlined,
              lines: const [
                'Demonstrates BubbleBuilders for custom rendering.',
                'Toggle button switches between custom and default.',
                'Custom image has gradient border.',
                'Custom audio has different player style.',
                'Long press shows custom context menu.',
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status indicator
          Container(
            padding: const EdgeInsets.all(12),
            color: _useCustomBuilders
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _useCustomBuilders
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: _useCustomBuilders ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _useCustomBuilders
                      ? 'Custom Builders Active'
                      : 'Default Builders Active',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _useCustomBuilders ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Message list
          Expanded(
            child: SmartPaginationListView.withCubit(
              cubit: _pagination.cubit,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, items, index) {
                final message = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MessageBubble(
                    message: message,
                    currentUserId: ExampleSampleData.currentUserId,
                    showAvatar: true,
                    bubbleBuilders: _useCustomBuilders ? _customBuilders : null,
                    onLongPress: () async {
                      if (_useCustomBuilders) {
                        final result = await _showCustomContextMenu(
                          context,
                          ContextMenuBuilderContext(
                            message: message,
                            position: Offset.zero,
                            isMyMessage: message.senderId ==
                                ExampleSampleData.currentUserId,
                            currentUserId: ExampleSampleData.currentUserId,
                            onDismiss: () {},
                          ),
                        );
                        if (result != null) {
                          _handleContextMenuResult(result, message);
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleContextMenuResult(
    MessageContextMenuResult result,
    ExampleMessage message,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    if (result.hasReaction) {
      messenger.showSnackBar(
        SnackBar(content: Text('Reaction: ${result.reaction}')),
      );
    } else if (result.hasAction) {
      messenger.showSnackBar(
        SnackBar(content: Text('Action: ${result.action}')),
      );
    }
  }
}

/// Custom image bubble with gradient border
class _CustomImageBubble extends StatelessWidget {
  final ChatMediaData media;
  final bool isMyMessage;

  const _CustomImageBubble({
    required this.media,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isMyMessage
              ? [Colors.purple.shade300, Colors.blue.shade300]
              : [Colors.orange.shade300, Colors.pink.shade300],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 200,
          height: 150,
          color: Colors.grey.shade200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (media.thumbnailUrl != null)
                Image.network(
                  media.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                )
              else
                _buildPlaceholder(),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Custom',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.image, size: 48, color: Colors.grey),
      ),
    );
  }
}

/// Custom audio bubble with different style
class _CustomAudioBubble extends StatelessWidget {
  final ChatMediaData media;
  final bool isMyMessage;

  const _CustomAudioBubble({
    required this.media,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMyMessage ? Colors.purple.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMyMessage ? Colors.purple.shade200 : Colors.orange.shade200,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isMyMessage ? Colors.purple : Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.music_note, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Custom Audio Player',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (media.duration != null)
                Text(
                  _formatDuration(Duration(milliseconds: media.duration!)),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.play_circle_filled),
            iconSize: 40,
            color: isMyMessage ? Colors.purple : Colors.orange,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Custom location bubble
class _CustomLocationBubble extends StatelessWidget {
  final ChatLocationData location;
  final bool isMyMessage;

  const _CustomLocationBubble({
    required this.location,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMyMessage ? Colors.blue.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMyMessage ? Colors.blue.shade200 : Colors.green.shade200,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: isMyMessage ? Colors.blue.shade100 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.map,
              size: 48,
              color: isMyMessage ? Colors.blue : Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            location.name ?? 'Custom Location',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '${location.latitude?.toStringAsFixed(4)}, ${location.longitude?.toStringAsFixed(4)}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Custom context menu sheet
class _CustomContextMenuSheet extends StatelessWidget {
  final void Function(String emoji) onReaction;
  final void Function(MessageAction action) onAction;

  const _CustomContextMenuSheet({
    required this.onReaction,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Custom Context Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Reactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['❤️', '😂', '😮', '😢', '👍', '👎'].map((emoji) {
                return GestureDetector(
                  onTap: () => onReaction(emoji),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 32),

          // Actions
          _buildAction(
              Icons.reply, 'Reply', () => onAction(MessageAction.reply)),
          _buildAction(Icons.copy, 'Copy', () => onAction(MessageAction.copy)),
          _buildAction(
              Icons.forward, 'Forward', () => onAction(MessageAction.forward)),
          _buildAction(
              Icons.push_pin, 'Pin', () => onAction(MessageAction.pin)),
          _buildAction(
              Icons.delete, 'Delete', () => onAction(MessageAction.delete),
              isDestructive: true),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAction(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      onTap: onTap,
    );
  }
}

/// Custom video bubble
class _CustomVideoBubble extends StatelessWidget {
  final ChatMediaData media;
  final bool isMyMessage;

  const _CustomVideoBubble({
    required this.media,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (media.thumbnailUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                media.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              ),
            )
          else
            _buildPlaceholder(),
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                size: 40,
                color: isMyMessage ? Colors.purple : Colors.orange,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.videocam, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(media.duration),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(Icons.videocam, size: 48, color: Colors.white54),
      ),
    );
  }

  String _formatDuration(int? milliseconds) {
    if (milliseconds == null) return '0:00';
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Custom document bubble
class _CustomDocumentBubble extends StatelessWidget {
  final ChatMediaData media;
  final bool isMyMessage;

  const _CustomDocumentBubble({
    required this.media,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = media.resolvedFileName ?? 'Document';
    final extension = fileName.split('.').last.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMyMessage
              ? [Colors.indigo.shade50, Colors.blue.shade50]
              : [Colors.grey.shade100, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMyMessage ? Colors.indigo.shade200 : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isMyMessage ? Colors.indigo : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.description, color: Colors.white, size: 24),
                Text(
                  extension,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (media.fileSize != null)
                  Text(
                    _formatFileSize(media.fileSize!),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.download,
            color: isMyMessage ? Colors.indigo : Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Custom contact bubble
class _CustomContactBubble extends StatelessWidget {
  final ChatContactData contact;
  final bool isMyMessage;

  const _CustomContactBubble({
    required this.contact,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMyMessage
              ? [Colors.teal.shade50, Colors.cyan.shade50]
              : [Colors.grey.shade100, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMyMessage ? Colors.teal.shade200 : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isMyMessage ? Colors.teal : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (contact.phone != null)
                  Text(
                    contact.phone!,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom poll bubble
class _CustomPollBubble extends StatelessWidget {
  final ChatPollData poll;
  final bool isMyMessage;

  const _CustomPollBubble({
    required this.poll,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMyMessage
              ? [Colors.deepPurple.shade50, Colors.purple.shade50]
              : [Colors.grey.shade100, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isMyMessage ? Colors.deepPurple.shade200 : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.poll,
                color: isMyMessage ? Colors.deepPurple : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  poll.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...poll.options.take(3).map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isMyMessage
                      ? Colors.deepPurple.shade100
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.radio_button_unchecked,
                      size: 18,
                      color: isMyMessage
                          ? Colors.deepPurple
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        option.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (poll.options.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+${poll.options.length - 3} more options',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../../data/example_sample_data.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing the FocusedMessageOverlay feature.
///
/// This screen demonstrates how to use the focused message overlay
/// for WhatsApp/Telegram-style message interactions with modal barrier.
class FocusedOverlayExample extends StatefulWidget {
  const FocusedOverlayExample({super.key});

  @override
  State<FocusedOverlayExample> createState() => _FocusedOverlayExampleState();
}

class _FocusedOverlayExampleState extends State<FocusedOverlayExample> {
  final List<ExampleMessage> _messages = [];
  bool _showLabels = true;
  bool _showReactions = true;

  @override
  void initState() {
    super.initState();
    _initMessages();
  }

  void _initMessages() {
    _messages.addAll([
      _createTextMessage(
        id: 'msg_1',
        text:
            'Hello! This is a sample message. Long press to see the focused overlay.',
        isMe: false,
      ),
      _createTextMessage(
        id: 'msg_2',
        text:
            'The overlay shows reactions above and actions below the message.',
        isMe: true,
      ),
      _createTextMessage(
        id: 'msg_3',
        text: 'You can customize which reactions and actions to show.',
        isMe: false,
      ),
      _createImageMessage(
        id: 'msg_4',
        isMe: true,
      ),
      _createTextMessage(
        id: 'msg_5',
        text:
            'Try long pressing any message to see the focused overlay in action!',
        isMe: false,
      ),
    ]);
  }

  Future<void> _showFocusedOverlay(
    BuildContext context,
    ExampleMessage message,
    bool isMyMessage,
  ) async {
    final result = await MessageContextMenu.showWithFocusedOverlay(
      context,
      messageBuilder: (ctx) => _buildMessageWidget(message, isMyMessage),
      reactions: ['❤️', '😂', '😮', '😢', '🙏', '👍'],
      actions: [
        MessageActionConfig.reply,
        MessageActionConfig.copy,
        MessageActionConfig.forward,
        if (isMyMessage) MessageActionConfig.edit,
        MessageActionConfig.pin,
        MessageActionConfig.delete,
      ],
      showReactions: _showReactions,
      showActionLabels: _showLabels,
      isMyMessage: isMyMessage,
    );

    if (result != null && mounted) {
      _handleResult(result, message);
    }
  }

  Widget _buildMessageWidget(ExampleMessage message, bool isMyMessage) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: MessageBubble(
        message: message,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: !isMyMessage,
      ),
    );
  }

  void _handleResult(MessageContextMenuResult result, ExampleMessage message) {
    if (result.hasReaction) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Reacted with ${result.reaction} to message: ${message.id}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (result.hasAction) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Action: ${result.action!.name} on message: ${message.id}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExampleScaffold(
      title: 'Focused Overlay',
      subtitle: 'WhatsApp-style message interactions',
      body: Column(
        children: [
          // Settings Panel
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overlay Settings',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile.adaptive(
                        title: const Text('Show Labels'),
                        subtitle: const Text('Display action labels'),
                        value: _showLabels,
                        onChanged: (value) =>
                            setState(() => _showLabels = value),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile.adaptive(
                        title: const Text('Show Reactions'),
                        subtitle: const Text('Display reaction bar'),
                        value: _showReactions,
                        onChanged: (value) =>
                            setState(() => _showReactions = value),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Long press any message to show the focused overlay',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMyMessage =
                      message.senderId == ExampleSampleData.currentUserId;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      onLongPress: () => _showFocusedOverlay(
                        context,
                        message,
                        isMyMessage,
                      ),
                      child: MessageBubble(
                        message: message,
                        currentUserId: ExampleSampleData.currentUserId,
                        showAvatar: !isMyMessage,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: _usageBuild,
          );
        },
        child: const Icon(Icons.code),
      ),
    );
  }

  Widget _usageBuild(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: SelectableText(
              '''MessageContextMenu.showWithFocusedOverlay(
context,
messageBuilder: (ctx) => MessageBubble(...),
reactions: ['❤️', '😂', '😮', '👍'],
actions: [
  MessageActionConfig.reply,
  MessageActionConfig.copy,
],
isMyMessage: true,
);''',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ExampleMessage _createTextMessage({
    required String id,
    required String text,
    required bool isMe,
  }) {
    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: isMe ? ExampleSampleData.currentUserId : 'user_2',
      senderData: isMe
          ? ExampleSampleData.users['user_1']
          : ExampleSampleData.users['user_2'],
      type: ChatMessageType.text,
      textContent: text,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
    );
  }

  ExampleMessage _createImageMessage({
    required String id,
    required bool isMe,
  }) {
    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: isMe ? ExampleSampleData.currentUserId : 'user_2',
      senderData: isMe
          ? ExampleSampleData.users['user_1']
          : ExampleSampleData.users['user_2'],
      type: ChatMessageType.image,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
      mediaData: ChatMediaData(
        url:
            'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/operation.png?alt=media&token=6e1d3457-f2f3-43db-bcf3-70332e19d298',
        mediaType: ChatMessageType.image,
        aspectRatio: 1.5,
      ),
    );
  }
}

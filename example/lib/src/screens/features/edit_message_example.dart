import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../../data/example_sample_data.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing Edit Message features.
///
/// Features demonstrated:
/// - EditMessagePreview widget
/// - Edit message flow (select → preview → update/cancel)
/// - Integration with ChatInputWidget
class EditMessageExample extends StatefulWidget {
  const EditMessageExample({super.key});

  @override
  State<EditMessageExample> createState() => _EditMessageExampleState();
}

class _EditMessageExampleState extends State<EditMessageExample> {
  late List<ExampleMessage> _messages;
  final TextEditingController _textController = TextEditingController();
  ExampleMessage? _editingMessage;

  @override
  void initState() {
    super.initState();
    _initMessages();
  }

  void _initMessages() {
    _messages = [
      ExampleMessage(
        id: 'msg_1',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'Hello everyone! How are you doing today?',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'msg_2',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'I have a question about the project deadline.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        status: ChatMessageStatus.delivered,
      ),
      ExampleMessage(
        id: 'msg_3',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'The deadline is next Friday.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: ChatMessageStatus.delivered,
      ),
      ExampleMessage(
        id: 'msg_4',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'Thanks for the info! I will prepare everything.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        status: ChatMessageStatus.sent,
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Edit Message',
      subtitle: 'EditMessagePreview & edit flow',
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const ExampleDescription(
                  title: 'Screen Overview',
                  icon: Icons.edit_outlined,
                  lines: [
                    'Demonstrates the EditMessagePreview widget.',
                    'Long press on your own messages to edit.',
                    'Shows the complete edit flow with preview.',
                    'Integrates with ChatInputWidget for seamless UX.',
                  ],
                ),
                const SizedBox(height: 24),

                // Standalone Preview Section
                const ExampleSectionHeader(
                  title: 'EditMessagePreview Widget',
                  description: 'Standalone widget demonstration',
                  icon: Icons.preview,
                ),
                const SizedBox(height: 16),

                DemoContainer(
                  title: 'Basic EditMessagePreview',
                  child: EditMessagePreview(
                    message: _messages.first,
                    onCancel: () => _showSnackBar('Cancel pressed'),
                  ),
                ),
                const SizedBox(height: 16),

                DemoContainer(
                  title: 'Custom Colors',
                  child: EditMessagePreview(
                    message: _messages[1],
                    onCancel: () => _showSnackBar('Cancel pressed'),
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    borderColor: Theme.of(context).colorScheme.tertiary,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 24),

                // Messages Section
                const ExampleSectionHeader(
                  title: 'Interactive Demo',
                  description: 'Long press your messages to edit',
                  icon: Icons.touch_app,
                ),
                const SizedBox(height: 16),

                ..._messages.map((message) {
                  final isOwn =
                      message.senderId == ExampleSampleData.currentUserId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onLongPress:
                          isOwn ? () => _startEditing(message) : null,
                      child: Stack(
                        children: [
                          MessageBubble(
                            message: message,
                            currentUserId: ExampleSampleData.currentUserId,
                            showAvatar: true,
                          ),
                          if (isOwn)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Long press to edit',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Properties Section
                const ExampleSectionHeader(
                  title: 'EditMessagePreview Properties',
                  description: 'Available customization options',
                  icon: Icons.tune,
                ),
                const SizedBox(height: 12),

                const PropertyShowcase(
                  property: 'message',
                  value: 'IChatMessageData (required)',
                  description: 'The message being edited',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'onCancel',
                  value: 'VoidCallback (required)',
                  description: 'Called when cancel button is pressed',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'backgroundColor',
                  value: 'Color?',
                  description: 'Custom background color',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'borderColor',
                  value: 'Color?',
                  description: 'Custom left border accent color',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'iconColor',
                  value: 'Color?',
                  description: 'Custom edit icon color',
                ),

                const SizedBox(height: 24),

                // Code Example
                const CodeSnippet(
                  title: 'Usage Example',
                  code: '''
// In your chat screen state
IChatMessageData? _editingMessage;

// When user long presses a message
void _startEditing(IChatMessageData message) {
  setState(() {
    _editingMessage = message;
    _textController.text = message.textContent ?? '';
  });
}

// In your build method
Column(
  children: [
    // Messages list...
    
    // Edit preview (shown when editing)
    if (_editingMessage != null)
      EditMessagePreview(
        message: _editingMessage!,
        onCancel: () => setState(() {
          _editingMessage = null;
          _textController.clear();
        }),
      ),
    
    // Input field
    ChatInputWidget(
      controller: _textController,
      onSendText: (text) async {
        if (_editingMessage != null) {
          // Update the message
          await updateMessage(_editingMessage!.id, text);
          setState(() => _editingMessage = null);
        } else {
          // Send new message
          await sendMessage(text);
        }
      },
    ),
  ],
)''',
                ),

                const SizedBox(height: 100), // Space for input
              ],
            ),
          ),

          // Edit Preview + Input
          if (_editingMessage != null)
            EditMessagePreview(
              message: _editingMessage!,
              onCancel: _cancelEditing,
            ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _editingMessage != null
                          ? 'Edit message...'
                          : 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 4,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _handleSend,
                  icon: Icon(
                    _editingMessage != null ? Icons.check : Icons.send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startEditing(ExampleMessage message) {
    setState(() {
      _editingMessage = message;
      _textController.text = message.textContent ?? '';
    });
    _showSnackBar('Editing message...');
  }

  void _cancelEditing() {
    setState(() {
      _editingMessage = null;
      _textController.clear();
    });
    _showSnackBar('Edit cancelled');
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessage != null) {
      // Update existing message
      setState(() {
        final index = _messages.indexOf(_editingMessage!);
        if (index != -1) {
          _messages[index] = _editingMessage!.copyWith(
            textContent: text,
            isEdited: true,
          );
        }
        _editingMessage = null;
        _textController.clear();
      });
      _showSnackBar('Message updated');
    } else {
      // Send new message
      setState(() {
        _messages.add(ExampleMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          chatId: ExampleSampleData.chatId,
          senderId: ExampleSampleData.currentUserId,
          senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
          type: ChatMessageType.text,
          textContent: text,
          createdAt: DateTime.now(),
          status: ChatMessageStatus.sent,
        ));
        _textController.clear();
      });
      _showSnackBar('Message sent');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_sample_data.dart';
import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing text message features within MessageBubble.
class TextBubbleExample extends StatelessWidget {
  const TextBubbleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Text Messages',
      subtitle: 'Text content with MessageBubble',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Text messages with metadata, status, and interactions',
            icon: Icons.chat_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Text Message
          DemoContainer(
            title: 'Basic Text Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_1',
                text: 'Hello! This is a basic text message.',
                isMe: false,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 24),

          // Sent vs Received
          const ExampleSectionHeader(
            title: 'Message Direction',
            description: 'Sent and received message styling',
            icon: Icons.swap_horiz_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Received Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_2',
                text: 'This message was received from another user.',
                isMe: false,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Sent Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_3',
                text: 'This message was sent by me.',
                isMe: true,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 24),

          // Message Status
          const ExampleSectionHeader(
            title: 'Message Status',
            description: 'Different delivery status indicators',
            icon: Icons.done_all_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Pending',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_4',
                text: 'Sending message...',
                isMe: true,
                status: ChatMessageStatus.pending,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Sent',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_5',
                text: 'Message sent successfully.',
                isMe: true,
                status: ChatMessageStatus.sent,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Delivered',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_6',
                text: 'Message delivered to recipient.',
                isMe: true,
                status: ChatMessageStatus.delivered,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Read',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_7',
                text: 'Message has been read.',
                isMe: true,
                status: ChatMessageStatus.read,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Failed',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_8',
                text: 'Failed to send message.',
                isMe: true,
                status: ChatMessageStatus.failed,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 24),

          // With Reactions
          const ExampleSectionHeader(
            title: 'Reactions',
            description: 'Emoji reactions on messages',
            icon: Icons.emoji_emotions_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Single Reaction',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_9',
                text: 'Great news! The feature is ready.',
                isMe: false,
                reactions: const [
                  ChatReactionData(emoji: '👍', userId: 'user_1'),
                ],
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Multiple Reactions',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_10',
                text: 'We just hit 1 million users! 🎉',
                isMe: false,
                reactions: const [
                  ChatReactionData(emoji: '🎉', userId: 'user_1'),
                  ChatReactionData(emoji: '❤️', userId: 'user_2'),
                  ChatReactionData(emoji: '🔥', userId: 'user_3'),
                  ChatReactionData(emoji: '👏', userId: 'user_1'),
                ],
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 24),

          // Special Message States
          const ExampleSectionHeader(
            title: 'Special States',
            description: 'Edited, forwarded, and deleted messages',
            icon: Icons.edit_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Edited Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_11',
                text: 'This message has been edited.',
                isMe: true,
                isEdited: true,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Forwarded Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_12',
                text: 'This is a forwarded message from another chat.',
                isMe: false,
                isForwarded: true,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Deleted Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_13',
                text: 'This message was deleted.',
                isMe: false,
                isDeleted: true,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 24),

          // Long Messages
          const ExampleSectionHeader(
            title: 'Message Length',
            description: 'Short and long text handling',
            icon: Icons.notes_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Short Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_14',
                text: 'OK 👍',
                isMe: true,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Long Message',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_15',
                text: '''This is a longer message that spans multiple lines. It demonstrates how the message bubble handles text wrapping and maintains readability.

The MessageBubble widget automatically adjusts its width and height to accommodate the content while respecting maximum width constraints.

This helps ensure a consistent and pleasant user experience regardless of message length.''',
                isMe: false,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 24),

          // Rich Text Features
          const ExampleSectionHeader(
            title: 'Rich Text',
            description: 'Links, mentions, hashtags, and more',
            icon: Icons.link_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'With Links',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_16',
                text: 'Check out our website at https://example.com for more info!',
                isMe: false,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'With Mentions & Hashtags',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_17',
                text: 'Hey @john, have you seen the #flutter update? Its amazing!',
                isMe: true,
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'With Phone & Email',
            child: MessageBubble(
              message: _createTextMessage(
                id: 'text_18',
                text: 'Contact us at support@example.com or call +1 555 123 4567',
                isMe: false,
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'MessageBubble Properties',
            description: 'Key properties for text messages',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'Message data implementing the interface',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'currentUserId',
            value: 'String',
            description: 'ID of current user for direction',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showAvatar',
            value: 'bool (default: false)',
            description: 'Show sender avatar',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onTap',
            value: 'VoidCallback?',
            description: 'Tap handler for the bubble',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onLongPress',
            value: 'VoidCallback?',
            description: 'Long press handler',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onReactionTap',
            value: 'Function(String)?',
            description: 'Reaction tap callback',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''MessageBubble(
  message: ExampleMessage(
    id: 'msg_1',
    senderId: 'user_2',
    type: ChatMessageType.text,
    textContent: 'Hello World!',
    status: ChatMessageStatus.read,
    reactions: [
      ChatReactionData(emoji: '👍', userId: 'user_1'),
    ],
  ),
  currentUserId: 'user_1',
  showAvatar: true,
  onTap: () => print('Tapped'),
  onLongPress: () => showOptions(),
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createTextMessage({
    required String id,
    required String text,
    required bool isMe,
    ChatMessageStatus status = ChatMessageStatus.read,
    List<ChatReactionData>? reactions,
    bool isEdited = false,
    bool isForwarded = false,
    bool isDeleted = false,
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
      status: status,
      reactions: reactions ?? [],
      isEdited: isEdited,
      isForwarded: isForwarded,
      isDeleted: isDeleted,
    );
  }
}

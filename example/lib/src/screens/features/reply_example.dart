import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_sample_data.dart';
import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing reply features.
class ReplyExample extends StatelessWidget {
  const ReplyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Reply System',
      subtitle: 'Reply preview and quoted messages',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Reply to messages with preview and context',
            icon: Icons.reply_outlined,
          ),
          const SizedBox(height: 16),

          // Reply Preview Widget
          const ExampleSectionHeader(
            title: 'ReplyPreviewWidget',
            description: 'Shown above input when replying',
            icon: Icons.input_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Text Reply Preview',
            child: ReplyPreviewWidget(
              replyMessage: const ChatReplyData(
                id: 'msg_1',
                senderId: 'user_2',
                senderName: 'John Doe',
                message: 'Hey, have you seen the new feature?',
                type: ChatMessageType.text,
              ),
              onCancel: () {},
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Image Reply Preview',
            child: ReplyPreviewWidget(
              replyMessage: const ChatReplyData(
                id: 'msg_2',
                senderId: 'user_3',
                senderName: 'Sarah',
                message: 'Check this out!',
                type: ChatMessageType.image,
                thumbnailUrl: 'https://i.pravatar.cc/150?img=5',
              ),
              onCancel: () {},
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Video Reply Preview',
            child: ReplyPreviewWidget(
              replyMessage: const ChatReplyData(
                id: 'msg_3',
                senderId: 'user_2',
                senderName: 'John',
                message: 'Demo video',
                type: ChatMessageType.video,
              ),
              onCancel: () {},
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Audio Reply Preview',
            child: ReplyPreviewWidget(
              replyMessage: const ChatReplyData(
                id: 'msg_4',
                senderId: 'user_3',
                senderName: 'Mike',
                message: '',
                type: ChatMessageType.audio,
              ),
              onCancel: () {},
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Document Reply Preview',
            child: ReplyPreviewWidget(
              replyMessage: const ChatReplyData(
                id: 'msg_5',
                senderId: 'user_2',
                senderName: 'Anna',
                message: 'Project.pdf',
                type: ChatMessageType.document,
              ),
              onCancel: () {},
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Location Reply Preview',
            child: ReplyPreviewWidget(
              replyMessage: const ChatReplyData(
                id: 'msg_6',
                senderId: 'user_3',
                senderName: 'Tom',
                message: 'Meeting point',
                type: ChatMessageType.location,
              ),
              onCancel: () {},
            ),
          ),
          const SizedBox(height: 24),

          // Messages with Replies
          const ExampleSectionHeader(
            title: 'Messages with Replies',
            description: 'How replied messages appear in chat',
            icon: Icons.chat_bubble_outline,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Reply to Text',
            child: MessageBubble(
              message: _createReplyMessage(
                id: 'reply_1',
                text: 'Yes, I saw it! Looks amazing.',
                replyTo: const ChatReplyData(
                  id: 'original_1',
                  senderId: 'user_2',
                  senderName: 'John',
                  message: 'Have you seen the new Flutter update?',
                  type: ChatMessageType.text,
                ),
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Reply to Image',
            child: MessageBubble(
              message: _createReplyMessage(
                id: 'reply_2',
                text: 'This design looks great!',
                isMe: false,
                replyTo: const ChatReplyData(
                  id: 'original_2',
                  senderId: 'user_1',
                  senderName: 'Amina',
                  message: 'UI mockup',
                  type: ChatMessageType.image,
                  thumbnailUrl: 'https://i.pravatar.cc/150?img=32',
                ),
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Reply to Voice',
            child: MessageBubble(
              message: _createReplyMessage(
                id: 'reply_3',
                text: 'Got your voice message, will check and respond.',
                replyTo: const ChatReplyData(
                  id: 'original_3',
                  senderId: 'user_3',
                  senderName: 'Sara',
                  message: '',
                  type: ChatMessageType.audio,
                ),
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 24),

          // Custom Styling
          const ExampleSectionHeader(
            title: 'Custom Styling',
            description: 'Customize reply preview appearance',
            icon: Icons.palette_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Custom Colors',
            child: ReplyPreviewWidget(
              replyMessage: const ChatReplyData(
                id: 'custom_1',
                senderId: 'user_2',
                senderName: 'Alex',
                message: 'Custom styled reply preview',
                type: ChatMessageType.text,
              ),
              onCancel: () {},
              backgroundColor: Colors.purple.shade50,
              borderColor: Colors.purple,
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference - ReplyPreviewWidget
          const ExampleSectionHeader(
            title: 'ReplyPreviewWidget Properties',
            description: 'Input preview widget properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'replyMessage',
            value: 'ChatReplyData',
            description: 'Required reply data to display',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onCancel',
            value: 'VoidCallback',
            description: 'Required cancel button callback',
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
            description: 'Custom left border color',
          ),
          const SizedBox(height: 24),

          // ChatReplyData Properties
          const ExampleSectionHeader(
            title: 'ChatReplyData Properties',
            description: 'Reply data model structure',
            icon: Icons.data_object_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'id',
            value: 'String',
            description: 'ID of the original message',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'senderId',
            value: 'String',
            description: 'ID of original message sender',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'senderName',
            value: 'String',
            description: 'Name of original sender',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'message',
            value: 'String',
            description: 'Original message content/preview',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'type',
            value: 'ChatMessageType',
            description: 'Type of original message',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'thumbnailUrl',
            value: 'String?',
            description: 'Thumbnail for media replies',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''// Reply preview above input
ReplyPreviewWidget(
  replyMessage: ChatReplyData(
    id: 'msg_123',
    senderId: 'user_2',
    senderName: 'John',
    message: 'Original message text',
    type: ChatMessageType.text,
  ),
  onCancel: () => clearReply(),
  backgroundColor: Colors.grey.shade100,
  borderColor: Colors.blue,
)

// Message with reply in chat
MessageBubble(
  message: ExampleMessage(
    id: 'new_msg',
    replyData: ChatReplyData(...),
    textContent: 'My reply to that message',
  ),
  currentUserId: currentUser,
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createReplyMessage({
    required String id,
    required String text,
    required ChatReplyData replyTo,
    bool isMe = true,
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
      replyToId: replyTo.id,
      replyData: replyTo,
    );
  }
}

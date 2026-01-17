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
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.reply_outlined,
            lines: [
              'Covers reply previews and quoted message rendering.',
              'Shows how reply metadata appears across message types.',
              'Helps verify reply styling and cancellation behavior.',
            ],
          ),
          const SizedBox(height: 16),
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

          // Reply Bubbles for All Message Types
          const ExampleSectionHeader(
            title: 'Reply to Different Types',
            description: 'How replies work with various message types',
            icon: Icons.category_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Reply to Video',
            child: MessageBubble(
              message: _createReplyMessage(
                id: 'reply_4',
                text: 'Nice video! Where was this recorded?',
                replyTo: const ChatReplyData(
                  id: 'original_4',
                  senderId: 'user_2',
                  senderName: 'Alex',
                  message: 'vacation.mp4',
                  type: ChatMessageType.video,
                  thumbnailUrl: 'https://i.pravatar.cc/150?img=15',
                ),
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Reply to Document',
            child: MessageBubble(
              message: _createReplyMessage(
                id: 'reply_5',
                text: 'Thanks for sharing! I\'ll review it.',
                isMe: false,
                replyTo: const ChatReplyData(
                  id: 'original_5',
                  senderId: 'user_1',
                  senderName: 'Me',
                  message: 'Report_2024.pdf',
                  type: ChatMessageType.document,
                ),
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Reply to Poll',
            child: MessageBubble(
              message: _createReplyMessage(
                id: 'reply_6',
                text: 'I voted for option 2!',
                replyTo: const ChatReplyData(
                  id: 'original_6',
                  senderId: 'user_3',
                  senderName: 'Maria',
                  message: 'What\'s your favorite?',
                  type: ChatMessageType.poll,
                ),
              ),
              currentUserId: ExampleSampleData.currentUserId,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Reply to Contact',
            child: MessageBubble(
              message: _createReplyMessage(
                id: 'reply_7',
                text: 'I added him to my contacts, thanks!',
                isMe: false,
                replyTo: const ChatReplyData(
                  id: 'original_7',
                  senderId: 'user_1',
                  senderName: 'Amina',
                  message: 'John Smith',
                  type: ChatMessageType.contact,
                ),
              ),
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 24),

          // Reply Chain
          const ExampleSectionHeader(
            title: 'Reply Chains',
            description: 'Multiple levels of replies',
            icon: Icons.link_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Reply to a Reply',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MessageBubble(
                  message: _createReplyMessage(
                    id: 'chain_1',
                    text: 'Yes, the new design looks amazing!',
                    isMe: false,
                    replyTo: const ChatReplyData(
                      id: 'chain_0',
                      senderId: 'user_1',
                      senderName: 'You',
                      message: 'What do you think of the new UI?',
                      type: ChatMessageType.text,
                    ),
                  ),
                  currentUserId: ExampleSampleData.currentUserId,
                  showAvatar: true,
                ),
                const SizedBox(height: 12),
                MessageBubble(
                  message: _createReplyMessage(
                    id: 'chain_2',
                    text: 'I agree! The colors are perfect.',
                    replyTo: const ChatReplyData(
                      id: 'chain_1',
                      senderId: 'user_2',
                      senderName: 'John',
                      message: 'Yes, the new design looks amazing!',
                      type: ChatMessageType.text,
                    ),
                  ),
                  currentUserId: ExampleSampleData.currentUserId,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Interactive Demo
          const ExampleSectionHeader(
            title: 'Interactive Demo',
            description: 'Try replying to messages',
            icon: Icons.touch_app_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Swipe to Reply (Simulated)',
            padding: EdgeInsets.zero,
            child: _InteractiveReplyDemo(),
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

/// Interactive reply demo widget
class _InteractiveReplyDemo extends StatefulWidget {
  @override
  State<_InteractiveReplyDemo> createState() => _InteractiveReplyDemoState();
}

class _InteractiveReplyDemoState extends State<_InteractiveReplyDemo> {
  ChatReplyData? _currentReply;
  final List<ExampleMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      ExampleMessage(
        id: 'demo_1',
        chatId: 'demo',
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'Long press me to reply!',
        createdAt: DateTime.now(),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'demo_2',
        chatId: 'demo',
        senderId: 'user_1',
        senderData: ExampleSampleData.users['user_1'],
        type: ChatMessageType.text,
        textContent: 'Or press the reply button',
        createdAt: DateTime.now(),
        status: ChatMessageStatus.read,
      ),
    ]);
  }

  void _setReply(ExampleMessage message) {
    setState(() {
      _currentReply = ChatReplyData(
        id: message.id,
        senderId: message.senderId,
        senderName: message.senderData?.displayName ?? 'User',
        message: message.textContent ?? '',
        type: message.type,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          padding: const EdgeInsets.all(8),
          child: ListView.separated(
            itemCount: _messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Row(
                mainAxisAlignment:
                    message.senderId == ExampleSampleData.currentUserId
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  if (message.senderId != ExampleSampleData.currentUserId)
                    IconButton(
                      icon: const Icon(Icons.reply, size: 20),
                      onPressed: () => _setReply(message),
                    ),
                  Flexible(
                    child: MessageBubble(
                      message: message,
                      currentUserId: ExampleSampleData.currentUserId,
                      showAvatar: false,
                      showTimestamp: false,
                      onLongPress: () => _setReply(message),
                    ),
                  ),
                  if (message.senderId == ExampleSampleData.currentUserId)
                    IconButton(
                      icon: const Icon(Icons.reply, size: 20),
                      onPressed: () => _setReply(message),
                    ),
                ],
              );
            },
          ),
        ),
        if (_currentReply != null)
          ReplyPreviewWidget(
            replyMessage: _currentReply!,
            onCancel: () => setState(() => _currentReply = null),
          ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _currentReply != null
                        ? 'Reply...'
                        : 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  enabled: false,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.send),
                onPressed: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

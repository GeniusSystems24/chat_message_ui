import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../shared/example_scaffold.dart';

/// Example screen showcasing ChatInputWidget features and properties.
class ChatInputExample extends StatefulWidget {
  const ChatInputExample({super.key});

  @override
  State<ChatInputExample> createState() => _ChatInputExampleState();
}

class _ChatInputExampleState extends State<ChatInputExample> {
  final _basicController = TextEditingController();
  final _fullController = TextEditingController();
  final _replyMessage = ValueNotifier<ChatReplyData?>(null);

  @override
  void dispose() {
    _basicController.dispose();
    _fullController.dispose();
    _replyMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'ChatInputWidget',
      subtitle: 'Rich chat input with attachments',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Text input with attachments, voice recording, and suggestions',
            icon: Icons.keyboard_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Input
          DemoContainer(
            title: 'Basic Input',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              controller: _basicController,
              onSendText: (text) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sent: $text')),
                );
              },
              enableAttachments: false,
              enableAudioRecording: false,
              hintText: 'Type a message...',
            ),
          ),
          const SizedBox(height: 24),

          // With Attachments
          const ExampleSectionHeader(
            title: 'With Attachments',
            description: 'Enable attachment button for media selection',
            icon: Icons.attach_file_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'enableAttachments: true',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              onSendText: (text) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sent: $text')),
                );
              },
              enableAttachments: true,
              enableAudioRecording: false,
              onAttachmentSelected: (type) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${type.name}')),
                );
              },
              hintText: 'Message',
            ),
          ),
          const SizedBox(height: 24),

          // With Voice Recording
          const ExampleSectionHeader(
            title: 'Voice Recording',
            description: 'Hold to record voice messages',
            icon: Icons.mic_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'enableAudioRecording: true',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              onSendText: (text) async {},
              enableAttachments: false,
              enableAudioRecording: true,
              onRecordingStart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recording started')),
                );
              },
              onRecordingComplete: (path, duration, {waveform}) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recorded ${duration}s audio')),
                );
              },
              onRecordingCancel: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recording cancelled')),
                );
              },
              hintText: 'Hold mic to record',
            ),
          ),
          const SizedBox(height: 24),

          // Full Featured Input
          const ExampleSectionHeader(
            title: 'Full Featured',
            description: 'All features enabled',
            icon: Icons.all_inclusive_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'All Features Enabled',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              controller: _fullController,
              onSendText: (text) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sent: $text')),
                );
                _fullController.clear();
              },
              enableAttachments: true,
              enableAudioRecording: true,
              onAttachmentSelected: (type) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Attachment: ${type.name}')),
                );
              },
              hintText: 'Type a message...',
            ),
          ),
          const SizedBox(height: 24),

          // With Reply Preview
          const ExampleSectionHeader(
            title: 'Reply Preview',
            description: 'Show reply context above input',
            icon: Icons.reply_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'With Reply Message',
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _replyMessage.value = const ChatReplyData(
                      id: 'reply_1',
                      senderId: 'user_2',
                      senderName: 'John Doe',
                      message: 'This is the message being replied to',
                      type: ChatMessageType.text,
                    );
                  },
                  icon: const Icon(Icons.reply),
                  label: const Text('Set Reply'),
                ),
                const SizedBox(height: 8),
                ChatInputWidget(
                  onSendText: (text) async {
                    _replyMessage.value = null;
                  },
                  replyMessage: _replyMessage,
                  enableAttachments: true,
                  enableAudioRecording: true,
                  hintText: 'Reply...',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // With Suggestions
          const ExampleSectionHeader(
            title: 'Floating Suggestions',
            description: '@mentions, #hashtags, /commands',
            icon: Icons.auto_awesome_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Type @ or # or / to trigger',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              onSendText: (text) async {},
              enableAttachments: true,
              enableAudioRecording: false,
              enableFloatingSuggestions: true,
              usernameProvider: (query) async {
                // Simulated username suggestions
                await Future.delayed(const Duration(milliseconds: 300));
                return [
                  FloatingSuggestionItem(
                    label: 'John Doe',
                    subtitle: '@john',
                    value: const ChatUserSuggestion(
                      id: '1',
                      name: 'John Doe',
                      mentionText: '@john',
                    ),
                  ),
                  FloatingSuggestionItem(
                    label: 'Jane Smith',
                    subtitle: '@jane',
                    value: const ChatUserSuggestion(
                      id: '2',
                      name: 'Jane Smith',
                      mentionText: '@jane',
                    ),
                  ),
                ];
              },
              hashtagProvider: (query) async {
                await Future.delayed(const Duration(milliseconds: 300));
                return [
                  FloatingSuggestionItem(
                    label: '#flutter',
                    value: const Hashtag(hashtag: 'flutter'),
                  ),
                  FloatingSuggestionItem(
                    label: '#dart',
                    value: const Hashtag(hashtag: 'dart'),
                  ),
                ];
              },
              quickReplyProvider: (query) async {
                await Future.delayed(const Duration(milliseconds: 300));
                return [
                  FloatingSuggestionItem(
                    label: '/hello',
                    subtitle: 'Send a greeting',
                    value: const QuickReply(
                      command: 'hello',
                      response: 'Hello! How can I help you?',
                    ),
                  ),
                  FloatingSuggestionItem(
                    label: '/thanks',
                    subtitle: 'Send thanks',
                    value: const QuickReply(
                      command: 'thanks',
                      response: 'Thank you for your message!',
                    ),
                  ),
                ];
              },
              hintText: 'Try @, #, or /',
            ),
          ),
          const SizedBox(height: 24),

          // Custom Decoration
          const ExampleSectionHeader(
            title: 'Custom Decoration',
            description: 'Customize input field appearance',
            icon: Icons.palette_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Custom InputDecoration',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              onSendText: (text) async {},
              enableAttachments: true,
              enableAudioRecording: true,
              inputDecoration: InputDecoration(
                hintText: 'Custom styled input...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available ChatInputWidget properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'onSendText',
            value: 'Future<void> Function(String)',
            description: 'Required callback when text is sent',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'enableAttachments',
            value: 'bool (default: true)',
            description: 'Show attachment button',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'enableAudioRecording',
            value: 'bool (default: true)',
            description: 'Enable voice recording button',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'replyMessage',
            value: 'ValueNotifier<ChatReplyData?>?',
            description: 'Reply preview notifier',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'usernameProvider',
            value: 'SuggestionDataProvider?',
            description: 'Provider for @mention suggestions',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'hashtagProvider',
            value: 'SuggestionDataProvider?',
            description: 'Provider for #hashtag suggestions',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'quickReplyProvider',
            value: 'SuggestionDataProvider?',
            description: 'Provider for /command suggestions',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'inputDecoration',
            value: 'InputDecoration?',
            description: 'Custom text field decoration',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''ChatInputWidget(
  onSendText: (text) async {
    await sendMessage(text);
  },
  enableAttachments: true,
  enableAudioRecording: true,
  replyMessage: _replyNotifier,
  onAttachmentSelected: (type) => pickAttachment(type),
  onRecordingComplete: (path, duration, {waveform}) async {
    await sendVoiceMessage(path, duration);
  },
  usernameProvider: (query) => searchUsers(query),
  hashtagProvider: (query) => searchHashtags(query),
  hintText: 'Type a message...',
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

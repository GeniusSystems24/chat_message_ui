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
  bool _recordingLocked = false;

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
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.keyboard_outlined,
            lines: [
              'Walks through chat input configurations and attachments.',
              'Highlights reply preview, recording, and suggestion triggers.',
              'Ideal for tuning input UX before full chat integration.',
            ],
          ),
          const SizedBox(height: 16),
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description:
                'Text input with attachments, voice recording, and suggestions',
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
              onPollRequested: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create poll requested')),
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
              onRecordingLockedChanged: (locked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        locked ? 'Recording locked' : 'Recording unlocked'),
                  ),
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
              onPollRequested: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create poll requested')),
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
                    type: FloatingSuggestionType.username,
                    label: 'John Doe',
                    subtitle: '@john',
                    value: const ChatUserSuggestion(
                      id: '1',
                      name: 'John Doe',
                      username: 'john',
                    ),
                  ),
                  FloatingSuggestionItem(
                    type: FloatingSuggestionType.username,
                    label: 'Jane Smith',
                    subtitle: '@jane',
                    value: const ChatUserSuggestion(
                      id: '2',
                      name: 'Jane Smith',
                      username: 'jane',
                    ),
                  ),
                ];
              },
              hashtagProvider: (query) async {
                await Future.delayed(const Duration(milliseconds: 300));
                return [
                  FloatingSuggestionItem(
                    type: FloatingSuggestionType.hashtag,
                    label: '#flutter',
                    value: Hashtag(id: '1', hashtag: 'flutter'),
                  ),
                  FloatingSuggestionItem(
                    type: FloatingSuggestionType.hashtag,
                    label: '#dart',
                    value: Hashtag(id: '2', hashtag: 'dart'),
                  ),
                ];
              },
              quickReplyProvider: (query) async {
                await Future.delayed(const Duration(milliseconds: 300));
                return [
                  FloatingSuggestionItem(
                    type: FloatingSuggestionType.quickReply,
                    label: '/hello',
                    subtitle: 'Send a greeting',
                    value: QuickReply(
                      id: '1',
                      command: 'hello',
                      response: 'Hello! How can I help you?',
                    ),
                  ),
                  FloatingSuggestionItem(
                    type: FloatingSuggestionType.quickReply,
                    label: '/thanks',
                    subtitle: 'Send thanks',
                    value: QuickReply(
                      id: '2',
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

          // Recording Lock Status
          const ExampleSectionHeader(
            title: 'Recording Lock Feedback',
            description: 'Track recording lock state',
            icon: Icons.lock_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Lock State Monitor',
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _recordingLocked
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _recordingLocked ? Icons.lock : Icons.lock_open,
                        color: _recordingLocked ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _recordingLocked
                            ? 'Recording is locked'
                            : 'Recording not locked',
                        style: TextStyle(
                          color: _recordingLocked ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ChatInputWidget(
                  onSendText: (text) async {},
                  enableAttachments: false,
                  enableAudioRecording: true,
                  onRecordingLockedChanged: (locked) {
                    setState(() => _recordingLocked = locked);
                  },
                  onRecordingComplete: (path, duration, {waveform}) async {
                    setState(() => _recordingLocked = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Recording ${duration}s saved'),
                      ),
                    );
                  },
                  onRecordingCancel: () {
                    setState(() => _recordingLocked = false);
                  },
                  hintText: 'Slide up to lock recording',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Max Length Input
          const ExampleSectionHeader(
            title: 'Input Constraints',
            description: 'Limit message length and show counter',
            icon: Icons.format_size_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'With Max Length (100 chars)',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              onSendText: (text) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sent: $text')),
                );
              },
              enableAttachments: false,
              enableAudioRecording: false,
              hintText: 'Max 100 characters...',
            ),
          ),
          const SizedBox(height: 24),

          // All Callbacks Demo
          const ExampleSectionHeader(
            title: 'Complete Callbacks',
            description: 'Monitor all input events',
            icon: Icons.notifications_active_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'All Event Handlers',
            padding: const EdgeInsets.all(8),
            child: ChatInputWidget(
              onSendText: (text) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✓ Sent: $text')),
                );
              },
              enableAttachments: true,
              enableAudioRecording: true,
              onAttachmentSelected: (type) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('📎 Attachment: ${type.name}')),
                );
              },
              onPollRequested: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📊 Poll requested')),
                );
              },
              onRecordingStart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎤 Recording started')),
                );
              },
              onRecordingComplete: (path, duration, {waveform}) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✓ Recorded ${duration}s (waveform: ${waveform != null ? "yes" : "no"})',
                    ),
                  ),
                );
              },
              onRecordingCancel: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✗ Recording cancelled')),
                );
              },
              onRecordingLockedChanged: (locked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(locked ? '🔒 Locked' : '🔓 Unlocked'),
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              },
              hintText: 'All events monitored...',
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
                fillColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3),
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
            property: 'controller',
            value: 'TextEditingController?',
            description: 'External text controller',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'enableFloatingSuggestions',
            value: 'bool (default: false)',
            description: 'Enable @, #, / suggestions overlay',
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
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onPollRequested',
            value: 'VoidCallback?',
            description: 'Trigger poll creation flow',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onRecordingLockedChanged',
            value: 'ValueChanged<bool>?',
            description: 'Listen to lock/unlock state changes',
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
  onPollRequested: () => openPollBuilder(),
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

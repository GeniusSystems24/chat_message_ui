import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

/// Demo screen for chat input features.
class InputDemoScreen extends StatefulWidget {
  const InputDemoScreen({super.key});

  @override
  State<InputDemoScreen> createState() => _InputDemoScreenState();
}

class _InputDemoScreenState extends State<InputDemoScreen> {
  final List<String> _sentMessages = [];
  final ValueNotifier<ChatReplyData?> _replyMessage = ValueNotifier(null);
  bool _isRecording = false;
  int _recordingDuration = 0;

  @override
  void dispose() {
    _replyMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Widget'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Features card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ChatInputWidget Features',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FeatureItem(
                          icon: Icons.mic,
                          title: 'Voice Recording',
                          description: 'WhatsApp-style voice recording with waveform',
                        ),
                        _FeatureItem(
                          icon: Icons.attach_file,
                          title: 'Attachments',
                          description: 'Multiple attachment sources (camera, gallery, files, etc.)',
                        ),
                        _FeatureItem(
                          icon: Icons.reply,
                          title: 'Reply Preview',
                          description: 'Show reply message preview above input',
                        ),
                        _FeatureItem(
                          icon: Icons.alternate_email,
                          title: 'Mentions (@)',
                          description: 'Username suggestions when typing @',
                        ),
                        _FeatureItem(
                          icon: Icons.tag,
                          title: 'Hashtags (#)',
                          description: 'Hashtag suggestions when typing #',
                        ),
                        _FeatureItem(
                          icon: Icons.flash_on,
                          title: 'Quick Replies (/)',
                          description: 'Quick reply suggestions when typing /',
                        ),
                        _FeatureItem(
                          icon: Icons.link,
                          title: 'Link Preview',
                          description: 'Auto-detect and preview URLs in text',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recording status
                if (_isRecording)
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Recording: ${_formatDuration(_recordingDuration)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Sent messages
                if (_sentMessages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Sent Messages',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(_sentMessages.length, (index) {
                    final msg = _sentMessages[_sentMessages.length - 1 - index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(msg),
                        subtitle: Text('Message ${_sentMessages.length - index}'),
                      ),
                    );
                  }),
                ],

                // Actions
                const SizedBox(height: 16),
                Text(
                  'Try These Actions',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.reply, size: 18),
                      label: const Text('Set Reply'),
                      onPressed: () {
                        _replyMessage.value = const ChatReplyData(
                          id: 'reply_1',
                          senderId: 'user_2',
                          senderName: 'Sara Mohamed',
                          message: 'This is a message to reply to!',
                          type: ChatMessageType.text,
                        );
                      },
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.close, size: 18),
                      label: const Text('Clear Reply'),
                      onPressed: () {
                        _replyMessage.value = null;
                      },
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.delete, size: 18),
                      label: const Text('Clear Messages'),
                      onPressed: () {
                        setState(() {
                          _sentMessages.clear();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Chat Input Widget
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ChatInputWidget(
                onSendText: (text) async {
                  setState(() {
                    _sentMessages.add(text);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sent: $text'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                replyMessage: _replyMessage,
                enableAttachments: true,
                enableAudioRecording: true,
                hintText: 'Type a message...',
                onAttachmentSelected: (type) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected: ${type.name}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onRecordingStart: () {
                  setState(() {
                    _isRecording = true;
                    _recordingDuration = 0;
                  });
                  _startRecordingTimer();
                },
                onRecordingComplete: (path, duration, {waveform}) async {
                  setState(() {
                    _isRecording = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Recording complete: ${_formatDuration(duration)}'
                        '${waveform != null ? ' (with waveform: ${waveform.length} points)' : ''}',
                      ),
                    ),
                  );
                },
                onRecordingCancel: () {
                  setState(() {
                    _isRecording = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recording cancelled')),
                  );
                },
                usernameProvider: (query) async {
                  // Simulate username suggestions
                  await Future.delayed(const Duration(milliseconds: 200));
                  return [
                    FloatingSuggestionItem(
                      label: 'Ahmed Hassan',
                      subtitle: '@ahmed_h',
                      value: ChatUserSuggestion(
                        id: '1',
                        name: 'Ahmed Hassan',
                        username: 'ahmed_h',
                      ),
                    ),
                    FloatingSuggestionItem(
                      label: 'Sara Mohamed',
                      subtitle: '@sara_m',
                      value: ChatUserSuggestion(
                        id: '2',
                        name: 'Sara Mohamed',
                        username: 'sara_m',
                      ),
                    ),
                    FloatingSuggestionItem(
                      label: 'Omar Ali',
                      subtitle: '@omar_a',
                      value: ChatUserSuggestion(
                        id: '3',
                        name: 'Omar Ali',
                        username: 'omar_a',
                      ),
                    ),
                  ];
                },
                hashtagProvider: (query) async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  return [
                    FloatingSuggestionItem(
                      label: '#flutter',
                      value: Hashtag(hashtag: 'flutter'),
                    ),
                    FloatingSuggestionItem(
                      label: '#dart',
                      value: Hashtag(hashtag: 'dart'),
                    ),
                    FloatingSuggestionItem(
                      label: '#mobile',
                      value: Hashtag(hashtag: 'mobile'),
                    ),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startRecordingTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isRecording) return false;
      setState(() {
        _recordingDuration++;
      });
      return _isRecording;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

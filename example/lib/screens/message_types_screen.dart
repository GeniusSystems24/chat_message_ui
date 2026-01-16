import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/sample_data.dart';

/// Demo screen showing all message types.
class MessageTypesScreen extends StatelessWidget {
  const MessageTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChatTheme(
      data: ChatThemeData.fromTheme(theme),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Message Types'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader(title: 'Text Messages'),
            ...sampleTextMessages.map((msg) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MessageBubble(
                    message: msg,
                    currentUserId: currentUserId,
                    showAvatar: true,
                    showStatus: true,
                    showTimestamp: true,
                  ),
                )),

            _SectionHeader(title: 'Image Messages'),
            ...sampleImageMessages.map((msg) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MessageBubble(
                    message: msg,
                    currentUserId: currentUserId,
                    showAvatar: true,
                  ),
                )),

            _SectionHeader(title: 'Audio Messages'),
            ...sampleAudioMessages.map((msg) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MessageBubble(
                    message: msg,
                    currentUserId: currentUserId,
                    showAvatar: true,
                  ),
                )),

            _SectionHeader(title: 'Video Messages'),
            ...sampleVideoMessages.map((msg) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MessageBubble(
                    message: msg,
                    currentUserId: currentUserId,
                    showAvatar: true,
                  ),
                )),

            _SectionHeader(title: 'Document Messages'),
            ...sampleDocumentMessages.map((msg) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MessageBubble(
                    message: msg,
                    currentUserId: currentUserId,
                    showAvatar: true,
                  ),
                )),

            _SectionHeader(title: 'Contact Message'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MessageBubble(
                message: sampleContactMessage,
                currentUserId: currentUserId,
                showAvatar: true,
              ),
            ),

            _SectionHeader(title: 'Location Message'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MessageBubble(
                message: sampleLocationMessage,
                currentUserId: currentUserId,
                showAvatar: true,
              ),
            ),

            _SectionHeader(title: 'Poll Message'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MessageBubble(
                message: samplePollMessage,
                currentUserId: currentUserId,
                showAvatar: true,
              ),
            ),

            _SectionHeader(title: 'Deleted Message'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MessageBubble(
                message: sampleDeletedMessage,
                currentUserId: currentUserId,
                showAvatar: true,
              ),
            ),

            _SectionHeader(title: 'Forwarded Message'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MessageBubble(
                message: sampleForwardedMessage,
                currentUserId: currentUserId,
                showAvatar: true,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

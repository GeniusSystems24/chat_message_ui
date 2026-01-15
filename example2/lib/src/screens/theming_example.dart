import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';

class ThemingExample extends StatefulWidget {
  const ThemingExample({super.key});

  @override
  State<ThemingExample> createState() => _ThemingExampleState();
}

class _ThemingExampleState extends State<ThemingExample> {
  late final ExamplePaginationHelper<Widget> _pagination;

  @override
  void initState() {
    super.initState();
    final messages = ExampleSampleData.buildMessages();
    final sampleMessages = messages
        .where((message) => message.type == ChatMessageType.text)
        .take(2)
        .toList();

    final baseTheme = ThemeData.from(
      colorScheme: ThemeData.light().colorScheme,
      useMaterial3: true,
    );
    final vibrantChatTheme = ChatThemeData.light().copyWith(
      colors: const ChatColors.light().copyWith(
        primary: Colors.teal,
        surfaceContainerHigh: Color(0xFFF0F7F5),
      ),
      messageBubble: const MessageBubbleTheme.light().copyWith(
        minBubbleWidth: 120,
      ),
    );

    final darkChatTheme = ChatThemeData.dark().copyWith(
      colors: const ChatColors.dark().copyWith(
        primary: Color(0xFF8C7CFF),
        surfaceContainerHigh: Color(0xFF1F1F26),
      ),
      messageBubble: const MessageBubbleTheme.dark().copyWith(
        minBubbleWidth: 120,
      ),
    );

    final items = <Widget>[
      _ThemeShowcaseCard(
        title: 'Vibrant Light',
        subtitle: 'Teal accents with elevated bubbles.',
        theme: baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(primary: Colors.teal),
          extensions: <ThemeExtension<dynamic>>[vibrantChatTheme],
        ),
        messages: sampleMessages,
      ),
      const SizedBox(height: 20),
      _ThemeShowcaseCard(
        title: 'Studio Dark',
        subtitle: 'High contrast with soft purple highlights.',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8C7CFF),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          extensions: <ThemeExtension<dynamic>>[darkChatTheme],
        ),
        messages: sampleMessages,
      ),
    ];

    _pagination = ExamplePaginationHelper<Widget>(items: items, pageSize: 10);
    _pagination.cubit.fetchPaginatedList();
  }

  @override
  void dispose() {
    _pagination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theming')),
      body: SmartPaginationListView.withCubit(
        cubit: _pagination.cubit,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, items, index) => items[index],
      ),
    );
  }
}

class _ThemeShowcaseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ThemeData theme;
  final List<IChatMessageData> messages;

  const _ThemeShowcaseCard({
    required this.title,
    required this.subtitle,
    required this.theme,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final localTheme = Theme.of(context);
          return Card(
            color: localTheme.colorScheme.surface,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: localTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: localTheme.textTheme.bodySmall?.copyWith(
                      color: localTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...messages.map(
                    (message) => MessageBubble(
                      message: message,
                      currentUserId: ExampleSampleData.currentUserId,
                      showAvatar: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ChatInputWidget(
                    onSendText: (_) async {},
                    hintText: 'Preview input styling...',
                    enableAttachments: false,
                    enableAudioRecording: false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

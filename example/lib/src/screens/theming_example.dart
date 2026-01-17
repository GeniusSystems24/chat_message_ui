import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

/// Demonstrates theme customization capabilities.
///
/// Features demonstrated:
/// - ChatThemeData configurations (light, dark, high contrast)
/// - ChatAppBar theming across different themes
/// - ChatSelectionAppBar theming
/// - MessageBubbleTheme customization
/// - ChatColors customization
/// - InputTheme customization
/// - PinnedMessagesBar theming
class ThemingExample extends StatefulWidget {
  const ThemingExample({super.key});

  @override
  State<ThemingExample> createState() => _ThemingExampleState();
}

class _ThemingExampleState extends State<ThemingExample> {
  late final ExamplePaginationHelper<Widget> _pagination;
  late final List<IChatMessageData> _pinnedMessages;
  int _pinnedIndex = 0;
  Set<IChatMessageData> _selectedMessages = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    final messages = ExampleSampleData.buildMessages();
    // الرسائل المثبتة والمعروضة هي نفسها
    final sampleMessages = messages
        .where((message) => message.type == ChatMessageType.text)
        .take(2)
        .toList();
    _pinnedMessages = sampleMessages;

    // Vibrant Light Theme
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

    // Studio Dark Theme
    final darkChatTheme = ChatThemeData.dark().copyWith(
      colors: const ChatColors.dark().copyWith(
        primary: Color(0xFF8C7CFF),
        surfaceContainerHigh: Color(0xFF1F1F26),
      ),
      messageBubble: const MessageBubbleTheme.dark().copyWith(
        minBubbleWidth: 120,
      ),
    );

    // High Contrast Theme
    final highContrastChatTheme = ChatThemeData.light().copyWith(
      colors: const ChatColors.light().copyWith(
        primary: Colors.black,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainerHigh: Color(0xFFF5F5F5),
      ),
      messageBubble: const MessageBubbleTheme.light().copyWith(
        sender: const BubbleConfig(
          backgroundColor: Colors.black,
          textColor: Colors.white,
        ),
        receiver: const BubbleConfig(
          backgroundColor: Color(0xFFE0E0E0),
          textColor: Colors.black,
        ),
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
        onSelect: _toggleSelectionForShowcase,
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
        onSelect: _toggleSelectionForShowcase,
      ),
      const SizedBox(height: 20),
      _ThemeShowcaseCard(
        title: 'High Contrast',
        subtitle: 'Maximum readability with black/white palette.',
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          extensions: <ThemeExtension<dynamic>>[highContrastChatTheme],
        ),
        messages: sampleMessages,
        onSelect: _toggleSelectionForShowcase,
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

  void _toggleSelectionForShowcase(IChatMessageData message) {
    setState(() {
      if (_selectedMessages.contains(message)) {
        _selectedMessages.remove(message);
        if (_selectedMessages.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedMessages.add(message);
        _isSelectionMode = true;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedMessages = {};
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget currentAppBar = _isSelectionMode
        ? ChatSelectionAppBar(
            selectedCount: _selectedMessages.length,
            selectedMessages: _selectedMessages,
            currentUserId: ExampleSampleData.currentUserId,
            onClose: _clearSelection,
            onReply: (msg) {
              _showSnackBar('Reply to: ${msg.textContent}');
              _clearSelection();
            },
            onCopy: () {
              _showSnackBar('Copied ${_selectedMessages.length} messages');
              _clearSelection();
            },
            onForward: (msgs) {
              _showSnackBar('Forward ${msgs.length} messages');
              _clearSelection();
            },
            onDelete: (msgs) {
              _showSnackBar('Deleted ${msgs.length} messages');
              _clearSelection();
            },
          ) as PreferredSizeWidget
        : ChatAppBar(
            chat: const ChatAppBarData(
              id: 'theming_demo',
              title: 'Theming',
              subtitle: 'Theme customization demo',
              imageUrl: 'https://i.pravatar.cc/150?img=30',
            ),
            showSearch: false,
            showMenu: true,
            menuItems: const [
              PopupMenuItem(
                value: 'light',
                child: Row(
                  children: [
                    Icon(Icons.light_mode),
                    SizedBox(width: 8),
                    Text('Apply Light Theme'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'dark',
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Apply Dark Theme'),
                  ],
                ),
              ),
            ],
            onMenuSelection: (value) =>
                _showSnackBar('Theme switching: $value'),
            additionalActions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'Screen Overview',
                onPressed: () => ExampleDescription.showAsBottomSheet(
                  context,
                  title: 'Screen Overview',
                  icon: Icons.palette_outlined,
                  lines: const [
                    'Compares multiple ChatThemeData configurations.',
                    'Includes Vibrant Light, Studio Dark, and High Contrast.',
                    'Long-press bubbles to see ChatSelectionAppBar theming.',
                    'Shows how bubbles and inputs adapt to theme extensions.',
                  ],
                ),
              ),
            ],
          );

    return Scaffold(
      appBar: currentAppBar,
      body: Column(
        children: [
          if (_pinnedMessages.isNotEmpty)
            PinnedMessagesBar(
              message: _pinnedMessages[_pinnedIndex],
              index: _pinnedIndex,
              total: _pinnedMessages.length,
              onTap: () {
                setState(() {
                  _pinnedIndex = (_pinnedIndex + 1) % _pinnedMessages.length;
                });
                _showSnackBar('Jump to: ${_pinnedMessages[_pinnedIndex].id}');
              },
            ),
          Expanded(
            child: SmartPaginationListView.withCubit(
              cubit: _pagination.cubit,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, items, index) => items[index],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ThemeShowcaseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ThemeData theme;
  final List<IChatMessageData> messages;
  final void Function(IChatMessageData)? onSelect;

  const _ThemeShowcaseCard({
    required this.title,
    required this.subtitle,
    required this.theme,
    required this.messages,
    this.onSelect,
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
                  Row(
                    children: [
                      Expanded(
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
                          ],
                        ),
                      ),
                      // Mini ChatAppBar preview
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: localTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 16,
                              color: localTheme.colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AppBar',
                              style: localTheme.textTheme.labelSmall?.copyWith(
                                color:
                                    localTheme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...messages.map(
                    (message) => GestureDetector(
                      onLongPress: () => onSelect?.call(message),
                      child: MessageBubble(
                        message: message,
                        currentUserId: ExampleSampleData.currentUserId,
                        showAvatar: true,
                      ),
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

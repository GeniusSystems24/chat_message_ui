import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/mock_message.dart';
import '../data/sample_data.dart';

/// Demo screen for theming features.
class ThemeDemoScreen extends StatefulWidget {
  const ThemeDemoScreen({super.key});

  @override
  State<ThemeDemoScreen> createState() => _ThemeDemoScreenState();
}

class _ThemeDemoScreenState extends State<ThemeDemoScreen> {
  // Theme customization
  Color _primaryColor = Colors.blue;
  Color _senderBubbleColor = Colors.blue.shade100;
  Color _receiverBubbleColor = Colors.grey.shade200;
  double _bubbleRadius = 16.0;
  double _avatarSize = 15.0;
  bool _showShadow = true;

  // Preset themes
  final List<_ThemePreset> _presets = [
    _ThemePreset(
      name: 'Default',
      primary: Colors.blue,
      senderBubble: Colors.blue.shade100,
      receiverBubble: Colors.grey.shade200,
    ),
    _ThemePreset(
      name: 'WhatsApp',
      primary: const Color(0xFF25D366),
      senderBubble: const Color(0xFFDCF8C6),
      receiverBubble: Colors.white,
    ),
    _ThemePreset(
      name: 'Telegram',
      primary: const Color(0xFF0088CC),
      senderBubble: const Color(0xFFEFFFDE),
      receiverBubble: Colors.white,
    ),
    _ThemePreset(
      name: 'Messenger',
      primary: const Color(0xFF0084FF),
      senderBubble: const Color(0xFF0084FF),
      receiverBubble: const Color(0xFFE4E6EB),
    ),
    _ThemePreset(
      name: 'Discord',
      primary: const Color(0xFF5865F2),
      senderBubble: const Color(0xFF5865F2),
      receiverBubble: const Color(0xFF2F3136),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);

    // Create custom chat theme
    final chatTheme = ChatThemeData(
      colors: ChatThemeColors(
        primary: _primaryColor,
        surfaceContainer: _receiverBubbleColor,
      ),
      messageBubble: MessageBubbleTheme(
        senderBubbleColor: _senderBubbleColor,
        receiverBubbleColor: _receiverBubbleColor,
        bubbleRadius: _bubbleRadius,
        showShadow: _showShadow,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theming'),
      ),
      body: ChatTheme(
        data: chatTheme,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Preset Themes
            Text(
              'Preset Themes',
              style: baseTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _presets.length,
                itemBuilder: (context, index) {
                  final preset = _presets[index];
                  final isSelected = _primaryColor == preset.primary;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _primaryColor = preset.primary;
                        _senderBubbleColor = preset.senderBubble;
                        _receiverBubbleColor = preset.receiverBubble;
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: preset.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? preset.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: preset.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            preset.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Custom Colors
            Text(
              'Custom Colors',
              style: baseTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _ColorPicker(
                      label: 'Primary Color',
                      color: _primaryColor,
                      onColorChanged: (color) => setState(() => _primaryColor = color),
                    ),
                    const SizedBox(height: 12),
                    _ColorPicker(
                      label: 'Sender Bubble',
                      color: _senderBubbleColor,
                      onColorChanged: (color) => setState(() => _senderBubbleColor = color),
                    ),
                    const SizedBox(height: 12),
                    _ColorPicker(
                      label: 'Receiver Bubble',
                      color: _receiverBubbleColor,
                      onColorChanged: (color) => setState(() => _receiverBubbleColor = color),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Styling Options
            Text(
              'Styling Options',
              style: baseTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Bubble Radius
                    Row(
                      children: [
                        const Text('Bubble Radius'),
                        Expanded(
                          child: Slider(
                            value: _bubbleRadius,
                            min: 0,
                            max: 32,
                            divisions: 16,
                            onChanged: (value) => setState(() => _bubbleRadius = value),
                          ),
                        ),
                        Text('${_bubbleRadius.toInt()}'),
                      ],
                    ),
                    // Avatar Size
                    Row(
                      children: [
                        const Text('Avatar Size'),
                        Expanded(
                          child: Slider(
                            value: _avatarSize,
                            min: 10,
                            max: 30,
                            divisions: 10,
                            onChanged: (value) => setState(() => _avatarSize = value),
                          ),
                        ),
                        Text('${_avatarSize.toInt()}'),
                      ],
                    ),
                    // Show Shadow
                    SwitchListTile(
                      title: const Text('Show Shadow'),
                      value: _showShadow,
                      onChanged: (value) => setState(() => _showShadow = value),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Preview
            Text(
              'Preview',
              style: baseTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: baseTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Received message
                  MessageBubble(
                    message: MockChatMessage(
                      id: 'preview_1',
                      chatId: 'chat_1',
                      senderId: 'user_2',
                      type: ChatMessageType.text,
                      textContent: 'Hello! This is a preview of the custom theme.',
                      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
                      status: ChatMessageStatus.read,
                      senderData: sender2,
                    ),
                    currentUserId: currentUserId,
                    showAvatar: true,
                    avatarSize: _avatarSize,
                  ),
                  const SizedBox(height: 8),
                  // Sent message
                  MessageBubble(
                    message: MockChatMessage(
                      id: 'preview_2',
                      chatId: 'chat_1',
                      senderId: currentUserId,
                      type: ChatMessageType.text,
                      textContent: 'Looking great! The theme is applied.',
                      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
                      status: ChatMessageStatus.read,
                      senderData: sender1,
                      reactions: const [
                        ChatReactionData(emoji: '👍', userId: 'user_2'),
                      ],
                    ),
                    currentUserId: currentUserId,
                    showAvatar: true,
                    avatarSize: _avatarSize,
                  ),
                  const SizedBox(height: 8),
                  // Image message
                  MessageBubble(
                    message: MockChatMessage(
                      id: 'preview_3',
                      chatId: 'chat_1',
                      senderId: 'user_2',
                      type: ChatMessageType.image,
                      textContent: 'Check this out!',
                      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
                      status: ChatMessageStatus.read,
                      senderData: sender2,
                      mediaData: const ChatMediaData(
                        url: 'https://picsum.photos/400/300',
                        mediaType: ChatMessageType.image,
                      ),
                    ),
                    currentUserId: currentUserId,
                    showAvatar: true,
                    avatarSize: _avatarSize,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ChatThemeData Properties
            Text(
              'ChatThemeData Properties',
              style: baseTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PropertyItem(name: 'ChatThemeColors', description: 'Primary, surface, and text colors'),
                    _PropertyItem(name: 'MessageBubbleTheme', description: 'Bubble colors, radius, padding, shadow'),
                    _PropertyItem(name: 'ChatTypography', description: 'Text styles for all elements'),
                    _PropertyItem(name: 'ChatReactionsTheme', description: 'Reaction chip styling'),
                    _PropertyItem(name: 'ChatSpacing', description: 'Spacing between elements'),
                    _PropertyItem(name: 'ChatAvatarTheme', description: 'Avatar size and styling'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ThemePreset {
  final String name;
  final Color primary;
  final Color senderBubble;
  final Color receiverBubble;

  const _ThemePreset({
    required this.name,
    required this.primary,
    required this.senderBubble,
    required this.receiverBubble,
  });
}

class _ColorPicker extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const _ColorPicker({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  static const _colors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label),
        ),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                final c = _colors[index];
                final isSelected = color.value == c.value ||
                    color.value == c.shade100.value ||
                    color.value == c.shade200.value;
                return GestureDetector(
                  onTap: () => onColorChanged(c),
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PropertyItem extends StatelessWidget {
  final String name;
  final String description;

  const _PropertyItem({
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$name: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

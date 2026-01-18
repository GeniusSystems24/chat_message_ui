import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_message.dart';
import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

/// Demonstrates all chat configuration options.
///
/// Features demonstrated:
/// - ChatMessageUiConfig settings
/// - ChatPaginationConfig options
/// - ChatAutoDownloadConfig policies
/// - Theme customization
/// - Real-time preview of settings changes
class ChatSettingsExample extends StatefulWidget {
  const ChatSettingsExample({super.key});

  @override
  State<ChatSettingsExample> createState() => _ChatSettingsExampleState();
}

class _ChatSettingsExampleState extends State<ChatSettingsExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ExampleMessage> _messages;
  late ExamplePaginationHelper<ExampleMessage> _pagination;

  // ═══════════════════════════════════════════════════════════════════════════
  // ChatMessageUiConfig Settings
  // ═══════════════════════════════════════════════════════════════════════════
  bool _enableSuggestions = true;
  bool _enableTextPreview = true;

  // ═══════════════════════════════════════════════════════════════════════════
  // ChatAutoDownloadConfig Settings
  // ═══════════════════════════════════════════════════════════════════════════
  AutoDownloadPolicy _imagePolicy = AutoDownloadPolicy.never;
  AutoDownloadPolicy _videoPolicy = AutoDownloadPolicy.never;
  AutoDownloadPolicy _audioPolicy = AutoDownloadPolicy.always;
  AutoDownloadPolicy _documentPolicy = AutoDownloadPolicy.never;

  // ═══════════════════════════════════════════════════════════════════════════
  // ChatPaginationConfig Settings
  // ═══════════════════════════════════════════════════════════════════════════
  MessagesGroupingMode _groupingMode = MessagesGroupingMode.sameMinute;
  int _groupingTimeout = 300;
  List<String> _availableReactions = ['👍', '❤️', '😂', '😮', '😢', '😡'];

  // ═══════════════════════════════════════════════════════════════════════════
  // Theme Settings
  // ═══════════════════════════════════════════════════════════════════════════
  bool _useDarkTheme = false;
  Color _primaryColor = const Color(0xFF974EE9);
  double _bubbleBorderRadius = 16.0;
  double _avatarSize = 32.0;
  double _reactionEmojiSize = 14.0;
  double _statusIconSize = 12.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // Input Theme Settings
  // ═══════════════════════════════════════════════════════════════════════════
  double _inputBorderRadius = 25.0;
  double _inputHeight = 50.0;
  int _inputMaxLines = 5;

  // ═══════════════════════════════════════════════════════════════════════════
  // Display Settings
  // ═══════════════════════════════════════════════════════════════════════════
  bool _showAvatar = true;
  bool _showTimestamp = true;
  bool _showStatus = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _messages = _buildDemoMessages();
    _pagination = ExamplePaginationHelper<ExampleMessage>(
      items: _messages,
      pageSize: 10,
    );
    _pagination.cubit.fetchPaginatedList();
  }

  List<ExampleMessage> _buildDemoMessages() {
    final now = DateTime.now();
    return [
      ExampleMessage(
        id: 'settings_1',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'مرحباً! هذه رسالة تجريبية لمعاينة الإعدادات.',
        createdAt: now.subtract(const Duration(minutes: 10)),
        status: ChatMessageStatus.read,
        reactions: const [
          ChatReactionData(emoji: '👍', userId: 'user_1', createdAt: null),
          ChatReactionData(emoji: '❤️', userId: 'user_2', createdAt: null),
        ],
      ),
      ExampleMessage(
        id: 'settings_2',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'شكراً! جرب تعديل الإعدادات وشاهد التغييرات.',
        createdAt: now.subtract(const Duration(minutes: 8)),
        status: ChatMessageStatus.delivered,
        isPinned: true,
      ),
      ExampleMessage(
        id: 'settings_3',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.text,
        textContent: 'رائع! المكتبة قابلة للتخصيص بشكل كامل 🎨',
        createdAt: now.subtract(const Duration(minutes: 5)),
        status: ChatMessageStatus.read,
        isStarred: true,
      ),
      ExampleMessage(
        id: 'settings_4',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'نعم، يمكنك تخصيص الألوان والأحجام والسلوكيات.',
        createdAt: now.subtract(const Duration(minutes: 2)),
        status: ChatMessageStatus.sent,
        isSaved: true,
        isEdited: true,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagination.dispose();
    super.dispose();
  }

  ChatMessageUiConfig _buildConfig() {
    return ChatMessageUiConfig(
      enableSuggestions: _enableSuggestions,
      enableTextPreview: _enableTextPreview,
      autoDownload: ChatAutoDownloadConfig(
        image: _imagePolicy,
        video: _videoPolicy,
        audio: _audioPolicy,
        document: _documentPolicy,
      ),
      pagination: ChatPaginationConfig(
        messagesGroupingMode: _groupingMode,
        messagesGroupingTimeoutInSeconds: _groupingTimeout,
        availableReactions: _availableReactions,
      ),
    );
  }

  ChatThemeData _buildTheme(BuildContext context) {
    final baseTheme =
        _useDarkTheme ? ChatThemeData.dark() : ChatThemeData.light();

    return baseTheme.copyWith(
      colors: baseTheme.colors.copyWith(
        primary: _primaryColor,
      ),
      messageBubble: baseTheme.messageBubble.copyWith(
        contentPadding: 12,
        borderRadius: _bubbleBorderRadius,
      ),
      avatar: baseTheme.avatar.copyWith(
        defaultSize: _avatarSize,
      ),
      reactions: baseTheme.reactions.copyWith(
        emojiSize: _reactionEmojiSize,
      ),
      status: baseTheme.status.copyWith(
        iconSize: _statusIconSize,
      ),
      input: baseTheme.input.copyWith(
        borderRadius: _inputBorderRadius,
        inputHeight: _inputHeight,
        maxLines: _inputMaxLines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => ExampleDescription.showAsBottomSheet(
              context,
              title: 'Screen Overview',
              icon: Icons.settings_outlined,
              lines: const [
                'Interactive chat configuration demo.',
                'Modify settings and see changes in real-time.',
                'Covers: General, Auto-Download, Pagination, Theme.',
                'Preview panel shows settings effect.',
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.tune), text: 'General'),
            Tab(icon: Icon(Icons.download), text: 'Download'),
            Tab(icon: Icon(Icons.view_list), text: 'Pagination'),
            Tab(icon: Icon(Icons.palette), text: 'Theme'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Settings Tabs
          Expanded(
            flex: 2,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralSettings(),
                _buildAutoDownloadSettings(),
                _buildPaginationSettings(),
                _buildThemeSettings(),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Preview Section
          Expanded(
            flex: 3,
            child: _buildPreview(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // General Settings Tab
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildGeneralSettings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('ChatMessageUiConfig'),
        SwitchListTile(
          title: const Text('Enable Suggestions'),
          subtitle: const Text('@mentions, #hashtags, /commands'),
          value: _enableSuggestions,
          onChanged: (value) => setState(() => _enableSuggestions = value),
        ),
        SwitchListTile(
          title: const Text('Enable Text Preview'),
          subtitle: const Text('Link previews in messages'),
          value: _enableTextPreview,
          onChanged: (value) => setState(() => _enableTextPreview = value),
        ),
        const Divider(),
        _buildSectionHeader('Display Options'),
        SwitchListTile(
          title: const Text('Show Avatar'),
          subtitle: const Text('Display sender avatar'),
          value: _showAvatar,
          onChanged: (value) => setState(() => _showAvatar = value),
        ),
        SwitchListTile(
          title: const Text('Show Timestamp'),
          subtitle: const Text('Display message time'),
          value: _showTimestamp,
          onChanged: (value) => setState(() => _showTimestamp = value),
        ),
        SwitchListTile(
          title: const Text('Show Status'),
          subtitle: const Text('Display delivery status icon'),
          value: _showStatus,
          onChanged: (value) => setState(() => _showStatus = value),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Auto-Download Settings Tab
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildAutoDownloadSettings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('ChatAutoDownloadConfig'),
        const Text(
          'Control automatic media download behavior',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        _buildPolicyTile(
          'Images',
          Icons.image_outlined,
          _imagePolicy,
          (value) => setState(() => _imagePolicy = value),
        ),
        _buildPolicyTile(
          'Videos',
          Icons.videocam_outlined,
          _videoPolicy,
          (value) => setState(() => _videoPolicy = value),
        ),
        _buildPolicyTile(
          'Audio',
          Icons.audiotrack_outlined,
          _audioPolicy,
          (value) => setState(() => _audioPolicy = value),
        ),
        _buildPolicyTile(
          'Documents',
          Icons.description_outlined,
          _documentPolicy,
          (value) => setState(() => _documentPolicy = value),
        ),
        const SizedBox(height: 16),
        _buildPolicyLegend(),
      ],
    );
  }

  Widget _buildPolicyTile(
    String title,
    IconData icon,
    AutoDownloadPolicy current,
    ValueChanged<AutoDownloadPolicy> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: SegmentedButton<AutoDownloadPolicy>(
        segments: const [
          ButtonSegment(
            value: AutoDownloadPolicy.never,
            label: Text('Never'),
          ),
          ButtonSegment(
            value: AutoDownloadPolicy.wifiOnly,
            label: Text('WiFi'),
          ),
          ButtonSegment(
            value: AutoDownloadPolicy.always,
            label: Text('Always'),
          ),
        ],
        selected: {current},
        onSelectionChanged: (set) => onChanged(set.first),
      ),
    );
  }

  Widget _buildPolicyLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Policy Legend:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('• Never: Manual download only'),
          Text('• WiFi: Auto-download on WiFi (future)'),
          Text('• Always: Auto-download immediately'),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Pagination Settings Tab
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPaginationSettings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('ChatPaginationConfig'),
        const SizedBox(height: 8),
        ListTile(
          title: const Text('Messages Grouping Mode'),
          subtitle: Text(_groupingMode.name),
          trailing: DropdownButton<MessagesGroupingMode>(
            value: _groupingMode,
            onChanged: (value) {
              if (value != null) setState(() => _groupingMode = value);
            },
            items: MessagesGroupingMode.values.map((mode) {
              return DropdownMenuItem(
                value: mode,
                child: Text(mode.name),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Grouping Timeout (seconds)'),
          subtitle: Text('$_groupingTimeout seconds'),
          trailing: SizedBox(
            width: 150,
            child: Slider(
              value: _groupingTimeout.toDouble(),
              min: 60,
              max: 600,
              divisions: 9,
              label: '$_groupingTimeout',
              onChanged: (value) =>
                  setState(() => _groupingTimeout = value.toInt()),
            ),
          ),
        ),
        const Divider(),
        _buildSectionHeader('Available Reactions'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._availableReactions.map((emoji) => _buildReactionChip(emoji)),
            ActionChip(
              label: const Text('+ Add'),
              onPressed: _showAddReactionDialog,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildReactionPresets(),
      ],
    );
  }

  Widget _buildReactionChip(String emoji) {
    return InputChip(
      label: Text(emoji, style: const TextStyle(fontSize: 18)),
      onDeleted: () {
        setState(() {
          _availableReactions = List.from(_availableReactions)..remove(emoji);
        });
      },
    );
  }

  Widget _buildReactionPresets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Presets:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ActionChip(
              label: const Text('Default'),
              onPressed: () => setState(() {
                _availableReactions = ['👍', '❤️', '😂', '😮', '😢', '😡'];
              }),
            ),
            ActionChip(
              label: const Text('WhatsApp'),
              onPressed: () => setState(() {
                _availableReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];
              }),
            ),
            ActionChip(
              label: const Text('Minimal'),
              onPressed: () => setState(() {
                _availableReactions = ['👍', '👎', '❤️'];
              }),
            ),
            ActionChip(
              label: const Text('Extended'),
              onPressed: () => setState(() {
                _availableReactions = [
                  '👍',
                  '❤️',
                  '😂',
                  '😮',
                  '😢',
                  '😡',
                  '🔥',
                  '🎉',
                  '👏',
                  '🙏'
                ];
              }),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddReactionDialog() {
    final allEmojis = [
      '😀',
      '😃',
      '😄',
      '😁',
      '😆',
      '😅',
      '🤣',
      '😂',
      '🙂',
      '🙃',
      '😉',
      '😊',
      '😇',
      '🥰',
      '😍',
      '🤩',
      '😘',
      '😗',
      '😚',
      '😙',
      '🥲',
      '😋',
      '😛',
      '😜',
      '🤪',
      '😝',
      '🤑',
      '🤗',
      '🤭',
      '🤫',
      '🤔',
      '🤐',
      '🤨',
      '😐',
      '😑',
      '😶',
      '😏',
      '😒',
      '🙄',
      '😬',
      '😮',
      '🥺',
      '😢',
      '😭',
      '😤',
      '😠',
      '😡',
      '🤬',
      '😈',
      '👿',
      '💀',
      '☠️',
      '💩',
      '🤡',
      '👹',
      '👺',
      '👻',
      '👽',
      '👾',
      '🤖',
      '😺',
      '😸',
      '😹',
      '😻',
      '😼',
      '😽',
      '🙀',
      '😿',
      '😾',
      '👍',
      '👎',
      '👊',
      '✊',
      '🤛',
      '🤜',
      '👏',
      '🙌',
      '👐',
      '🤲',
      '🤝',
      '🙏',
      '✌️',
      '🤞',
      '🤟',
      '🤘',
      '🤙',
      '👋',
      '🖐️',
      '✋',
      '🖖',
      '❤️',
      '🧡',
      '💛',
      '💚',
      '💙',
      '💜',
      '🖤',
      '🤍',
      '🤎',
      '💔',
      '❣️',
      '💕',
      '💞',
      '💓',
      '💗',
      '💖',
      '💘',
      '💝',
      '🔥',
      '💯',
      '⭐',
      '🌟',
      '✨',
      '💫',
      '🎉',
      '🎊',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Emoji',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: allEmojis.length,
                itemBuilder: (context, index) {
                  final emoji = allEmojis[index];
                  final isSelected = _availableReactions.contains(emoji);
                  return GestureDetector(
                    onTap: isSelected
                        ? null
                        : () {
                            setState(() {
                              _availableReactions =
                                  List.from(_availableReactions)..add(emoji);
                            });
                            Navigator.pop(context);
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.withValues(alpha: 0.3)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        emoji,
                        style: TextStyle(
                          fontSize: 24,
                          color: isSelected ? Colors.grey : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Theme Settings Tab
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildThemeSettings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Base Theme'),
        SwitchListTile(
          title: const Text('Dark Theme'),
          subtitle: const Text('Toggle between light and dark'),
          value: _useDarkTheme,
          onChanged: (value) => setState(() => _useDarkTheme = value),
        ),
        const Divider(),
        _buildSectionHeader('Colors'),
        ListTile(
          title: const Text('Primary Color'),
          trailing: _buildColorPicker(_primaryColor, (color) {
            setState(() => _primaryColor = color);
          }),
        ),
        const Divider(),
        _buildSectionHeader('Dimensions'),
        _buildSliderTile(
          'Bubble Border Radius',
          _bubbleBorderRadius,
          0,
          30,
          (value) => setState(() => _bubbleBorderRadius = value),
        ),
        _buildSliderTile(
          'Avatar Size',
          _avatarSize,
          20,
          60,
          (value) => setState(() => _avatarSize = value),
        ),
        _buildSliderTile(
          'Reaction Emoji Size',
          _reactionEmojiSize,
          10,
          24,
          (value) => setState(() => _reactionEmojiSize = value),
        ),
        _buildSliderTile(
          'Status Icon Size',
          _statusIconSize,
          8,
          20,
          (value) => setState(() => _statusIconSize = value),
        ),
        const Divider(),
        _buildSectionHeader('Input Theme'),
        _buildSliderTile(
          'Input Border Radius',
          _inputBorderRadius,
          0,
          40,
          (value) => setState(() => _inputBorderRadius = value),
        ),
        _buildSliderTile(
          'Input Height',
          _inputHeight,
          40,
          80,
          (value) => setState(() => _inputHeight = value),
        ),
        _buildSliderTile(
          'Max Input Lines',
          _inputMaxLines.toDouble(),
          1,
          10,
          (value) => setState(() => _inputMaxLines = value.toInt()),
        ),
      ],
    );
  }

  Widget _buildColorPicker(Color current, ValueChanged<Color> onChanged) {
    final colors = [
      const Color(0xFF974EE9), // Purple (default)
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];

    return Wrap(
      spacing: 4,
      children: colors.map((color) {
        final isSelected = color.value == current.value;
        return GestureDetector(
          onTap: () => onChanged(color),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: color, blurRadius: 4)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSliderTile(
    String title,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value.toStringAsFixed(0)),
      trailing: SizedBox(
        width: 150,
        child: Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Preview Section
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPreview() {
    final theme = _buildTheme(context);
    final config = _buildConfig();

    return ChatTheme(
      data: theme,
      child: Container(
        color: theme.colors.surface,
        child: Column(
          children: [
            // Preview Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                children: [
                  Icon(Icons.preview,
                      size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text('Live Preview',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    'Reactions: ${_availableReactions.length}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),

            // Messages Preview
            Expanded(
              child: SmartPaginationListView.withCubit(
                cubit: _pagination.cubit,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, items, index) {
                  final message = items[index] as ExampleMessage;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MessageBubble(
                      message: message,
                      currentUserId: ExampleSampleData.currentUserId,
                      showAvatar: _showAvatar,
                      availableReactions: config.pagination.availableReactions,
                      onReactionTap: (emoji) {
                        _showSnackBar('Reaction: $emoji');
                      },
                    ),
                  );
                },
              ),
            ),

            // Input Preview
            ChatInputWidget(
              onSendText: (text) async {
                _showSnackBar('Send: $text');
              },
              onAttachmentSelected: (source) {
                _showSnackBar('Attachment: ${source.name}');
              },
              enableAttachments: true,
              enableAudioRecording: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}

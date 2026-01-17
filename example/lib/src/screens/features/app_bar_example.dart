import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing ChatAppBar features and properties.
class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  int _selectedCount = 3;
  bool _showPinnedBar = false;
  bool _showSearchBar = false;
  int _currentSearchMatch = 1;
  int _totalSearchMatches = 5;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'ChatAppBar',
      subtitle: 'Customizable chat app bar',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.web_asset_outlined,
            lines: [
              'Showcases ChatAppBar variants and action configurations.',
              'Demonstrates group titles, avatars, and menu behaviors.',
              'Useful for aligning app bar visuals with your product.',
            ],
          ),
          const SizedBox(height: 16),
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'App bar with avatar, title, and action buttons',
            icon: Icons.web_asset_outlined,
          ),
          const SizedBox(height: 16),

          // Basic AppBar
          DemoContainer(
            title: 'Basic ChatAppBar',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ChatAppBar(
                  chat: const ChatAppBarData(
                    id: 'chat_1',
                    title: 'John Doe',
                    subtitle: 'Online',
                    imageUrl: 'https://i.pravatar.cc/150?img=12',
                  ),
                  showSearch: false,
                  showMenu: false,
                  onTitleTap: () => _showSnackBar(context, 'Title tapped'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // With All Actions
          const ExampleSectionHeader(
            title: 'Action Buttons',
            description: 'Search, video call, tasks, and menu',
            icon: Icons.more_vert_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'All Actions Enabled',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ChatAppBar(
                  chat: const ChatAppBarData(
                    id: 'chat_2',
                    title: 'Team Chat',
                    subtitle: '5 members',
                    imageUrl: 'https://i.pravatar.cc/150?img=32',
                    memberCount: 5,
                  ),
                  showSearch: true,
                  showVideoCall: true,
                  showTasks: true,
                  showMenu: true,
                  onSearch: () => _showSnackBar(context, 'Search tapped'),
                  onVideoCall: () =>
                      _showSnackBar(context, 'Video call tapped'),
                  onTasks: () => _showSnackBar(context, 'Tasks tapped'),
                  onMenuSelection: (value) =>
                      _showSnackBar(context, 'Menu: $value'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Group Chat
          const ExampleSectionHeader(
            title: 'Group Chat',
            description: 'With member count display',
            icon: Icons.groups_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Group with Member Count',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ChatAppBar(
                  chat: const ChatAppBarData(
                    id: 'chat_3',
                    title: 'Flutter Developers',
                    memberCount: 128,
                  ),
                  defaultIcon: Icons.groups,
                  showSearch: true,
                  showMenu: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // No Avatar
          const ExampleSectionHeader(
            title: 'Without Image',
            description: 'Default icon when no image URL',
            icon: Icons.person_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Default Icon',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ChatAppBar(
                  chat: const ChatAppBarData(
                    id: 'chat_4',
                    title: 'Support Channel',
                    subtitle: 'We\'re here to help',
                  ),
                  defaultIcon: Icons.support_agent,
                  showSearch: true,
                  showMenu: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Custom Menu Items
          const ExampleSectionHeader(
            title: 'Custom Menu',
            description: 'Define your own menu items',
            icon: Icons.menu_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Custom Menu Items',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ChatAppBar(
                  chat: const ChatAppBarData(
                    id: 'chat_5',
                    title: 'Project Chat',
                    subtitle: 'Active now',
                    imageUrl: 'https://i.pravatar.cc/150?img=5',
                  ),
                  showSearch: false,
                  showMenu: true,
                  menuItems: [
                    const PopupMenuItem(
                      value: 'mute',
                      child: Row(
                        children: [
                          Icon(Icons.notifications_off_outlined),
                          SizedBox(width: 8),
                          Text('Mute'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'pin',
                      child: Row(
                        children: [
                          Icon(Icons.push_pin_outlined),
                          SizedBox(width: 8),
                          Text('Pin Chat'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all),
                          SizedBox(width: 8),
                          Text('Clear History'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'leave',
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Leave Chat',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onMenuSelection: (value) =>
                      _showSnackBar(context, 'Selected: $value'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Selection App Bar
          const ExampleSectionHeader(
            title: 'Selection Mode',
            description: 'Multi-select actions and operations',
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'ChatSelectionAppBar',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChatSelectionAppBar(
                      selectedCount: _selectedCount,
                      selectedMessages: const {},
                      currentUserId: 'user_1',
                      onClose: () {
                        _showSnackBar(context, 'Selection cleared');
                      },
                      onReply: (msg) =>
                          _showSnackBar(context, 'Reply to message'),
                      onCopy: () => _showSnackBar(context, 'Messages copied'),
                      onDelete: (msgs) => _showSnackBar(
                          context, 'Delete ${msgs.length} messages'),
                      onForward: (msgs) => _showSnackBar(
                          context, 'Forward ${msgs.length} messages'),
                      onPin: (msgs) =>
                          _showSnackBar(context, 'Pin ${msgs.length} messages'),
                      onStar: (msgs) => _showSnackBar(
                          context, 'Star ${msgs.length} messages'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton.filled(
                            icon: Icon(
                                _selectedCount > 1 ? Icons.remove : Icons.add),
                            onPressed: () {
                              setState(() {
                                _selectedCount = _selectedCount > 1
                                    ? _selectedCount - 1
                                    : _selectedCount + 1;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Text('Adjust count to see different actions'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Pinned Messages Bar
          const ExampleSectionHeader(
            title: 'Pinned Messages',
            description: 'Display pinned message preview',
            icon: Icons.push_pin_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'PinnedMessagesBar',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChatAppBar(
                      chat: const ChatAppBarData(
                        id: 'chat_pinned',
                        title: 'Project Team',
                        subtitle: '8 members',
                        imageUrl: 'https://i.pravatar.cc/150?img=22',
                      ),
                      showSearch: true,
                      showMenu: true,
                    ),
                    if (_showPinnedBar)
                      PinnedMessagesBar(
                        message: ExampleMessage(
                          id: 'pinned_1',
                          chatId: 'chat_pinned',
                          senderId: 'user_2',
                          type: ChatMessageType.text,
                          textContent: 'Important: Meeting at 3 PM today!',
                          createdAt: DateTime.now(),
                          status: ChatMessageStatus.read,
                        ),
                        index: 0,
                        total: 2,
                        onTap: () => _showSnackBar(
                            context, 'Navigate to pinned message'),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            setState(() => _showPinnedBar = !_showPinnedBar),
                        icon: Icon(_showPinnedBar
                            ? Icons.visibility_off
                            : Icons.visibility),
                        label: Text(_showPinnedBar
                            ? 'Hide Pinned Bar'
                            : 'Show Pinned Bar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Search Matches Bar
          const ExampleSectionHeader(
            title: 'Search Interface',
            description: 'Search through messages with navigation',
            icon: Icons.search_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'SearchMatchesBar',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showSearchBar)
                      SearchMatchesBar(
                        matchedMessageIds: ['1', '2', '3', '4', '5'],
                        currentMatchIndex: _currentSearchMatch - 1,
                        isSearching: false,
                        searchHint: 'Search messages...',
                        onPrevious: () {
                          if (_currentSearchMatch > 1) {
                            setState(() => _currentSearchMatch--);
                          }
                        },
                        onNext: () {
                          if (_currentSearchMatch < _totalSearchMatches) {
                            setState(() => _currentSearchMatch++);
                          }
                        },
                        onClose: () => setState(() => _showSearchBar = false),
                        onQueryChanged: (query) =>
                            _showSnackBar(context, 'Searching: $query'),
                      ),
                    ChatAppBar(
                      chat: const ChatAppBarData(
                        id: 'chat_search',
                        title: 'Search Demo',
                        subtitle: 'Try the search feature',
                      ),
                      showSearch: true,
                      showMenu: false,
                      onSearch: () =>
                          setState(() => _showSearchBar = !_showSearchBar),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _showSearchBar
                            ? 'Match $_currentSearchMatch of $_totalSearchMatches'
                            : 'Click search icon to open',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Different Subtitles
          const ExampleSectionHeader(
            title: 'Status Variations',
            description: 'Different subtitle displays',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Typing Status',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ChatAppBar(
                  chat: const ChatAppBarData(
                    id: 'chat_6',
                    title: 'Sarah',
                    subtitle: 'typing...',
                    imageUrl: 'https://i.pravatar.cc/150?img=47',
                  ),
                  showSearch: false,
                  showMenu: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Last Seen',
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ChatAppBar(
                  chat: const ChatAppBarData(
                    id: 'chat_7',
                    title: 'Mike',
                    subtitle: 'Last seen 2 hours ago',
                    imageUrl: 'https://i.pravatar.cc/150?img=68',
                  ),
                  showSearch: false,
                  showMenu: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available ChatAppBar properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'chat',
            value: 'ChatAppBarData',
            description: 'Required chat data (id, title, subtitle, imageUrl)',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showSearch',
            value: 'bool (default: true)',
            description: 'Show search action button',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showVideoCall',
            value: 'bool (default: false)',
            description: 'Show video call button',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showTasks',
            value: 'bool (default: false)',
            description: 'Show tasks button',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showMenu',
            value: 'bool (default: true)',
            description: 'Show popup menu button',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'menuItems',
            value: 'List<PopupMenuItem>?',
            description: 'Custom menu items',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'defaultIcon',
            value: 'IconData (default: Icons.groups)',
            description: 'Icon when no image URL',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'additionalActions',
            value: 'List<Widget>?',
            description: 'Additional custom action widgets',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'backgroundColor',
            value: 'Color?',
            description: 'Custom background color',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'elevation',
            value: 'double (default: 0)',
            description: 'App bar elevation/shadow',
          ),
          const SizedBox(height: 24),

          // Selection AppBar Properties
          const ExampleSectionHeader(
            title: 'ChatSelectionAppBar Properties',
            description: 'Multi-selection mode properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'selectedCount',
            value: 'int',
            description: 'Number of selected messages',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onReply',
            value: 'ValueChanged<IChatMessageData>?',
            description: 'Reply callback (single selection only)',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onCopy',
            value: 'VoidCallback?',
            description: 'Copy selected messages',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onDelete',
            value: 'ValueChanged<Iterable>?',
            description: 'Delete selected messages',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onForward',
            value: 'ValueChanged<Iterable>?',
            description: 'Forward selected messages',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onPin/onUnpin',
            value: 'ValueChanged<Iterable>?',
            description: 'Pin/unpin selected messages',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onStar/onUnstar',
            value: 'ValueChanged<Iterable>?',
            description: 'Star/unstar selected messages',
          ),
          const SizedBox(height: 24),

          // PinnedMessagesBar Properties
          const ExampleSectionHeader(
            title: 'PinnedMessagesBar Properties',
            description: 'Pinned message display properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'The pinned message to display',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'index',
            value: 'int',
            description: 'Current pinned message index (0-based)',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'total',
            value: 'int',
            description: 'Total number of pinned messages',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onTap',
            value: 'VoidCallback',
            description: 'Callback when bar is tapped',
          ),
          const SizedBox(height: 24),

          // SearchMatchesBar Properties
          const ExampleSectionHeader(
            title: 'SearchMatchesBar Properties',
            description: 'Search interface properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'matchedMessageIds',
            value: 'List<String>',
            description: 'List of matched message IDs',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'currentMatchIndex',
            value: 'int',
            description: 'Current match index (0-based)',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isSearching',
            value: 'bool',
            description: 'Show loading indicator',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onPrevious/onNext',
            value: 'VoidCallback?',
            description: 'Navigate between matches',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onQueryChanged',
            value: 'ValueChanged<String>?',
            description: 'Search query change callback',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''Scaffold(
  appBar: ChatAppBar(
    chat: ChatAppBarData(
      id: 'chat_1',
      title: 'Team Chat',
      subtitle: '5 members online',
      imageUrl: 'https://example.com/avatar.jpg',
      memberCount: 10,
    ),
    showSearch: true,
    showVideoCall: true,
    showMenu: true,
    onSearch: () => openSearch(),
    onVideoCall: () => startCall(),
    onTitleTap: () => showChatInfo(),
    onMenuSelection: (value) => handleMenu(value),
  ),
  body: ChatMessageList(...),
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../shared/example_scaffold.dart';

/// Example screen showcasing ChatAppBar features and properties.
class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

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
                  onVideoCall: () => _showSnackBar(context, 'Video call tapped'),
                  onTasks: () => _showSnackBar(context, 'Tasks tapped'),
                  onMenuSelection: (value) => _showSnackBar(context, 'Menu: $value'),
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
                          Text('Leave Chat', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onMenuSelection: (value) => _showSnackBar(context, 'Selected: $value'),
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
            property: 'onTitleTap',
            value: 'VoidCallback?',
            description: 'Tap on title/avatar',
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

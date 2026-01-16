import 'package:flutter/material.dart';

/// Data model for chat info displayed in app bar
class ChatAppBarData {
  /// Chat ID
  final String id;

  /// Chat title/name
  final String title;

  /// Chat subtitle (e.g., member count, status)
  final String? subtitle;

  /// Chat image URL
  final String? imageUrl;

  /// Number of members (for groups)
  final int? memberCount;

  const ChatAppBarData({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.memberCount,
  });
}

/// A customizable app bar for chat screens.
///
/// Provides a consistent app bar with:
/// - Chat avatar
/// - Title and subtitle
/// - Action buttons (search, video call, tasks, menu)
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Chat data to display
  final ChatAppBarData chat;

  /// Callback when title/avatar is tapped
  final VoidCallback? onTitleTap;

  /// Callback when a menu item is selected
  final ValueChanged<String>? onMenuSelection;

  /// Callback for video call action
  final VoidCallback? onVideoCall;

  /// Callback for tasks action
  final VoidCallback? onTasks;

  /// Callback for search action
  final VoidCallback? onSearch;

  /// Whether to show the search button
  final bool showSearch;

  /// Whether to show the video call button
  final bool showVideoCall;

  /// Whether to show the tasks button
  final bool showTasks;

  /// Whether to show the menu button
  final bool showMenu;

  /// Custom menu items
  final List<PopupMenuItem<String>>? menuItems;

  /// Custom leading widget (replaces back button)
  final Widget? leading;

  /// Custom trailing actions
  final List<Widget>? actions;

  /// Additional actions to append to the default actions
  final List<Widget>? additionalActions;

  /// Default icon for chats without image
  final IconData defaultIcon;

  /// App bar background color
  final Color? backgroundColor;

  /// App bar elevation
  final double elevation;

  const ChatAppBar({
    super.key,
    required this.chat,
    this.onTitleTap,
    this.onMenuSelection,
    this.onVideoCall,
    this.onTasks,
    this.onSearch,
    this.showSearch = true,
    this.showVideoCall = false,
    this.showTasks = false,
    this.showMenu = true,
    this.menuItems,
    this.leading,
    this.actions,
    this.additionalActions,
    this.defaultIcon = Icons.groups,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final defaultActions = _buildActions(context);
    final allActions = actions ??
        [
          ...defaultActions,
          if (additionalActions != null) ...additionalActions!,
        ];

    return AppBar(
      leading: leading,
      title: GestureDetector(
        onTap: onTitleTap,
        child: Row(
          children: [
            _buildChatAvatar(context),
            const SizedBox(width: 10),
            Expanded(child: _buildChatInfo(context)),
          ],
        ),
      ),
      actions: allActions,
      backgroundColor: backgroundColor ?? Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      centerTitle: true,
    );
  }

  Widget _buildChatAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = chat.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          defaultIcon,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, __) {},
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildChatInfo(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = chat.subtitle ??
        (chat.memberCount != null ? '${chat.memberCount} members' : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chat.title.isNotEmpty ? chat.title : 'Chat',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium,
        ),
        if (subtitle != null)
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final items = <Widget>[];

    if (showSearch) {
      items.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch ?? () => onMenuSelection?.call('search'),
        ),
      );
    }

    if (showVideoCall && onVideoCall != null) {
      items.add(
        IconButton(icon: const Icon(Icons.video_call), onPressed: onVideoCall),
      );
    }

    if (showTasks && onTasks != null) {
      items.add(
        IconButton(icon: const Icon(Icons.task_outlined), onPressed: onTasks),
      );
    }

    if (showMenu) {
      items.add(
        PopupMenuButton<String>(
          onSelected: onMenuSelection,
          itemBuilder: (context) =>
              menuItems ??
              [
                const PopupMenuItem(
                  value: 'info',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 8),
                      Text('Info'),
                    ],
                  ),
                ),
              ],
        ),
      );
    }

    return items;
  }
}

import 'package:flutter/material.dart';
import '../../adapters/chat_message_data.dart';

/// Widget for chat selection app bar with enhanced functionality
///
/// This widget provides a comprehensive selection app bar for chat screens that includes:
/// - Selected message count display
/// - Action buttons for selected messages (reply, copy, delete, forward)
/// - Conditional actions based on selection count
/// - Proper theming and accessibility support
class ChatSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Number of selected messages
  final int selectedCount;

  /// Set of selected messages
  final Set<IChatMessageData> selectedMessages;

  /// Current user id
  final String currentUserId;

  /// Callback when close button is pressed
  final VoidCallback onClose;

  /// Callback when reply action is triggered
  final ValueChanged<IChatMessageData>? onReply;

  /// Callback when copy action is triggered
  final VoidCallback? onCopy;

  /// Callback when info action is triggered
  final ValueChanged<IChatMessageData>? onInfo;

  /// Callback when delete action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onDelete;

  /// Callback when forward action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onForward;

  /// Delete time restriction in hours (default: 8 hours)
  final int deleteTimeRestrictionHours;

  /// Custom title builder
  final Widget Function(int count)? titleBuilder;

  const ChatSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.selectedMessages,
    required this.currentUserId,
    required this.onClose,
    this.onReply,
    this.onCopy,
    this.onInfo,
    this.onDelete,
    this.onForward,
    this.deleteTimeRestrictionHours = 8,
    this.titleBuilder,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CloseButton(onPressed: onClose),
      title: titleBuilder?.call(selectedCount) ?? Text('$selectedCount'),
      actions: _buildSelectionActions(context),
    );
  }

  /// Build selection action buttons
  List<Widget> _buildSelectionActions(BuildContext context) {
    final actions = <Widget>[];

    // Reply button (only for single selection)
    if (selectedCount == 1 && onReply != null) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.reply),
          onPressed: () => onReply!(selectedMessages.first),
        ),
      );
    }

    // Copy text button
    if (onCopy != null) {
      actions.add(
        IconButton(icon: const Icon(Icons.content_copy), onPressed: onCopy),
      );
    }

    // Info button (only for single selection)
    if (selectedCount == 1 && onInfo != null) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => onInfo!(selectedMessages.first),
        ),
      );
    }

    // Delete button (with time restriction check)
    if (onDelete != null && _canDeleteMessages()) {
      actions.add(
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ),
      );
    }

    // Forward button
    if (onForward != null) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => onForward!(selectedMessages),
        ),
      );
    }

    return actions;
  }

  /// Check if messages can be deleted (time restriction)
  bool _canDeleteMessages() {
    final minDate = DateTime.now().subtract(
      Duration(hours: deleteTimeRestrictionHours),
    );

    return !selectedMessages.any(
      (message) =>
          message.senderId != currentUserId ||
          (message.createdAt ?? DateTime(1970)).isBefore(minDate),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Delete the selected messages? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onDelete?.call(selectedMessages);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

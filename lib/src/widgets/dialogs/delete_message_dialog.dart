import 'package:flutter/material.dart';

import '../../adapters/chat_message_data.dart';

/// A dialog for confirming message deletion with options.
///
/// Provides options to delete for everyone (if within time limit)
/// or delete for self only.
class DeleteMessageDialog extends StatelessWidget {
  /// The message to delete.
  final IChatMessageData message;

  /// Callback when delete for everyone is selected.
  final VoidCallback onDeleteForEveryone;

  /// Callback when delete for me is selected.
  final VoidCallback onDeleteForMe;

  /// Time limit in hours for deleting for everyone.
  final int deleteForEveryoneTimeLimit;

  /// Custom title text.
  final String? title;

  /// Custom content text when can delete for everyone.
  final String? contentDeleteForEveryone;

  /// Custom content text when can only delete for self.
  final String? contentDeleteForMe;

  const DeleteMessageDialog({
    super.key,
    required this.message,
    required this.onDeleteForEveryone,
    required this.onDeleteForMe,
    this.deleteForEveryoneTimeLimit = 8,
    this.title,
    this.contentDeleteForEveryone,
    this.contentDeleteForMe,
  });

  static Future<void> show({
    required BuildContext context,
    required IChatMessageData message,
    required VoidCallback onDeleteForEveryone,
    required VoidCallback onDeleteForMe,
    int deleteForEveryoneTimeLimit = 8,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => DeleteMessageDialog(
        message: message,
        onDeleteForEveryone: onDeleteForEveryone,
        onDeleteForMe: onDeleteForMe,
        deleteForEveryoneTimeLimit: deleteForEveryoneTimeLimit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDeleteForEveryone = _canDeleteForEveryone();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title ?? 'Delete message',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        canDeleteForEveryone
            ? (contentDeleteForEveryone ??
                'Delete this message for everyone or just for you?')
            : (contentDeleteForMe ?? 'Delete this message for you?'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (canDeleteForEveryone)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDeleteForEveryone();
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete for everyone'),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDeleteForMe();
          },
          child: const Text('Delete for me'),
        ),
      ],
    );
  }

  bool _canDeleteForEveryone() {
    final createdAt = message.createdAt;
    if (createdAt == null) return false;
    final elapsed = DateTime.now().difference(createdAt);
    return elapsed.inHours < deleteForEveryoneTimeLimit;
  }
}

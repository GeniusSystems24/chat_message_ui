import 'package:flutter/material.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';

/// Status icon widget for message status display.
///
/// Uses [ChatMessageStatus] from adapters layer.
class StatusIcon extends StatelessWidget {
  final ChatMessageStatus status;
  final ChatThemeData chatTheme;
  final Color? primaryColor;

  const StatusIcon({
    super.key,
    required this.status,
    required this.chatTheme,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? chatTheme.colors.primary;

    switch (status) {
      case ChatMessageStatus.pending:
        return Icon(
          Icons.access_time,
          size: chatTheme.status.iconSize,
          color: chatTheme.status.sendingColor ?? Colors.grey,
        );
      case ChatMessageStatus.sent:
        return Icon(
          Icons.done_all,
          size: chatTheme.status.iconSize,
          color: chatTheme.status.sentColor ?? color,
        );
      case ChatMessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: chatTheme.status.iconSize,
          color: chatTheme.status.deliveredColor ?? Colors.grey,
        );
      case ChatMessageStatus.read:
        return Icon(
          Icons.done_all,
          size: chatTheme.status.iconSize,
          color: chatTheme.status.readColor ?? Colors.blue,
        );
      case ChatMessageStatus.failed:
        return Icon(
          Icons.error,
          size: chatTheme.status.iconSize,
          color: chatTheme.status.errorColor ?? Colors.red,
        );
    }
  }
}

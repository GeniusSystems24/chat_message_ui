import 'package:flutter/material.dart';

import '../theme/chat_theme.dart';

/// Layout widget for message bubbles handling avatar positioning.
class MessageBubbleLayout extends StatelessWidget {
  final bool isMyMessage;
  final Widget messageBubble;
  final bool showAvatar;
  final Widget? userAvatar;
  final SpacingTheme? spacing;

  const MessageBubbleLayout({
    super.key,
    required this.isMyMessage,
    required this.messageBubble,
    this.showAvatar = false,
    this.userAvatar,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final spacingTheme = spacing ?? const SpacingTheme.standard();

    // Reserved space for avatar alignment
    final avatarSpace = SizedBox(width: spacingTheme.emptySpaceWidth);

    if (!showAvatar) {
      return Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) avatarSpace,
          Flexible(child: messageBubble),
          if (isMyMessage) avatarSpace,
        ],
      );
    }

    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMyMessage && userAvatar != null) ...[
          userAvatar!,
          const SizedBox(width: 4),
        ],
        Flexible(child: messageBubble),
        if (isMyMessage && userAvatar != null) ...[
          const SizedBox(width: 4),
          userAvatar!,
        ],
      ],
    );
  }
}

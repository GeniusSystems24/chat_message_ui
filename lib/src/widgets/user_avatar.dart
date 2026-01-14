import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';

/// User avatar widget with image loading and fallback.
///
/// Uses [ChatSenderData] from adapters layer.
class UserAvatar extends StatelessWidget {
  final ChatSenderData? senderData;
  final String? userInitial;
  final double avatarSize;
  final Widget? placeholder;

  const UserAvatar({
    super.key,
    this.senderData,
    this.userInitial,
    this.avatarSize = 15.0,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);
    final imageUrl = senderData?.imageUrl;

    final initial = userInitial ??
        (senderData?.displayName.isNotEmpty == true
            ? senderData!.displayName.substring(0, 1).toUpperCase()
            : '?');

    final userText = Text(
      initial,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: chatTheme.avatar.textColor ?? chatTheme.colors.onSurface,
        fontSize: avatarSize - 2,
      ),
    );

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: avatarSize,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: avatarSize,
          backgroundColor: chatTheme.avatar.backgroundColor ??
              chatTheme.colors.surfaceContainerHigh,
          child: placeholder ?? userText,
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: avatarSize,
          backgroundColor: chatTheme.avatar.backgroundColor ??
              chatTheme.colors.surfaceContainerHigh,
          child: userText,
        ),
      );
    }

    return CircleAvatar(
      radius: avatarSize,
      backgroundColor: chatTheme.avatar.backgroundColor ??
          chatTheme.colors.surfaceContainerHigh,
      child: userText,
    );
  }
}

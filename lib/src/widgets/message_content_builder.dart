import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';
import 'attachment_builder.dart';
import 'contact/contact_bubble.dart';

/// Widget for building message content (text + attachments).
///
/// This widget uses [IChatMessageData] interface to support multiple
/// data sources transparently.
class MessageContentBuilder extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final Function(RouteTextData)? onRouteTap;
  final Function(LinkTextData)? onLinkTap;
  final Function(EmailTextData)? onEmailTap;
  final Function(PhoneNumberTextData)? onPhoneTap;
  final VoidCallback? onAttachmentTap;
  final Widget Function(ChatMediaData media)? customAttachmentBuilder;

  const MessageContentBuilder({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onRouteTap,
    this.onLinkTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onAttachmentTap,
    this.customAttachmentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final text = message.textContent ?? '';
    final hasText = text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.type == ChatMessageType.contact &&
            message.contactData != null)
          ContactBubble(
            contact: message.contactData!,
            isMyMessage: isMyMessage,
            backgroundColor: isMyMessage
                ? chatTheme.colors.primary.withValues(alpha: 0.1)
                : chatTheme.colors.surfaceContainerHigh,
            textColor: chatTheme.colors.onSurface,
          )
        else if (message.type != ChatMessageType.text)
          AttachmentBuilder(
            message: message,
            chatTheme: chatTheme,
            isMyMessage: isMyMessage,
            onTap: onAttachmentTap,
            customBuilder: customAttachmentBuilder,
          ),
        if (hasText) _buildTextContent(context, text),
      ],
    );
  }

  /// Builds the text content of the message.
  Widget _buildTextContent(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: chatTheme.messageBubble.contentPadding,
        vertical: chatTheme.messageBubble.contentVerticalPadding,
      ),
      child: SuperInteractiveTextPreview(
        text: text,
        textPreviewTheme: chatTheme.textPreview,
        onRouteTap: onRouteTap,
        onLinkTap: onLinkTap,
        onEmailTap: onEmailTap,
        onPhoneTap: onPhoneTap,
      ),
    );
  }
}

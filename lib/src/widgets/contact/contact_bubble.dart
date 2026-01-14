import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../adapters/chat_data_models.dart';

/// Contact bubble widget for chat messages.
///
/// Uses [ChatContactData] from the adapters layer.
class ContactBubble extends StatelessWidget {
  final ChatContactData contact;
  final bool isMyMessage;
  final Color? backgroundColor;
  final Color? textColor;

  const ContactBubble({
    super.key,
    required this.contact,
    required this.isMyMessage,
    this.backgroundColor,
    this.textColor,
  });

  Future<void> _launchPhone(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = contact.name;
    final phone = contact.phone ?? '';

    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: phone.isNotEmpty ? () => _launchPhone(phone) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: theme.textTheme.bodyLarge?.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor ?? theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      phone.isEmpty ? 'No phone number' : phone,
                      style: TextStyle(
                        fontSize: 14,
                        color: (textColor ?? theme.colorScheme.onSurface)
                            .withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

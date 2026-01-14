import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A date separator widget displayed between messages from different days.
class ChatDateSeparator extends StatelessWidget {
  /// The date to display.
  final DateTime date;

  /// Optional custom date format.
  final String Function(DateTime date, String locale)? dateFormatter;

  const ChatDateSeparator({
    super.key,
    required this.date,
    this.dateFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final formatted = dateFormatter?.call(date, locale) ??
        DateFormat.yMMMd(locale).add_E().format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            formatted,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

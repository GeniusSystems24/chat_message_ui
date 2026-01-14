import 'package:flutter/material.dart';

import '../../adapters/adapters.dart';
import '../../theme/chat_theme.dart';
import 'poll_vote_details_view.dart';

/// Widget to display a poll in a message bubble.
class PollBubble extends StatelessWidget {
  final IChatMessageData message;
  final Function(String optionId)? onVote;

  const PollBubble({
    super.key,
    required this.message,
    this.onVote,
  });

  ChatPollData? get poll => message.pollData;

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);
    final pollTheme = chatTheme.poll;

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * pollTheme.maxWidthFactor,
      ),
      padding: EdgeInsets.only(
        left: pollTheme.containerPadding,
        right: pollTheme.containerPadding,
        top: pollTheme.containerPadding,
      ),
      decoration: BoxDecoration(
        color: chatTheme.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chatTheme.colors.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: _buildPollContent(context, chatTheme),
    );
  }

  Widget _buildPollContent(BuildContext context, ChatThemeData chatTheme) {
    final pollData = poll;
    if (pollData == null) {
      return _PollErrorWidget(chatTheme: chatTheme);
    }

    final theme = Theme.of(context);
    final pollTheme = chatTheme.poll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _PollHeader(
          title: pollData.question,
          isMultipleChoice: pollData.isMultiple,
          chatTheme: chatTheme,
        ),
        SizedBox(height: pollTheme.optionSpacing * 2),
        ...pollData.options.map((option) {
          final percentage = pollData.totalVotes > 0
              ? option.votes / pollData.totalVotes
              : 0.0;
          return _PollOption(
            option: option,
            percentage: percentage,
            totalVotes: pollData.totalVotes,
            isClosed: pollData.isClosed,
            chatTheme: chatTheme,
            onTap: () => onVote?.call(option.id),
          );
        }),
        SizedBox(height: pollTheme.optionSpacing),
        _PollFooter(
          totalVotes: pollData.totalVotes,
          isClosed: pollData.isClosed,
          chatTheme: chatTheme,
        ),
        if (pollData.totalVotes > 0) ...[
          SizedBox(height: pollTheme.optionSpacing),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: .2),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              onPressed: () => _showVoteDetailsModal(context, pollData),
              child: Text(
                'View Votes',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: pollTheme.voteFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showVoteDetailsModal(BuildContext context, ChatPollData pollData) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio: 0.9,
      builder: (context) => PollVoteDetailsView(poll: pollData),
    );
  }
}

class _PollHeader extends StatelessWidget {
  final String title;
  final bool isMultipleChoice;
  final ChatThemeData chatTheme;

  const _PollHeader({
    required this.title,
    required this.isMultipleChoice,
    required this.chatTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pollTheme = chatTheme.poll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: pollTheme.titleFontSize,
            color: chatTheme.colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              isMultipleChoice
                  ? Icons.playlist_add_check_circle_rounded
                  : Icons.check_circle,
              size: pollTheme.iconSize * .75,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(width: 6),
            Text(
              isMultipleChoice
                  ? 'Select one or more options'
                  : 'Select one option',
              style: TextStyle(
                fontSize: pollTheme.subtitleFontSize,
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PollOption extends StatelessWidget {
  final ChatPollOption option;
  final double percentage;
  final int totalVotes;
  final bool isClosed;
  final ChatThemeData chatTheme;
  final VoidCallback onTap;

  const _PollOption({
    required this.option,
    required this.percentage,
    required this.totalVotes,
    required this.isClosed,
    required this.chatTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pollTheme = chatTheme.poll;

    return Padding(
      padding: EdgeInsets.only(bottom: pollTheme.optionSpacing),
      child: InkWell(
        onTap: isClosed ? null : onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.all(pollTheme.optionPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  option.title,
                  style: TextStyle(
                    fontSize: pollTheme.optionFontSize,
                    fontWeight: FontWeight.w500,
                    color: chatTheme.colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                _ProgressBar(percentage: percentage, chatTheme: chatTheme),
                const SizedBox(height: 6),
                Text(
                  '${option.votes} / $totalVotes votes',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                if (isClosed)
                  Text(
                    'Poll closed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double percentage;
  final ChatThemeData chatTheme;

  const _ProgressBar({required this.percentage, required this.chatTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pollTheme = chatTheme.poll;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: pollTheme.progressBarHeight,
            margin: EdgeInsets.symmetric(horizontal: pollTheme.optionPadding),
            decoration: BoxDecoration(
              color: percentage > 0
                  ? theme.colorScheme.primary.withValues(
                      alpha: pollTheme.progressAlpha * 0.5,
                    )
                  : theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(pollTheme.progressBarRadius),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(
                    pollTheme.progressBarRadius,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}%',
          style: TextStyle(
              fontSize: 12,
              color: chatTheme.colors.onSurface.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _PollFooter extends StatelessWidget {
  final int totalVotes;
  final bool isClosed;
  final ChatThemeData chatTheme;

  const _PollFooter({
    required this.totalVotes,
    required this.isClosed,
    required this.chatTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pollTheme = chatTheme.poll;

    return Padding(
      padding: EdgeInsets.only(top: pollTheme.footerSpacing),
      child: Row(
        children: [
          Text(
            'Total votes: $totalVotes',
            style: TextStyle(
              fontSize: pollTheme.footerFontSize,
              color: theme.colorScheme.outline,
            ),
          ),
          const Spacer(),
          if (isClosed)
            Row(
              children: [
                Text(
                  'Closed',
                  style: TextStyle(
                    fontSize: pollTheme.footerFontSize,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.close, size: 16, color: theme.colorScheme.error),
              ],
            ),
        ],
      ),
    );
  }
}

class _PollErrorWidget extends StatelessWidget {
  final ChatThemeData chatTheme;

  const _PollErrorWidget({required this.chatTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pollTheme = chatTheme.poll;

    return Container(
      padding: EdgeInsets.all(pollTheme.containerPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.error,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.onError,
            size: pollTheme.iconSize,
          ),
          const SizedBox(width: 8),
          Text(
            'Error',
            style: TextStyle(
              color: theme.colorScheme.onError,
              fontSize: pollTheme.optionFontSize,
            ),
          ),
        ],
      ),
    );
  }
}

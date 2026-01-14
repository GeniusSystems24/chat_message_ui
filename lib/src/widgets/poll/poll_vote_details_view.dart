import 'package:flutter/material.dart';

import '../../adapters/chat_data_models.dart';

/// Bottom sheet for showing poll vote details.
class PollVoteDetailsView extends StatelessWidget {
  final ChatPollData poll;

  const PollVoteDetailsView({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Using basic styling, can be enhanced with ChatTheme if passed
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          _PollStatsHeader(poll: poll),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: poll.options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final option = poll.options[index];
                final percentage =
                    poll.totalVotes > 0 ? option.votes / poll.totalVotes : 0.0;
                return _PollOptionDetails(
                  option: option,
                  percentage: percentage,
                  totalVotes: poll.totalVotes,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          if (poll.isClosed)
            Text(
              'Poll closed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _PollStatsHeader extends StatelessWidget {
  final ChatPollData poll;

  const _PollStatsHeader({required this.poll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.poll_outlined, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Total votes: ${poll.totalVotes}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          if (poll.isMultiple)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Multiple',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PollOptionDetails extends StatelessWidget {
  final ChatPollOption option;
  final double percentage;
  final int totalVotes;

  const _PollOptionDetails({
    required this.option,
    required this.percentage,
    required this.totalVotes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              option.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _ProgressBar(percentage: percentage),
            const SizedBox(height: 8),
            Text(
              '${option.votes} / $totalVotes votes',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double percentage;

  const _ProgressBar({required this.percentage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

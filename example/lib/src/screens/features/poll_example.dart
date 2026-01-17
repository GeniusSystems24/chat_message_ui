import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../../data/example_sample_data.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing Poll-related features.
///
/// Features demonstrated:
/// - CreatePollScreen.showAsBottomSheet()
/// - CreatePollScreen.showAsPage()
/// - PollBubble with voting
/// - PollVoteDetailsView
/// - Single vs Multiple answer polls
class PollExample extends StatefulWidget {
  const PollExample({super.key});

  @override
  State<PollExample> createState() => _PollExampleState();
}

class _PollExampleState extends State<PollExample> {
  // Sample polls for demonstration
  late List<ExampleMessage> _pollMessages;
  CreatePollData? _lastCreatedPoll;

  @override
  void initState() {
    super.initState();
    _initPollMessages();
  }

  void _initPollMessages() {
    _pollMessages = [
      // Single answer poll
      ExampleMessage(
        id: 'poll_single',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.poll,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: ChatMessageStatus.delivered,
        pollData: ChatPollData(
          question: 'What should we have for lunch?',
          options: [
            ChatPollOption(id: 'opt_1', title: 'Pizza', votes: 3),
            ChatPollOption(id: 'opt_2', title: 'Sushi', votes: 5),
            ChatPollOption(id: 'opt_3', title: 'Burgers', votes: 2),
            ChatPollOption(id: 'opt_4', title: 'Salad', votes: 1),
          ],
          isMultiple: false,
          isClosed: false,
        ),
      ),
      // Multiple answer poll
      ExampleMessage(
        id: 'poll_multiple',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.poll,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        status: ChatMessageStatus.read,
        pollData: ChatPollData(
          question:
              'Which features should we prioritize? (Select all that apply)',
          options: [
            ChatPollOption(id: 'opt_a', title: 'Dark Mode', votes: 8),
            ChatPollOption(id: 'opt_b', title: 'Push Notifications', votes: 6),
            ChatPollOption(id: 'opt_c', title: 'Offline Support', votes: 4),
            ChatPollOption(id: 'opt_d', title: 'Export to PDF', votes: 3),
            ChatPollOption(id: 'opt_e', title: 'Voice Messages', votes: 7),
          ],
          isMultiple: true,
          isClosed: false,
        ),
      ),
      // Closed poll
      ExampleMessage(
        id: 'poll_closed',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.poll,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: ChatMessageStatus.delivered,
        pollData: ChatPollData(
          question: 'Best day for the team meeting?',
          options: [
            ChatPollOption(id: 'day_1', title: 'Monday', votes: 2),
            ChatPollOption(id: 'day_2', title: 'Wednesday', votes: 5),
            ChatPollOption(id: 'day_3', title: 'Friday', votes: 3),
          ],
          isMultiple: false,
          isClosed: true,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Poll Features',
      subtitle: 'Create, vote, and view poll details',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.poll_outlined,
            lines: [
              'Create polls using bottom sheet or full page.',
              'Vote on single or multiple choice polls.',
              'View detailed vote statistics.',
              'Demonstrates CreatePollScreen, PollBubble, and PollVoteDetailsView.',
            ],
          ),
          const SizedBox(height: 24),

          // Create Poll Section
          const ExampleSectionHeader(
            title: 'Create Poll',
            description: 'Two ways to create a new poll',
            icon: Icons.add_circle_outline,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.expand_less,
                  label: 'Bottom Sheet',
                  onPressed: () => _showCreatePollBottomSheet(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.open_in_new,
                  label: 'Full Page',
                  onPressed: () => _showCreatePollPage(context),
                ),
              ),
            ],
          ),

          if (_lastCreatedPoll != null) ...[
            const SizedBox(height: 16),
            _CreatedPollPreview(poll: _lastCreatedPoll!),
          ],

          const SizedBox(height: 32),

          // Poll Examples Section
          const ExampleSectionHeader(
            title: 'Poll Types',
            description: 'Single choice, multiple choice, and closed polls',
            icon: Icons.list_alt,
          ),
          const SizedBox(height: 16),

          // Single Answer Poll
          DemoContainer(
            title: 'Single Answer Poll',
            child: PollBubble(
              message: _pollMessages[0],
              onVote: (optionId) => _handleVote(_pollMessages[0], optionId),
              // onViewDetails: () => _showPollDetails(context, _pollMessages[0]),
            ),
          ),
          const SizedBox(height: 16),

          // Multiple Answer Poll
          DemoContainer(
            title: 'Multiple Answer Poll',
            child: PollBubble(
              message: _pollMessages[1],
              onVote: (optionId) => _handleVote(_pollMessages[1], optionId),
              // onViewDetails: () => _showPollDetails(context, _pollMessages[1]),
            ),
          ),
          const SizedBox(height: 16),

          // Closed Poll
          DemoContainer(
            title: 'Closed Poll',
            child: PollBubble(
              message: _pollMessages[2],
              onVote: (optionId) => _showSnackBar('Poll is closed'),
              // onViewDetails: () => _showPollDetails(context, _pollMessages[2]),
            ),
          ),

          const SizedBox(height: 32),

          // Properties Section
          const ExampleSectionHeader(
            title: 'CreatePollScreen Properties',
            description: 'Available customization options',
            icon: Icons.tune,
          ),
          const SizedBox(height: 12),

          const PropertyShowcase(
            property: 'onCreatePoll',
            value: 'Function(CreatePollData)',
            description: 'Callback when poll is created',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'minOptions',
            value: 'int (default: 2)',
            description: 'Minimum number of options required',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'maxOptions',
            value: 'int (default: 12)',
            description: 'Maximum number of options allowed',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'title',
            value: 'String?',
            description: 'Custom app bar title',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'questionHint',
            value: 'String?',
            description: 'Custom hint for question field',
          ),

          const SizedBox(height: 32),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''
// Show as bottom sheet
final poll = await CreatePollScreen.showAsBottomSheet(
  context,
  onCreatePoll: (poll) {
    print('Question: \${poll.question}');
    print('Options: \${poll.validOptions}');
    print('Multiple: \${poll.allowMultipleAnswers}');
  },
);

// Show as full page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CreatePollScreen(
      onCreatePoll: handlePollCreated,
      minOptions: 2,
      maxOptions: 10,
    ),
  ),
);''',
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _showCreatePollBottomSheet(BuildContext context) async {
    final poll = await CreatePollScreen.showAsBottomSheet(
      context,
      onCreatePoll: (poll) {
        setState(() => _lastCreatedPoll = poll);
        _showSnackBar('Poll created: ${poll.question}');
      },
    );

    if (poll != null) {
      setState(() => _lastCreatedPoll = poll);
    }
  }

  Future<void> _showCreatePollPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePollScreen(
          title: 'New Poll',
          questionHint: 'Ask your question here...',
          optionHint: 'Add an option',
          multipleAnswersLabel: 'Allow multiple selections',
          onCreatePoll: (poll) {
            setState(() => _lastCreatedPoll = poll);
            _showSnackBar('Poll created: ${poll.question}');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _handleVote(ExampleMessage message, String optionId) {
    final pollData = message.pollData;
    if (pollData == null || pollData.isClosed) return;

    setState(() {
      final index = _pollMessages.indexOf(message);
      if (index == -1) return;

      final currentSelected =
          List<String>.from(pollData.options.take(2).map((opt) => opt.id));
      final updatedOptions = pollData.options.map((opt) {
        if (opt.id == optionId) {
          final isSelected = currentSelected.contains(optionId);
          if (isSelected) {
            currentSelected.remove(optionId);
            return ChatPollOption(
              id: opt.id,
              title: opt.title,
              votes: opt.votes - 1,
            );
          } else {
            if (!pollData.isMultiple) {
              // For single choice, remove previous vote
              for (var i = 0; i < pollData.options.length; i++) {
                if (currentSelected.contains(pollData.options[i].id)) {
                  // This will be handled in the map
                }
              }
              currentSelected.clear();
            }
            currentSelected.add(optionId);
            return ChatPollOption(
              id: opt.id,
              title: opt.title,
              votes: opt.votes + 1,
            );
          }
        }
        // Handle deselection for single choice
        if (!pollData.isMultiple && currentSelected.contains(opt.id)) {
          return ChatPollOption(
            id: opt.id,
            title: opt.title,
            votes: opt.votes - 1,
          );
        }
        return opt;
      }).toList();

      final updatedPoll = ChatPollData(
        question: pollData.question,
        options: updatedOptions,
        isMultiple: pollData.isMultiple,
        isClosed: pollData.isClosed,
        // selectedOptionIds: currentSelected,
      );

      _pollMessages[index] = message.copyWith(pollData: updatedPoll);
    });

    _showSnackBar('Voted for option: $optionId');
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}

/// Action button for creating polls
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Preview of a created poll
class _CreatedPollPreview extends StatelessWidget {
  final CreatePollData poll;

  const _CreatedPollPreview({required this.poll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Last Created Poll',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            poll.question,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: poll.validOptions
                .map((opt) => Chip(
                      label: Text(opt),
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(
            poll.allowMultipleAnswers
                ? '✓ Multiple answers allowed'
                : '○ Single answer only',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

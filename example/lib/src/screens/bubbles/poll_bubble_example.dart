import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing all PollBubble features and properties.
class PollBubbleExample extends StatefulWidget {
  const PollBubbleExample({super.key});

  @override
  State<PollBubbleExample> createState() => _PollBubbleExampleState();
}

class _PollBubbleExampleState extends State<PollBubbleExample> {
  CreatePollData? _lastCreatedPoll;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'PollBubble',
      subtitle: 'Interactive poll widget',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.poll_outlined,
            lines: [
              'Demonstrates poll creation, voting, and result states.',
              'Covers single and multi-select scenarios with totals.',
              'Useful for validating poll layouts and vote callbacks.',
            ],
          ),
          const SizedBox(height: 16),

          // Create Poll Section
          const ExampleSectionHeader(
            title: 'Create Poll',
            description: 'WhatsApp-style poll creation screen',
            icon: Icons.add_circle_outline,
          ),
          const SizedBox(height: 12),
          _CreatePollSection(
            lastCreatedPoll: _lastCreatedPoll,
            onPollCreated: (poll) {
              setState(() => _lastCreatedPoll = poll);
            },
          ),
          const SizedBox(height: 24),

          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Create polls with voting and results visualization',
            icon: Icons.poll_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Poll
          DemoContainer(
            title: 'Basic Poll',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_1',
                question: 'What is your favorite programming language?',
                options: [
                  const ChatPollOption(id: '1', title: 'Dart', votes: 15),
                  const ChatPollOption(id: '2', title: 'JavaScript', votes: 10),
                  const ChatPollOption(id: '3', title: 'Python', votes: 8),
                  const ChatPollOption(id: '4', title: 'Kotlin', votes: 5),
                ],
              ),
              onVote: (optionId) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Voted for option: $optionId')),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Multiple Choice Poll
          const ExampleSectionHeader(
            title: 'Multiple Choice',
            description: 'Allow selecting multiple options',
            icon: Icons.check_box_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'isMultiple: true',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_2',
                question: 'Which features do you want in the next release?',
                options: [
                  const ChatPollOption(id: '1', title: 'Dark mode', votes: 25),
                  const ChatPollOption(id: '2', title: 'Offline support', votes: 20),
                  const ChatPollOption(id: '3', title: 'Push notifications', votes: 18),
                  const ChatPollOption(id: '4', title: 'File sharing', votes: 15),
                ],
                isMultiple: true,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Poll with Few Votes
          const ExampleSectionHeader(
            title: 'Vote Distribution',
            description: 'Different voting scenarios',
            icon: Icons.how_to_vote_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Landslide Victory',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_3',
                question: 'Should we adopt Material Design 3?',
                options: [
                  const ChatPollOption(id: '1', title: 'Yes, absolutely!', votes: 45),
                  const ChatPollOption(id: '2', title: 'Maybe later', votes: 5),
                  const ChatPollOption(id: '3', title: 'No, keep current', votes: 2),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Close Race',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_4',
                question: 'Team lunch location?',
                options: [
                  const ChatPollOption(id: '1', title: 'Italian', votes: 8),
                  const ChatPollOption(id: '2', title: 'Japanese', votes: 7),
                  const ChatPollOption(id: '3', title: 'Mexican', votes: 7),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'No Votes Yet',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_5',
                question: 'When should we have the meeting?',
                options: [
                  const ChatPollOption(id: '1', title: 'Monday 10 AM', votes: 0),
                  const ChatPollOption(id: '2', title: 'Tuesday 2 PM', votes: 0),
                  const ChatPollOption(id: '3', title: 'Wednesday 11 AM', votes: 0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Closed Poll
          const ExampleSectionHeader(
            title: 'Closed Poll',
            description: 'Poll that is no longer accepting votes',
            icon: Icons.lock_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'isClosed: true',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_6',
                question: 'Q3 Sprint Planning - Priority',
                options: [
                  const ChatPollOption(id: '1', title: 'Performance', votes: 12),
                  const ChatPollOption(id: '2', title: 'New Features', votes: 8),
                  const ChatPollOption(id: '3', title: 'Bug Fixes', votes: 10),
                ],
                isClosed: true,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Different Question Lengths
          const ExampleSectionHeader(
            title: 'Question Lengths',
            description: 'Short and long poll questions',
            icon: Icons.short_text_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Short Question',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_7',
                question: 'Coffee or Tea?',
                options: [
                  const ChatPollOption(id: '1', title: 'Coffee', votes: 15),
                  const ChatPollOption(id: '2', title: 'Tea', votes: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Long Question',
            child: PollBubble(
              message: _createPollMessage(
                id: 'poll_8',
                question: 'Given the upcoming deadline and resource constraints, what should be our top priority for the next two weeks?',
                options: [
                  const ChatPollOption(id: '1', title: 'Core functionality', votes: 20),
                  const ChatPollOption(id: '2', title: 'UI polish', votes: 15),
                  const ChatPollOption(id: '3', title: 'Documentation', votes: 5),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available PollBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'Message data with poll information',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onVote',
            value: 'Function(String)?',
            description: 'Callback when user votes for an option',
          ),
          const SizedBox(height: 24),

          // ChatPollData Reference
          const ExampleSectionHeader(
            title: 'ChatPollData Properties',
            description: 'Poll data model structure',
            icon: Icons.data_object_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'question',
            value: 'String',
            description: 'The poll question text',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'options',
            value: 'List<ChatPollOption>',
            description: 'List of poll options',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'totalVotes',
            value: 'int',
            description: 'Total number of votes',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isMultiple',
            value: 'bool',
            description: 'Allow multiple selections',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isClosed',
            value: 'bool',
            description: 'Whether poll is closed',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''PollBubble(
  message: ExampleMessage(
    id: 'poll_1',
    type: ChatMessageType.poll,
    pollData: ChatPollData(
      question: 'Favorite color?',
      options: [
        ChatPollOption(id: '1', title: 'Blue', votes: 10),
        ChatPollOption(id: '2', title: 'Green', votes: 8),
      ],
      totalVotes: 18,
      isMultiple: false,
      isClosed: false,
    ),
  ),
  onVote: (optionId) => handleVote(optionId),
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createPollMessage({
    required String id,
    required String question,
    required List<ChatPollOption> options,
    bool isMultiple = false,
    bool isClosed = false,
  }) {
    final totalVotes = options.fold<int>(0, (sum, opt) => sum + opt.votes);

    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: 'user_1',
      type: ChatMessageType.poll,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
      pollData: ChatPollData(
        question: question,
        options: options,
        totalVotes: totalVotes,
        isMultiple: isMultiple,
        isClosed: isClosed,
      ),
    );
  }
}

/// Section for demonstrating CreatePollScreen functionality.
class _CreatePollSection extends StatelessWidget {
  final CreatePollData? lastCreatedPoll;
  final ValueChanged<CreatePollData> onPollCreated;

  const _CreatePollSection({
    required this.lastCreatedPoll,
    required this.onPollCreated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Page Button
        DemoContainer(
          title: 'Open as Full Page',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Opens CreatePollScreen as a full page navigation.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _openAsFullPage(context),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Full Page'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Bottom Sheet Button
        DemoContainer(
          title: 'Open as Bottom Sheet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Opens CreatePollScreen as a draggable bottom sheet.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _openAsBottomSheet(context),
                icon: const Icon(Icons.vertical_align_bottom),
                label: const Text('Open Bottom Sheet'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),

        // Last Created Poll Display
        if (lastCreatedPoll != null) ...[
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Last Created Poll',
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
                    const Text(
                      'Poll Created Successfully!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _PollDataRow(
                  label: 'Question',
                  value: lastCreatedPoll!.question,
                ),
                const SizedBox(height: 8),
                _PollDataRow(
                  label: 'Options',
                  value: '${lastCreatedPoll!.validOptions.length} options',
                ),
                const SizedBox(height: 4),
                ...lastCreatedPoll!.validOptions.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                _PollDataRow(
                  label: 'Multiple Answers',
                  value: lastCreatedPoll!.allowMultipleAnswers ? 'Yes' : 'No',
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Code Example
        const CodeSnippet(
          title: 'CreatePollScreen Usage',
          code: '''// Show as full page
final poll = await CreatePollScreen.showAsPage(
  context,
  onCreatePoll: (pollData) {
    print('Question: \${pollData.question}');
    print('Options: \${pollData.validOptions}');
  },
);

// Show as bottom sheet
final poll = await CreatePollScreen.showAsBottomSheet(
  context,
  minOptions: 2,
  maxOptions: 12,
);

// Use as widget
CreatePollScreen(
  onCreatePoll: (poll) => sendPoll(poll),
  title: 'Create poll',
  questionHint: 'Ask question',
)''',
        ),
      ],
    );
  }

  Future<void> _openAsFullPage(BuildContext context) async {
    final poll = await CreatePollScreen.showAsPage(
      context,
      onCreatePoll: onPollCreated,
    );

    if (poll != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Poll created: ${poll.question}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _openAsBottomSheet(BuildContext context) async {
    final poll = await CreatePollScreen.showAsBottomSheet(
      context,
      onCreatePoll: onPollCreated,
    );

    if (poll != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Poll created: ${poll.question}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

/// Row displaying poll data label and value.
class _PollDataRow extends StatelessWidget {
  final String label;
  final String value;

  const _PollDataRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chat_message_ui_example/src/screens/features/features.dart';
import '../test_utils.dart';

void main() {
  group('PollExample', () {
    testWidgets('renders without errors', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PollExample()),
      );

      expect(find.byType(PollExample), isVisible);
    });

    testWidgets('displays Create Poll section', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PollExample()),
      );

      expect(find.text('Create Poll'), isVisible);
    });

    testWidgets('displays Poll Types section', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PollExample()),
      );

      expect(find.text('Poll Types'), isVisible);
    });

    testWidgets('shows poll properties section', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PollExample()),
      );

      expect(find.text('CreatePollScreen Properties'), isVisible);
    });

    testWidgets('tapping bottom sheet button opens CreatePollScreen',
        (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PollExample()),
      );

      // Find and tap the bottom sheet button
      final button = find.text('Bottom Sheet');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Should show CreatePollScreen content in bottom sheet
      expect(find.text('Create Poll'), isVisible);
    });
  });

  group('CreatePollScreen', () {
    testWidgets('renders in bottom sheet', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CreatePollScreen.showAsBottomSheet(context),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Create Poll'), isVisible);
    });

    testWidgets('has question field', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CreatePollScreen.showAsBottomSheet(context),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsWidgets);
    });
  });

  group('PollBubble', () {
    late MockChatMessageData pollMessage;

    setUp(() {
      pollMessage = MockChatMessageData();

      // Configure base mock message
      when(() => pollMessage.id).thenReturn('poll_1');
      when(() => pollMessage.chatId).thenReturn('chat_1');
      when(() => pollMessage.senderId).thenReturn('sender_1');
      when(() => pollMessage.type).thenReturn(ChatMessageType.poll);
      when(() => pollMessage.textContent).thenReturn(null);
      when(() => pollMessage.status).thenReturn(ChatMessageStatus.delivered);
      when(() => pollMessage.senderData).thenReturn(const ChatSenderData(
        id: 'sender_1',
        name: 'Test User',
      ));
      when(() => pollMessage.createdAt).thenReturn(DateTime.now());
      when(() => pollMessage.updatedAt).thenReturn(null);
      when(() => pollMessage.reactions).thenReturn(const []);
      when(() => pollMessage.groupedReactions).thenReturn(const {});
      when(() => pollMessage.isEdited).thenReturn(false);
      when(() => pollMessage.isDeleted).thenReturn(false);
      when(() => pollMessage.isPinned).thenReturn(false);
      when(() => pollMessage.isForwarded).thenReturn(false);
      when(() => pollMessage.forwardedFromId).thenReturn(null);
      when(() => pollMessage.replyData).thenReturn(null);
      when(() => pollMessage.replyToId).thenReturn(null);

      // Configure poll data
      final pollData = buildTestPollData(
        question: 'What is your favorite framework?',
        options: [
          buildTestPollOption(id: 'opt_1', title: 'Flutter'),
          buildTestPollOption(id: 'opt_2', title: 'React Native'),
          buildTestPollOption(id: 'opt_3', title: 'Kotlin Multiplatform'),
        ],
      );
      when(() => pollMessage.pollData).thenReturn(pollData);

      // Configure media to null
      when(() => pollMessage.mediaData).thenReturn(null);
      when(() => pollMessage.contactData).thenReturn(null);
      when(() => pollMessage.locationData).thenReturn(null);
      when(() => pollMessage.meetingReportData).thenReturn(null);
    });

    testWidgets('displays poll question', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PollBubble(message: pollMessage),
        ),
      );

      expect(find.text('What is your favorite framework?'), isVisible);
    });

    testWidgets('displays poll options', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PollBubble(message: pollMessage),
        ),
      );

      expect(find.text('Flutter'), isVisible);
      expect(find.text('React Native'), isVisible);
      expect(find.text('Kotlin Multiplatform'), isVisible);
    });

    testWidgets('calls onVote when option is tapped', (tester) async {
      final tracker = CallbackTracker<String>();

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PollBubble(
            message: pollMessage,
            onVote: (optionId) => tracker.call(optionId),
          ),
        ),
      );

      await tester.tap(find.text('Flutter'));
      await tester.pump();

      expect(tracker.wasCalled, isTrue);
      expect(tracker.invocations.first, 'opt_1');
    });
  });

  group('PollVoteDetailsView', () {
    testWidgets('displays voters for each option', (tester) async {
      final options = [
        buildTestPollOption(
          id: 'opt_1',
          title: 'Yes',
          votes: 2,
          voterIds: ['user_1', 'user_2'],
        ),
        buildTestPollOption(
          id: 'opt_2',
          title: 'No',
          votes: 1,
          voterIds: ['user_3'],
        ),
      ];

      final poll = ChatPollData(
        question: 'Do you agree?',
        options: options,
        totalVotes: 3,
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PollVoteDetailsView(poll: poll),
        ),
      );

      expect(find.text('Do you agree?'), isVisible);
      expect(find.text('Yes'), isVisible);
      expect(find.text('No'), isVisible);
    });
  });
}

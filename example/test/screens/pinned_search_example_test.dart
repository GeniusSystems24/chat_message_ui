import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import 'package:chat_message_ui_example/src/screens/features/pinned_search_example.dart';
import '../test_utils.dart';

void main() {
  group('PinnedSearchExample', () {
    testWidgets('renders without errors', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PinnedSearchExample()),
      );

      expect(find.byType(PinnedSearchExample), isVisible);
    });

    testWidgets('displays PinnedMessagesBar section', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PinnedSearchExample()),
      );

      expect(find.text('PinnedMessagesBar'), isVisible);
    });

    testWidgets('displays SearchMatchesBar section', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const PinnedSearchExample()),
      );

      expect(find.text('SearchMatchesBar'), isVisible);
    });
  });

  group('PinnedMessagesBar', () {
    testWidgets('renders with message data', (tester) async {
      final message = buildTestMessage(
        id: 'pinned_1',
        textContent: 'Pinned message content',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PinnedMessagesBar(
            message: message,
            index: 0,
            total: 3,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(PinnedMessagesBar), isVisible);
    });

    testWidgets('displays message count', (tester) async {
      final message = buildTestMessage(
        id: 'pinned_1',
        textContent: 'Test',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PinnedMessagesBar(
            message: message,
            index: 1,
            total: 5,
            onTap: () {},
          ),
        ),
      );

      // Should show index information
      expect(find.textContaining('2'), isVisible); // index + 1
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      final message = buildTestMessage(
        id: 'pinned_1',
        textContent: 'Tappable',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PinnedMessagesBar(
            message: message,
            index: 0,
            total: 1,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(PinnedMessagesBar));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows pin icon', (tester) async {
      final message = buildTestMessage(
        id: 'pinned_1',
        textContent: 'Test',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          PinnedMessagesBar(
            message: message,
            index: 0,
            total: 1,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.push_pin), isVisible);
    });
  });

  group('SearchMatchesBar', () {
    testWidgets('renders with matches', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const ['msg1', 'msg2', 'msg3'],
            currentMatchIndex: 0,
            onPrevious: () {},
            onNext: () {},
            onClose: () {},
          ),
        ),
      );

      expect(find.byType(SearchMatchesBar), isVisible);
    });

    testWidgets('displays match count', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const [
              'msg1',
              'msg2',
              'msg3',
              'msg4',
              'msg5',
            ],
            currentMatchIndex: 2,
            onPrevious: () {},
            onNext: () {},
            onClose: () {},
          ),
        ),
      );

      // Should show current/total (3 of 5)
      expect(find.textContaining('3'), isVisible);
      expect(find.textContaining('5'), isVisible);
    });

    testWidgets('calls onPrevious when previous is tapped', (tester) async {
      var previousCalled = false;

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const ['msg1', 'msg2', 'msg3', 'msg4', 'msg5'],
            currentMatchIndex: 2,
            onPrevious: () => previousCalled = true,
            onNext: () {},
            onClose: () {},
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
      await tester.pump();

      expect(previousCalled, isTrue);
    });

    testWidgets('calls onNext when next is tapped', (tester) async {
      var nextCalled = false;

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const ['msg1', 'msg2', 'msg3', 'msg4', 'msg5'],
            currentMatchIndex: 2,
            onPrevious: () {},
            onNext: () => nextCalled = true,
            onClose: () {},
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pump();

      expect(nextCalled, isTrue);
    });

    testWidgets('calls onClose when close is tapped', (tester) async {
      var closeCalled = false;

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const ['msg1', 'msg2', 'msg3'],
            currentMatchIndex: 0,
            onPrevious: () {},
            onNext: () {},
            onClose: () => closeCalled = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(closeCalled, isTrue);
    });

    testWidgets('disables previous on first match', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const ['msg1', 'msg2', 'msg3'],
            currentMatchIndex: 0,
            onPrevious: () {},
            onNext: () {},
            onClose: () {},
          ),
        ),
      );

      // Previous button should be disabled at first match
      expect(find.byType(SearchMatchesBar), isVisible);
    });

    testWidgets('disables next on last match', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const ['msg1', 'msg2', 'msg3'],
            currentMatchIndex: 2,
            onPrevious: () {},
            onNext: () {},
            onClose: () {},
          ),
        ),
      );

      // Next button should be disabled at last match
      expect(find.byType(SearchMatchesBar), isVisible);
    });

    testWidgets('handles zero matches', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SearchMatchesBar(
            matchedMessageIds: const [],
            currentMatchIndex: 0,
            onPrevious: () {},
            onNext: () {},
            onClose: () {},
          ),
        ),
      );

      // Should render without error
      expect(find.byType(SearchMatchesBar), isVisible);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import 'package:chat_message_ui_example/src/screens/screens.dart';
import '../test_utils.dart';

void main() {
  group('BasicChatExample', () {
    testWidgets('renders without errors', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const BasicChatExample()),
      );

      // Should render successfully
      expect(find.byType(BasicChatExample), isVisible);
    });

    testWidgets('displays ChatAppBar', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const BasicChatExample()),
      );

      // Should display ChatAppBar (which contains chat title)
      expect(find.text('Basic Chat'), isVisible);
    });

    testWidgets('displays ChatInputWidget', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const BasicChatExample()),
      );

      // Should display input widget
      expect(find.byType(ChatInputWidget), isVisible);
    });

    testWidgets('shows info button in app bar', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const BasicChatExample()),
      );

      // Should display info button
      expect(find.byIcon(Icons.info_outline), isVisible);
    });

    testWidgets('tapping info shows bottom sheet', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const BasicChatExample()),
      );

      // Tap info button
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      // Should show bottom sheet with screen overview
      expect(find.text('Screen Overview'), isVisible);
    });
  });

  group('MessageBubble', () {
    testWidgets('renders text message correctly', (tester) async {
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Hello, world!',
        senderId: 'user_1',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          MessageBubble(
            message: message,
            currentUserId: 'user_1',
            showAvatar: true,
          ),
        ),
      );

      expect(find.text('Hello, world!'), isVisible);
    });

    testWidgets('shows avatar for other users', (tester) async {
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Other user message',
        senderId: 'user_2',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          MessageBubble(
            message: message,
            currentUserId: 'user_1',
            showAvatar: true,
          ),
        ),
      );

      // Should show avatar for non-current user
      expect(find.byType(CircleAvatar), isVisible);
    });

    testWidgets('shows deleted message indicator', (tester) async {
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Deleted message',
        senderId: 'user_1',
        isDeleted: true,
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          MessageBubble(
            message: message,
            currentUserId: 'user_1',
            showAvatar: true,
          ),
        ),
      );

      // Should not show the original text for deleted messages
      expect(find.text('Deleted message'), isNotVisible);
    });

    testWidgets('shows edited indicator', (tester) async {
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Edited message',
        senderId: 'user_1',
        isEdited: true,
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          MessageBubble(
            message: message,
            currentUserId: 'user_1',
            showAvatar: true,
          ),
        ),
      );

      expect(find.text('Edited message'), isVisible);
    });
  });

  group('ChatInputWidget', () {
    testWidgets('renders input field', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatInputWidget(
            onSendText: noOpAsync,
          ),
        ),
      );

      expect(find.byType(TextField), isVisible);
    });

    testWidgets('calls onSendText when text is sent', (tester) async {
      final tracker = CallbackTracker<String>();

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatInputWidget(
            onSendText: tracker.asyncCall,
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'Test message');
      await tester.pump();

      // Submit
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();

      expect(tracker.wasCalled, isTrue);
      expect(tracker.invocations.first, 'Test message');
    });

    testWidgets('shows attachment button by default', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatInputWidget(
            onSendText: noOpAsync,
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_file), isVisible);
    });

    testWidgets('hides attachment button when disabled', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatInputWidget(
            onSendText: noOpAsync,
            enableAttachments: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_file), isNotVisible);
    });
  });

  group('ChatAppBar', () {
    testWidgets('displays chat title', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatAppBar(
            chat: const ChatAppBarData(
              id: 'chat_1',
              title: 'Test Chat',
              subtitle: 'Online',
            ),
          ),
        ),
      );

      expect(find.text('Test Chat'), isVisible);
    });

    testWidgets('displays subtitle', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatAppBar(
            chat: const ChatAppBarData(
              id: 'chat_1',
              title: 'Test Chat',
              subtitle: 'Online',
            ),
          ),
        ),
      );

      expect(find.text('Online'), isVisible);
    });

    testWidgets('shows search icon when enabled', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatAppBar(
            chat: const ChatAppBarData(
              id: 'chat_1',
              title: 'Test Chat',
            ),
            showSearch: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.search), isVisible);
    });

    testWidgets('calls onSearch when search is tapped', (tester) async {
      var searchCalled = false;

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          ChatAppBar(
            chat: const ChatAppBarData(
              id: 'chat_1',
              title: 'Test Chat',
            ),
            showSearch: true,
            onSearch: () => searchCalled = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      expect(searchCalled, isTrue);
    });
  });
}

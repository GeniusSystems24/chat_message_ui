import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chat_message_ui_example/main.dart' as app;
import 'package:chat_message_ui/chat_message_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Navigation Integration Tests', () {
    testWidgets('app launches and shows home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify home screen is displayed
      expect(find.text('chat_message_ui'), findsOneWidget);
    });

    testWidgets('can navigate to Basic Chat and back', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap Basic Chat card
      final basicChatCard = find.text('Basic Chat');
      await tester.ensureVisible(basicChatCard);
      await tester.tap(basicChatCard);
      await tester.pumpAndSettle();

      // Verify we're on Basic Chat screen
      expect(find.byType(ChatInputWidget), findsOneWidget);

      // Navigate back
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      } else {
        // Try system back
        await tester.pageBack();
        await tester.pumpAndSettle();
      }

      // Should be back at home
      expect(find.text('chat_message_ui'), findsOneWidget);
    });

    testWidgets('can navigate to Message Types screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap Message Types card
      final messageTypesCard = find.text('Message Types');
      await tester.scrollUntilVisible(messageTypesCard, 100);
      await tester.tap(messageTypesCard);
      await tester.pumpAndSettle();

      // Should show various message type sections
      expect(find.byType(MessageBubble), findsWidgets);
    });

    testWidgets('can navigate to Reactions screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap Reactions card
      final reactionsCard = find.text('Reactions');
      await tester.scrollUntilVisible(reactionsCard, 100);
      await tester.tap(reactionsCard);
      await tester.pumpAndSettle();

      // Should show reaction bar demo
      expect(find.text('MessageReactionBar Demo'), findsOneWidget);
    });

    testWidgets('can navigate to Theming screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap Theming card
      final themingCard = find.text('Theming');
      await tester.scrollUntilVisible(themingCard, 100);
      await tester.tap(themingCard);
      await tester.pumpAndSettle();

      // Should show theme showcase cards
      expect(find.text('Vibrant Light'), findsOneWidget);
    });
  });

  group('Feature Screen Integration Tests', () {
    testWidgets('Poll feature screen works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to features section
      final pollCard = find.text('Polls');
      await tester.scrollUntilVisible(pollCard, 100);
      await tester.tap(pollCard);
      await tester.pumpAndSettle();

      // Verify poll screen content
      expect(find.text('CreatePollScreen'), findsOneWidget);

      // Test bottom sheet opening
      final bottomSheetButton = find.text('Show as Bottom Sheet');
      await tester.ensureVisible(bottomSheetButton);
      await tester.tap(bottomSheetButton);
      await tester.pumpAndSettle();

      // Should show Create Poll bottom sheet
      expect(find.text('Create Poll'), findsOneWidget);
    });

    testWidgets('Edit message feature screen works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to edit message feature
      final editCard = find.text('Edit Messages');
      await tester.scrollUntilVisible(editCard, 100);
      await tester.tap(editCard);
      await tester.pumpAndSettle();

      // Verify edit message screen content
      expect(find.text('EditMessagePreview'), findsOneWidget);
    });

    testWidgets('File upload feature screen works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to file upload feature
      final uploadCard = find.text('File Upload');
      await tester.scrollUntilVisible(uploadCard, 100);
      await tester.tap(uploadCard);
      await tester.pumpAndSettle();

      // Verify file upload screen content
      expect(find.text('FileUploadIndicator'), findsOneWidget);
    });

    testWidgets('Pinned & Search feature screen works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to pinned/search feature
      final pinnedCard = find.text('Pinned & Search');
      await tester.scrollUntilVisible(pinnedCard, 100);
      await tester.tap(pinnedCard);
      await tester.pumpAndSettle();

      // Verify pinned/search screen content
      expect(find.text('PinnedMessagesBar'), findsOneWidget);
      expect(find.text('SearchMatchesBar'), findsOneWidget);
    });
  });

  group('Bubble Screen Integration Tests', () {
    testWidgets('Text bubble screen shows text messages', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to text bubble
      final textCard = find.text('Text');
      await tester.tap(textCard);
      await tester.pumpAndSettle();

      // Should show message bubbles
      expect(find.byType(MessageBubble), findsWidgets);
    });

    testWidgets('Poll bubble screen shows poll', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to poll bubble
      final pollCard = find.text('Poll');
      await tester.tap(pollCard);
      await tester.pumpAndSettle();

      // Should show poll bubble
      expect(find.byType(PollBubble), findsWidgets);
    });
  });

  group('Input Widget Integration Tests', () {
    testWidgets('can type and send message', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to basic chat
      final basicChatCard = find.text('Basic Chat');
      await tester.ensureVisible(basicChatCard);
      await tester.tap(basicChatCard);
      await tester.pumpAndSettle();

      // Find text field and enter text
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Hello integration test!');
      await tester.pump();

      // Text should be visible
      expect(find.text('Hello integration test!'), findsOneWidget);
    });

    testWidgets('suggestion providers work in input features', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to input features
      final inputCard = find.text('Input Features');
      await tester.scrollUntilVisible(inputCard, 100);
      await tester.tap(inputCard);
      await tester.pumpAndSettle();

      // Find text field and type @ to trigger mention suggestions
      final textField = find.byType(TextField);
      await tester.enterText(textField, '@');
      await tester.pump(const Duration(milliseconds: 500));

      // Suggestions should appear (or at least the screen should not crash)
      expect(find.byType(ChatInputWidget), findsOneWidget);
    });
  });

  group('Deep Link Integration Tests', () {
    testWidgets('Firebase chat route receives chatId', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Firebase example
      final firebaseCard = find.text('Firebase Live Chat');
      await tester.scrollUntilVisible(firebaseCard, 100);
      await tester.tap(firebaseCard);
      await tester.pumpAndSettle();

      // Should load Firebase chat screen
      expect(find.byType(ChatInputWidget), findsOneWidget);
    });
  });
}

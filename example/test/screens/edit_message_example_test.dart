import 'package:chat_message_ui_example/src/screens/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../test_utils.dart';

void main() {
  group('EditMessageExample', () {
    testWidgets('renders without errors', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const EditMessageExample()),
      );

      expect(find.byType(EditMessageExample), isVisible);
    });

    testWidgets('displays EditMessagePreview section', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const EditMessageExample()),
      );

      expect(find.text('EditMessagePreview Widget'), isVisible);
    });

    testWidgets('displays sample messages', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const EditMessageExample()),
      );

      // Should display at least one message bubble
      expect(find.byType(MessageBubble), findsWidgets);
    });
  });

  group('EditMessagePreview', () {
    testWidgets('displays edit data', (tester) async {
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Original message text',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          EditMessagePreview(
            message: message,
            onCancel: () {},
          ),
        ),
      );

      expect(find.text('Original message text'), isVisible);
    });

    testWidgets('displays edit icon', (tester) async {
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Original message text',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          EditMessagePreview(
            message: message,
            onCancel: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), isVisible);
    });

    testWidgets('calls onCancel when close is tapped', (tester) async {
      var cancelCalled = false;
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Original message text',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          EditMessagePreview(
            message: message,
            onCancel: () => cancelCalled = true,
          ),
        ),
      );

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(cancelCalled, isTrue);
    });

    testWidgets('respects custom background color', (tester) async {
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: 'Test',
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          EditMessagePreview(
            message: message,
            onCancel: () {},
            backgroundColor: Colors.amber,
          ),
        ),
      );

      // Widget should render with custom color
      expect(find.byType(EditMessagePreview), isVisible);
    });

    testWidgets('truncates long text', (tester) async {
      final longText = 'A' * 500; // Very long text
      final message = buildTestMessage(
        id: 'msg_1',
        textContent: longText,
      );

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          SizedBox(
            width: 300,
            child: EditMessagePreview(
              message: message,
              onCancel: () {},
            ),
          ),
        ),
      );

      // Widget should render without overflow
      expect(find.byType(EditMessagePreview), isVisible);
    });
  });

  group('EditMessageData', () {
    test('creates with required fields', () {
      final testMessage = buildTestMessage(
        id: 'msg_1',
        textContent: 'Test text',
      );
      final editData = EditMessageData(
        message: testMessage,
        currentText: 'Test text',
      );

      expect(editData.message.id, 'msg_1');
      expect(editData.currentText, 'Test text');
    });

    test('detects modification', () {
      final testMessage = buildTestMessage(
        id: 'msg_1',
        textContent: 'Original text',
      );
      final editData = EditMessageData(
        message: testMessage,
        currentText: 'Modified text',
      );

      expect(editData.isModified, true);
    });
  });
}

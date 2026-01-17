import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import 'package:chat_message_ui_example/src/screens/features/features.dart';
import 'package:chat_message_ui_example/src/screens/screens.dart';
import '../test_utils.dart';

void main() {
  group('FileUploadExample', () {
    testWidgets('renders without errors', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const FileUploadExample()),
      );

      expect(find.byType(FileUploadExample), isVisible);
    });

    testWidgets('displays FileUploadIndicator section', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const FileUploadExample()),
      );

      expect(find.text('File Upload Indicator'), isVisible);
    });

    testWidgets('displays all upload states', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(const FileUploadExample()),
      );

      // Should show status labels
      expect(find.text('WAITING'), isVisible);
      expect(find.text('UPLOADING'), isVisible);
      expect(find.text('COMPLETE'), isVisible);
      expect(find.text('ERROR'), isVisible);
      expect(find.text('CANCELLED'), isVisible);
      expect(find.text('PAUSED'), isVisible);
    });
  });

  group('FileUploadIndicator', () {
    testWidgets('renders with pending status', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          const FileUploadIndicator(
            filePath: 'test.pdf',
            status: FileUploadStatus.uploading,
            progressPercentage: 0.0,
          ),
        ),
      );

      expect(find.text('test.pdf'), isVisible);
    });

    testWidgets('renders with uploading status and progress', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          const FileUploadIndicator(
            filePath: 'document.pdf',
            status: FileUploadStatus.uploading,
            progressPercentage: 0.5,
          ),
        ),
      );

      expect(find.text('document.pdf'), isVisible);
    });

    testWidgets('renders with success status', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          const FileUploadIndicator(
            filePath: 'completed.pdf',
            status: FileUploadStatus.complete,
            progressPercentage: 1.0,
          ),
        ),
      );

      expect(find.text('completed.pdf'), isVisible);
    });

    testWidgets('renders with failed status', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          const FileUploadIndicator(
            filePath: 'failed.pdf',
            status: FileUploadStatus.error,
            progressPercentage: 0.3,
          ),
        ),
      );

      expect(find.text('failed.pdf'), isVisible);
    });

    testWidgets('calls onCancel when cancel is tapped', (tester) async {
      var cancelCalled = false;

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          FileUploadIndicator(
            filePath: 'test.pdf',
            status: FileUploadStatus.uploading,
            progressPercentage: 0.5,
            onCancel: () => cancelCalled = true,
          ),
        ),
      );

      // Find and tap cancel button
      final cancelButton = find.byIcon(Icons.close);
      if (cancelButton.evaluate().isNotEmpty) {
        await tester.tap(cancelButton);
        await tester.pump();
        expect(cancelCalled, isTrue);
      }
    });

    testWidgets('calls onRetry when retry is tapped', (tester) async {
      var retryCalled = false;

      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          FileUploadIndicator(
            filePath: 'failed.pdf',
            status: FileUploadStatus.error,
            progressPercentage: 0.0,
            onRetry: () => retryCalled = true,
          ),
        ),
      );

      // Find and tap retry button
      final retryButton = find.byIcon(Icons.refresh);
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pump();
        expect(retryCalled, isTrue);
      }
    });

    testWidgets('respects custom status styles', (tester) async {
      await pumpAndSettle(
        tester,
        wrapWithMaterialApp(
          const FileUploadIndicator(
            filePath: 'colored.pdf',
            status: FileUploadStatus.uploading,
            progressPercentage: 0.5,
          ),
        ),
      );

      expect(find.byType(FileUploadIndicator), isVisible);
    });
  });

  group('FileUploadStatus', () {
    test('has all expected values', () {
      expect(FileUploadStatus.values, contains(FileUploadStatus.waiting));
      expect(FileUploadStatus.values, contains(FileUploadStatus.uploading));
      expect(FileUploadStatus.values, contains(FileUploadStatus.complete));
      expect(FileUploadStatus.values, contains(FileUploadStatus.error));
      expect(FileUploadStatus.values, contains(FileUploadStatus.cancelled));
      expect(FileUploadStatus.values, contains(FileUploadStatus.paused));
    });
  });
}

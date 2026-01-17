import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

// ----- Mock Classes -----

/// Mock implementation of [IChatMessageData].
class MockChatMessageData extends Mock implements IChatMessageData {}

/// Mock implementation of [ChatSenderData].
class MockSenderData extends Mock implements ChatSenderData {}

/// Mock implementation of [ChatMediaData].
class MockChatMediaData extends Mock implements ChatMediaData {}

/// Mock implementation of [SmartPaginationCubit] for message lists.
class MockMessagesCubit extends Mock
    implements SmartPaginationCubit<IChatMessageData> {}

// ----- Test Data Builders -----

/// Builds a test [IChatMessageData] with sensible defaults.
IChatMessageData buildTestMessage({
  String id = 'msg_001',
  String senderId = 'user_1',
  String? textContent = 'Hello, world!',
  ChatMessageType type = ChatMessageType.text,
  DateTime? createdAt,
  ChatMessageStatus status = ChatMessageStatus.sent,
  bool isDeleted = false,
  bool isEdited = false,
  List<ChatReactionData> reactions = const [],
  ChatSenderData? senderData,
  ChatMediaData? mediaData,
  ChatReplyData? replyData,
}) {
  final mock = MockChatMessageData();
  when(() => mock.id).thenReturn(id);
  when(() => mock.chatId).thenReturn('test_chat');
  when(() => mock.senderId).thenReturn(senderId);
  when(() => mock.textContent).thenReturn(textContent);
  when(() => mock.type).thenReturn(type);
  when(() => mock.createdAt).thenReturn(createdAt ?? DateTime.now());
  when(() => mock.updatedAt).thenReturn(isEdited ? DateTime.now() : null);
  when(() => mock.status).thenReturn(status);
  when(() => mock.isDeleted).thenReturn(isDeleted);
  when(() => mock.isEdited).thenReturn(isEdited);
  when(() => mock.isPinned).thenReturn(false);
  when(() => mock.isForwarded).thenReturn(false);
  when(() => mock.forwardedFromId).thenReturn(null);
  when(() => mock.reactions).thenReturn(reactions);
  when(() => mock.groupedReactions).thenReturn({});
  when(() => mock.senderData).thenReturn(
    senderData ??
        const ChatSenderData(
          id: 'user_1',
          name: 'Test User',
          imageUrl: null,
        ),
  );
  when(() => mock.mediaData).thenReturn(mediaData);
  when(() => mock.replyData).thenReturn(replyData);
  when(() => mock.replyToId).thenReturn(replyData?.id);
  when(() => mock.pollData).thenReturn(null);
  when(() => mock.contactData).thenReturn(null);
  when(() => mock.locationData).thenReturn(null);
  when(() => mock.meetingReportData).thenReturn(null);
  when(() => mock.hasTextContent)
      .thenReturn(textContent != null && textContent.isNotEmpty);
  when(() => mock.hasMedia).thenReturn(mediaData != null);
  when(() => mock.hasReactions).thenReturn(reactions.isNotEmpty);
  when(() => mock.isReply).thenReturn(replyData != null);
  when(() => mock.isFromUser(any())).thenAnswer((invocation) {
    final userId = invocation.positionalArguments.first as String;
    return senderId == userId;
  });
  return mock;
}

/// Builds a list of test messages.
List<IChatMessageData> buildTestMessageList({int count = 5}) {
  return List.generate(count, (index) {
    return buildTestMessage(
      id: 'msg_$index',
      senderId: index % 2 == 0 ? 'user_1' : 'user_2',
      textContent: 'Message $index',
      createdAt: DateTime.now().subtract(Duration(minutes: index * 5)),
    );
  });
}

/// Builds a test [ChatReplyData].
ChatReplyData buildTestReplyData({
  String id = 'reply_001',
  String senderId = 'user_2',
  String senderName = 'Other User',
  String message = 'Original message',
  ChatMessageType type = ChatMessageType.text,
  String? thumbnailUrl,
}) {
  return ChatReplyData(
    id: id,
    senderId: senderId,
    senderName: senderName,
    message: message,
    type: type,
    thumbnailUrl: thumbnailUrl,
  );
}

/// Builds a test [EditMessageData].
EditMessageData buildTestEditData({
  required IChatMessageData message,
  String currentText = 'Current edited text',
}) {
  return EditMessageData(
    message: message,
    currentText: currentText,
  );
}

/// Builds a test [ChatPollOption].
ChatPollOption buildTestPollOption({
  String id = 'option_1',
  String title = 'Option 1',
  int votes = 0,
  List<String> voterIds = const [],
}) {
  return ChatPollOption(
    id: id,
    title: title,
    votes: votes,
    voterIds: voterIds,
  );
}

/// Builds test [ChatPollData].
ChatPollData buildTestPollData({
  String question = 'What is your favorite color?',
  List<ChatPollOption>? options,
  bool isMultiple = false,
  bool isAnonymous = false,
}) {
  return ChatPollData(
    question: question,
    options: options ??
        [
          buildTestPollOption(id: 'opt_1', title: 'Red'),
          buildTestPollOption(id: 'opt_2', title: 'Blue'),
          buildTestPollOption(id: 'opt_3', title: 'Green'),
        ],
    isMultiple: isMultiple,
    isAnonymous: isAnonymous,
  );
}

// ----- Widget Test Helpers -----

/// Wraps a widget with [MaterialApp] for testing.
Widget wrapWithMaterialApp(
  Widget child, {
  ThemeData? theme,
  List<ThemeExtension>? extensions,
}) {
  final effectiveTheme = theme ?? ThemeData.light(useMaterial3: true);
  final themeWithExtensions = effectiveTheme.copyWith(
    extensions: extensions ??
        [
          ChatThemeData.light(),
        ],
  );

  return MaterialApp(
    theme: themeWithExtensions,
    home: Scaffold(body: child),
  );
}

/// Wraps a widget with [MaterialApp] and dark theme for testing.
Widget wrapWithDarkMaterialApp(Widget child) {
  return wrapWithMaterialApp(
    child,
    theme: ThemeData.dark(useMaterial3: true),
    extensions: [ChatThemeData.dark()],
  );
}

/// Pumps and settles the widget tree.
Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

// ----- Finder Helpers -----

/// Finds a widget by key.
Finder findByKey(String key) => find.byKey(Key(key));

/// Finds a widget by type.
Finder findByType<T>() => find.byType(T);

/// Finds a text widget.
Finder findText(String text) => find.text(text);

/// Finds a widget by icon.
Finder findByIcon(IconData icon) => find.byIcon(icon);

// ----- Matchers -----

/// Matches that a widget is visible.
Matcher get isVisible => findsOneWidget;

/// Matches that a widget is not visible.
Matcher get isNotVisible => findsNothing;

/// Matches exactly N widgets.
Matcher findsN(int n) => findsNWidgets(n);

// ----- Callbacks -----

/// No-op async callback for testing.
Future<void> noOpAsync(dynamic _) async {}

/// No-op sync callback for testing.
void noOpSync(dynamic _) {}

/// Test callback that tracks invocations.
class CallbackTracker<T> {
  final List<T> invocations = [];
  bool get wasCalled => invocations.isNotEmpty;
  int get callCount => invocations.length;

  void call(T value) {
    invocations.add(value);
  }

  Future<void> asyncCall(T value) async {
    invocations.add(value);
  }

  void reset() {
    invocations.clear();
  }
}

import 'package:chat_message_ui/chat_message_ui.dart';

/// Mock implementation of IChatMessageData for demonstration purposes.
class MockChatMessage implements IChatMessageData {
  @override
  final String id;

  @override
  final String chatId;

  @override
  final String senderId;

  @override
  final ChatMessageType type;

  @override
  final String? textContent;

  @override
  final DateTime? createdAt;

  @override
  final DateTime? updatedAt;

  @override
  final ChatMediaData? mediaData;

  @override
  final ChatContactData? contactData;

  @override
  final ChatLocationData? locationData;

  @override
  final ChatPollData? pollData;

  @override
  final ChatMeetingReportData? meetingReportData;

  @override
  final ChatReplyData? replyData;

  @override
  final String? replyToId;

  @override
  final ChatMessageStatus status;

  @override
  final bool isDeleted;

  @override
  final bool isPinned;

  @override
  final bool isEdited;

  @override
  final bool isForwarded;

  @override
  final String? forwardedFromId;

  @override
  final List<ChatReactionData> reactions;

  @override
  final ChatSenderData? senderData;

  const MockChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.type,
    this.textContent,
    this.createdAt,
    this.updatedAt,
    this.mediaData,
    this.contactData,
    this.locationData,
    this.pollData,
    this.meetingReportData,
    this.replyData,
    this.replyToId,
    this.status = ChatMessageStatus.read,
    this.isDeleted = false,
    this.isPinned = false,
    this.isEdited = false,
    this.isForwarded = false,
    this.forwardedFromId,
    this.reactions = const [],
    this.senderData,
  });

  @override
  Map<String, List<String>> get groupedReactions {
    final Map<String, List<String>> grouped = {};
    for (final reaction in reactions) {
      grouped.putIfAbsent(reaction.emoji, () => []).add(reaction.userId);
    }
    return grouped;
  }

  MockChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    ChatMessageType? type,
    String? textContent,
    DateTime? createdAt,
    DateTime? updatedAt,
    ChatMediaData? mediaData,
    ChatContactData? contactData,
    ChatLocationData? locationData,
    ChatPollData? pollData,
    ChatMeetingReportData? meetingReportData,
    ChatReplyData? replyData,
    String? replyToId,
    ChatMessageStatus? status,
    bool? isDeleted,
    bool? isPinned,
    bool? isEdited,
    bool? isForwarded,
    String? forwardedFromId,
    List<ChatReactionData>? reactions,
    ChatSenderData? senderData,
  }) {
    return MockChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      textContent: textContent ?? this.textContent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mediaData: mediaData ?? this.mediaData,
      contactData: contactData ?? this.contactData,
      locationData: locationData ?? this.locationData,
      pollData: pollData ?? this.pollData,
      meetingReportData: meetingReportData ?? this.meetingReportData,
      replyData: replyData ?? this.replyData,
      replyToId: replyToId ?? this.replyToId,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      isPinned: isPinned ?? this.isPinned,
      isEdited: isEdited ?? this.isEdited,
      isForwarded: isForwarded ?? this.isForwarded,
      forwardedFromId: forwardedFromId ?? this.forwardedFromId,
      reactions: reactions ?? this.reactions,
      senderData: senderData ?? this.senderData,
    );
  }
}

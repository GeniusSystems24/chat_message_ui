/// Abstract interface for chat message data
///
/// This interface abstracts the underlying data source (V2Message, InternalChatMessageDto)
/// and provides a unified API for UI widgets.
library;

import 'chat_data_models.dart';

/// Abstract representation of a chat message for UI display
///
/// Widgets should depend on this interface rather than concrete message types.
/// This enables switching between different data sources (V2Message, InternalChatMessageDto)
/// without modifying widget code.
abstract class IChatMessageData {
  // ═══════════════════════════════════════════════════════════════════════════
  // IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Unique message identifier
  String get id;

  /// Chat/Room identifier this message belongs to
  String get chatId;

  /// Sender's user ID
  String get senderId;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPE & CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Message type (text, image, video, etc.)
  ChatMessageType get type;

  /// Text content of the message (if any)
  String? get textContent;

  // ═══════════════════════════════════════════════════════════════════════════
  // TIMESTAMPS
  // ═══════════════════════════════════════════════════════════════════════════

  /// When the message was created
  DateTime? get createdAt;

  /// When the message was last updated
  DateTime? get updatedAt;

  // ═══════════════════════════════════════════════════════════════════════════
  // MEDIA
  // ═══════════════════════════════════════════════════════════════════════════

  /// Media attachment data (for image, video, audio, document messages)
  ChatMediaData? get mediaData;

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIALIZED CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Contact data (for contact messages)
  ChatContactData? get contactData;

  /// Location data (for location messages)
  ChatLocationData? get locationData;

  /// Poll data (for poll messages)
  ChatPollData? get pollData;

  /// Meeting report data (for meeting report messages)
  ChatMeetingReportData? get meetingReportData;

  // ═══════════════════════════════════════════════════════════════════════════
  // REPLY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Reply data if this message is a reply to another message
  ChatReplyData? get replyData;

  /// ID of the message this is replying to (if any)
  String? get replyToId;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS FLAGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Message status (sent, delivered, read, etc.)
  ChatMessageStatus get status;

  /// Whether this message has been deleted
  bool get isDeleted;

  /// Whether this message is pinned
  bool get isPinned;

  /// Whether this message has been edited
  bool get isEdited;

  /// Whether this message was forwarded from another chat
  bool get isForwarded;

  /// Original message ID if this was forwarded
  String? get forwardedFromId;

  // ═══════════════════════════════════════════════════════════════════════════
  // REACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// List of reactions on this message
  List<ChatReactionData> get reactions;

  /// Grouped reactions by emoji with user IDs
  Map<String, List<String>> get groupedReactions;

  // ═══════════════════════════════════════════════════════════════════════════
  // SENDER INFO
  // ═══════════════════════════════════════════════════════════════════════════

  /// Sender information (may be populated from related data)
  ChatSenderData? get senderData;

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if this message is from the given user
  bool isFromUser(String userId) => senderId == userId;

  /// Check if message has text content
  bool get hasTextContent =>
      textContent != null && textContent!.trim().isNotEmpty;

  /// Check if message has media
  bool get hasMedia => mediaData != null;

  /// Check if message has reactions
  bool get hasReactions => reactions.isNotEmpty;

  /// Check if message is a reply
  bool get isReply => replyToId != null || replyData != null;
}

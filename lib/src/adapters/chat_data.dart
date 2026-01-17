/// Abstract interface for chat data
///
/// This interface abstracts the underlying chat data source and provides
/// a unified API for UI widgets across all screens.
library;

/// Type of chat
enum ChatType {
  /// 1:1 private chat
  individual,

  /// Group chat with multiple members
  group,

  /// Broadcast channel
  channel,

  /// Support/Help chat
  support,
}

/// Abstract representation of a chat for UI display
///
/// Widgets should depend on this interface rather than concrete chat types.
/// This enables switching between different data sources without modifying
/// widget code.
abstract class IChatData {
  // ═══════════════════════════════════════════════════════════════════════════
  // IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Unique chat identifier
  String get id;

  /// Chat type (individual, group, channel, support)
  ChatType get type;

  /// When the chat was created
  DateTime? get createdAt;

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY INFO
  // ═══════════════════════════════════════════════════════════════════════════

  /// Chat title/name
  String get title;

  /// Chat subtitle (status, typing, last seen)
  String? get subtitle;

  /// Chat description (for groups/channels)
  String? get description;

  /// Chat avatar/image URL
  String? get imageUrl;

  // ═══════════════════════════════════════════════════════════════════════════
  // PARTICIPANTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Number of members (for groups)
  int? get memberCount;

  /// List of participant IDs
  List<String> get participantIds;

  /// Creator user ID
  String? get creatorId;

  /// Admin user IDs
  List<String> get adminIds;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRESENCE & STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Whether the other user is online (for 1:1 chats)
  bool get isOnline;

  /// Last seen timestamp
  DateTime? get lastSeenAt;

  /// List of user IDs currently typing
  List<String> get typingUserIds;

  // ═══════════════════════════════════════════════════════════════════════════
  // CHAT STATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Whether chat is muted
  bool get isMuted;

  /// Whether chat is pinned
  bool get isPinned;

  /// Whether chat is archived
  bool get isArchived;

  /// Whether chat is blocked
  bool get isBlocked;

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE INFO
  // ═══════════════════════════════════════════════════════════════════════════

  /// Number of unread messages
  int get unreadCount;

  /// Last message preview text
  String? get lastMessagePreview;

  /// Last message timestamp
  DateTime? get lastMessageAt;

  /// Last read message ID by current user
  String? get lastReadMessageId;

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if this is a group chat
  bool get isGroup => type == ChatType.group || type == ChatType.channel;

  /// Check if this is a 1:1 chat
  bool get isIndividual => type == ChatType.individual;

  /// Check if someone is typing
  bool get hasTypingUsers => typingUserIds.isNotEmpty;

  /// Check if has unread messages
  bool get hasUnread => unreadCount > 0;

  /// Get display subtitle (typing > online > lastSeen > custom subtitle)
  String? get displaySubtitle;
}

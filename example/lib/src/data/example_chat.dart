import 'package:chat_message_ui/chat_message_ui.dart';

/// Example implementation of IChatData for demonstration purposes
class ExampleChat implements IChatData {
  ExampleChat({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.memberCount,
    List<String>? participantIds,
    this.creatorId,
    List<String>? adminIds,
    this.isOnline = false,
    this.lastSeenAt,
    List<String>? typingUserIds,
    this.isMuted = false,
    this.isPinned = false,
    this.isArchived = false,
    this.isBlocked = false,
    this.unreadCount = 0,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.lastReadMessageId,
  })  : participantIds = participantIds ?? const [],
        adminIds = adminIds ?? const [],
        typingUserIds = typingUserIds ?? const [];

  @override
  final String id;

  @override
  final ChatType type;

  @override
  final String title;

  @override
  final String? subtitle;

  @override
  final String? description;

  @override
  final String? imageUrl;

  @override
  final DateTime? createdAt;

  @override
  final int? memberCount;

  @override
  final List<String> participantIds;

  @override
  final String? creatorId;

  @override
  final List<String> adminIds;

  @override
  final bool isOnline;

  @override
  final DateTime? lastSeenAt;

  @override
  final List<String> typingUserIds;

  @override
  final bool isMuted;

  @override
  final bool isPinned;

  @override
  final bool isArchived;

  @override
  final bool isBlocked;

  @override
  final int unreadCount;

  @override
  final String? lastMessagePreview;

  @override
  final DateTime? lastMessageAt;

  @override
  final String? lastReadMessageId;

  @override
  String? get displaySubtitle {
    // Priority: typing > online > lastSeen > custom subtitle
    if (typingUserIds.isNotEmpty) {
      if (typingUserIds.length == 1) {
        return 'typing...';
      }
      return '${typingUserIds.length} people typing...';
    }

    if (type == ChatType.individual) {
      if (isOnline) {
        return 'Online';
      }
      if (lastSeenAt != null) {
        return _formatLastSeen(lastSeenAt!);
      }
    }

    return subtitle;
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final diff = now.difference(lastSeen);

    if (diff.inMinutes < 1) {
      return 'Last seen just now';
    } else if (diff.inMinutes < 60) {
      return 'Last seen ${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return 'Last seen ${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Last seen yesterday';
    } else {
      return 'Last seen ${diff.inDays} days ago';
    }
  }

  /// Create a copy with modified fields
  ExampleChat copyWith({
    String? id,
    ChatType? type,
    String? title,
    String? subtitle,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    int? memberCount,
    List<String>? participantIds,
    String? creatorId,
    List<String>? adminIds,
    bool? isOnline,
    DateTime? lastSeenAt,
    List<String>? typingUserIds,
    bool? isMuted,
    bool? isPinned,
    bool? isArchived,
    bool? isBlocked,
    int? unreadCount,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    String? lastReadMessageId,
  }) {
    return ExampleChat(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      memberCount: memberCount ?? this.memberCount,
      participantIds: participantIds ?? this.participantIds,
      creatorId: creatorId ?? this.creatorId,
      adminIds: adminIds ?? this.adminIds,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      typingUserIds: typingUserIds ?? this.typingUserIds,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isBlocked: isBlocked ?? this.isBlocked,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }
}

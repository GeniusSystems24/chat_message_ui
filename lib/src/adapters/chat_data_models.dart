/// Chat data models for UI layer - platform agnostic representations
///
/// These models are used by the UI layer and are independent of the
/// data source (V2Message, InternalChatMessageDto, etc.)
library;

import 'package:flutter/foundation.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════════════════

/// Type of chat message - combines message type and media subtype
enum ChatMessageType {
  text,
  image,
  video,
  audio,
  document,
  location,
  contact,
  poll,
  mention,
  meetingReport,
  unknown;

  bool get isMedia =>
      this == image || this == video || this == audio || this == document;

  bool get isText => this == text;
}

/// Status of a message
enum ChatMessageStatus { pending, sent, delivered, read, failed }

// ═══════════════════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════════════════

/// Contact information for contact messages
@immutable
class ChatContactData {
  final String name;
  final String? phone;
  final String? email;
  final String? avatar;

  const ChatContactData({
    required this.name,
    this.phone,
    this.email,
    this.avatar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatContactData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          phone == other.phone;

  @override
  int get hashCode => Object.hash(name, phone);
}

/// Location information for location messages
@immutable
class ChatLocationData {
  final double? latitude;
  final double? longitude;
  final String? name;
  final String? address;

  const ChatLocationData({
    this.latitude,
    this.longitude,
    this.name,
    this.address,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatLocationData &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

/// Single poll option
@immutable
class ChatPollOption {
  final String id;
  final String title;
  final int votes;
  final List<String> voterIds;

  const ChatPollOption({
    required this.id,
    required this.title,
    this.votes = 0,
    this.voterIds = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatPollOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Poll data for poll messages
@immutable
class ChatPollData {
  final String question;
  final List<ChatPollOption> options;
  final bool isMultiple;
  final bool isClosed;
  final int totalVotes;
  final bool isAnonymous;
  final DateTime? expiresAt;

  const ChatPollData({
    required this.question,
    required this.options,
    this.isMultiple = false,
    this.isClosed = false,
    this.totalVotes = 0,
    this.isAnonymous = false,
    this.expiresAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatPollData &&
          runtimeType == other.runtimeType &&
          question == other.question;

  @override
  int get hashCode => question.hashCode;
}

/// Reaction on a message
@immutable
class ChatReactionData {
  final String emoji;
  final String userId;
  final DateTime? createdAt;

  const ChatReactionData({
    required this.emoji,
    required this.userId,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatReactionData &&
          runtimeType == other.runtimeType &&
          emoji == other.emoji &&
          userId == other.userId;

  @override
  int get hashCode => Object.hash(emoji, userId);
}

/// Reply message preview data
@immutable
class ChatReplyData {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final ChatMessageType type;
  final String? thumbnailUrl;

  const ChatReplyData({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.type,
    this.thumbnailUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatReplyData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Media attachment data
@immutable
class ChatMediaData {
  final String url;
  final String? thumbnailUrl;
  final ChatMessageType mediaType;
  final int? duration; // in seconds, for audio/video
  final int? fileSize; // in bytes
  final String? fileName;
  final double? aspectRatio;

  /// Waveform data for audio files (normalized amplitudes 0.0-1.0).
  final List<double>? waveformData;

  const ChatMediaData({
    required this.url,
    required this.mediaType,
    this.thumbnailUrl,
    this.duration,
    this.fileSize,
    this.fileName,
    this.aspectRatio,
    this.waveformData,
  });

  /// Creates a copy with modified values.
  ChatMediaData copyWith({
    String? url,
    String? thumbnailUrl,
    ChatMessageType? mediaType,
    int? duration,
    int? fileSize,
    String? fileName,
    double? aspectRatio,
    List<double>? waveformData,
  }) {
    return ChatMediaData(
      url: url ?? this.url,
      mediaType: mediaType ?? this.mediaType,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      fileSize: fileSize ?? this.fileSize,
      fileName: fileName ?? this.fileName,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      waveformData: waveformData ?? this.waveformData,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMediaData &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;
}

/// Sender information
@immutable
class ChatSenderData {
  final String id;
  final String? name;
  final String? username;
  final String? imageUrl;

  const ChatSenderData({
    required this.id,
    this.name,
    this.username,
    this.imageUrl,
  });

  String get displayName => name?.trim().isNotEmpty == true
      ? name!
      : (username?.trim().isNotEmpty == true ? username! : id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSenderData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Meeting report data
@immutable
class ChatMeetingReportData {
  final String meetingId;
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? duration;
  final int? participantCount;

  const ChatMeetingReportData({
    required this.meetingId,
    this.title,
    this.startTime,
    this.endTime,
    this.duration,
    this.participantCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMeetingReportData &&
          runtimeType == other.runtimeType &&
          meetingId == other.meetingId;

  @override
  int get hashCode => meetingId.hashCode;
}

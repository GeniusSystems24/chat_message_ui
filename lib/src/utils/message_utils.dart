import '../adapters/chat_data_models.dart';

/// Parses a message type from a string.
ChatMessageType chatMessageTypeFromString(String? rawType) {
  final type = rawType?.toLowerCase().trim() ?? '';
  if (type.contains('image') || type.contains('photo')) {
    return ChatMessageType.image;
  }
  if (type.contains('video')) {
    return ChatMessageType.video;
  }
  if (type.contains('audio') || type.contains('voice')) {
    return ChatMessageType.audio;
  }
  if (type.contains('file') || type.contains('document')) {
    return ChatMessageType.document;
  }
  if (type.contains('location')) {
    return ChatMessageType.location;
  }
  if (type.contains('contact')) {
    return ChatMessageType.contact;
  }
  if (type.contains('poll')) {
    return ChatMessageType.poll;
  }
  if (type.contains('mention')) {
    return ChatMessageType.mention;
  }
  if (type.contains('meeting') || type.contains('report')) {
    return ChatMessageType.meetingReport;
  }
  return ChatMessageType.text;
}

/// Extracts message text from a content map.
String extractMessageText(Map<String, dynamic>? content) {
  if (content == null) return '';
  final direct = _extractString(content['text']) ??
      _extractString(content['message']) ??
      _extractString(content['content']) ??
      _extractString(content['body']);
  if (direct != null && direct.trim().isNotEmpty) {
    return direct.trim();
  }

  final nested = content['data'];
  if (nested is Map<String, dynamic>) {
    return extractMessageText(nested);
  }

  return '';
}

/// Extracts a file name from a content map.
String? extractFileName(Map<String, dynamic>? content) {
  if (content == null) return null;
  final direct = _extractString(content['name']) ??
      _extractString(content['fileName']) ??
      _extractString(content['filename']) ??
      _extractString(content['title']);
  if (direct != null) return direct;
  final mediaMap = _extractMediaMap(content);
  if (mediaMap != null) {
    return _extractString(mediaMap['name']) ??
        _extractString(mediaMap['fileName']) ??
        _extractString(mediaMap['filename']) ??
        _extractString(mediaMap['title']);
  }
  final nested = content['data'];
  if (nested is Map<String, dynamic>) {
    return extractFileName(nested);
  }
  return null;
}

/// Extracts a media URL from a content map.
String? extractMediaUrl(Map<String, dynamic>? content) {
  if (content == null) return null;
  final direct = _extractString(content['url']) ??
      _extractString(content['mediaUrl']) ??
      _extractString(content['fileUrl']) ??
      _extractString(content['original']);
  if (direct != null) return direct;
  final mediaMap = _extractMediaMap(content);
  if (mediaMap != null) {
    return _extractString(mediaMap['url']) ??
        _extractString(mediaMap['mediaUrl']) ??
        _extractString(mediaMap['fileUrl']) ??
        _extractString(mediaMap['original']);
  }
  final nested = content['data'];
  if (nested is Map<String, dynamic>) {
    return extractMediaUrl(nested);
  }
  return null;
}

/// Extracts a thumbnail URL from a content map.
String? extractThumbnailUrl(Map<String, dynamic>? content) {
  if (content == null) return null;
  final direct = _extractString(content['thumbnail']) ??
      _extractString(content['thumb']) ??
      _extractString(content['preview']);
  if (direct != null) return direct;
  final mediaMap = _extractMediaMap(content);
  if (mediaMap != null) {
    return _extractString(mediaMap['thumbnail']) ??
        _extractString(mediaMap['thumb']) ??
        _extractString(mediaMap['preview']);
  }
  final nested = content['data'];
  if (nested is Map<String, dynamic>) {
    return extractThumbnailUrl(nested);
  }
  return null;
}

/// Extracts duration from a content map.
int? extractDuration(Map<String, dynamic>? content) {
  if (content == null) return null;
  final value = content['duration'];
  final parsed = _extractInt(value);
  if (parsed != null) return parsed;
  final mediaMap = _extractMediaMap(content);
  if (mediaMap != null) {
    final fromMedia = _extractInt(mediaMap['duration']);
    if (fromMedia != null) return fromMedia;
  }
  final nested = content['data'];
  if (nested is Map<String, dynamic>) {
    return extractDuration(nested);
  }
  return null;
}

/// Extracts file size from a content map.
int? extractFileSize(Map<String, dynamic>? content) {
  if (content == null) return null;
  final value = content['size'] ?? content['fileSize'];
  final parsed = _extractInt(value);
  if (parsed != null) return parsed;
  final mediaMap = _extractMediaMap(content);
  if (mediaMap != null) {
    final fromMedia = _extractInt(mediaMap['size'] ?? mediaMap['fileSize']);
    if (fromMedia != null) return fromMedia;
  }
  final nested = content['data'];
  if (nested is Map<String, dynamic>) {
    return extractFileSize(nested);
  }
  return null;
}

/// Extracts a double from various formats.
double? extractDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Extracts aspect ratio from a content map.
double? extractAspectRatio(Map<String, dynamic>? content) {
  if (content == null) return null;
  final dimensions = _extractDimensionsMap(content);
  if (dimensions != null) {
    final width =
        extractDouble(dimensions['width']) ?? extractDouble(dimensions['w']);
    final height =
        extractDouble(dimensions['height']) ?? extractDouble(dimensions['h']);
    if (width != null && height != null && height != 0) {
      return width / height;
    }
  }
  final width = extractDouble(content['width']) ?? extractDouble(content['w']);
  final height =
      extractDouble(content['height']) ?? extractDouble(content['h']);
  if (width != null && height != null && height != 0) {
    return width / height;
  }
  final nested = content['data'];
  if (nested is Map<String, dynamic>) {
    return extractAspectRatio(nested);
  }
  return null;
}

/// Groups reactions by emoji and returns a map of emoji to user IDs.
Map<String, List<String>> groupReactions(List<ChatReactionData> reactions) {
  final grouped = <String, List<String>>{};
  for (final reaction in reactions) {
    final emoji = reaction.emoji;
    if (emoji.isEmpty) continue;
    final userId = reaction.userId;
    if (userId.isEmpty) continue;
    grouped.putIfAbsent(emoji, () => []).add(userId);
  }
  return grouped;
}

/// Extracts contact data from a content map.
ChatContactData? extractContactData(Map<String, dynamic>? content) {
  if (content == null) return null;
  final contact = content['contact'];
  final map = contact is Map<String, dynamic>
      ? contact
      : Map<String, dynamic>.from(content);
  final name = _extractString(map['name']) ??
      _extractString(map['fullName']) ??
      _extractString(map['displayName']);
  final phone = _extractString(map['phone']) ??
      _extractString(map['phoneNumber']) ??
      _extractString(map['mobile']);
  if (name == null && phone == null) return null;
  return ChatContactData(name: name ?? phone ?? 'Contact', phone: phone);
}

/// Extracts location data from a content map.
ChatLocationData? extractLocationData(Map<String, dynamic>? content) {
  if (content == null) return null;
  final location = content['location'];
  final map = location is Map<String, dynamic>
      ? location
      : Map<String, dynamic>.from(content);
  final latitude = extractDouble(map['lat']) ?? extractDouble(map['latitude']);
  final longitude = extractDouble(map['lng']) ??
      extractDouble(map['lon']) ??
      extractDouble(map['longitude']);
  final name = _extractString(map['name']) ??
      _extractString(map['placeName']) ??
      _extractString(map['title']);
  final address =
      _extractString(map['address']) ?? _extractString(map['formattedAddress']);
  if (latitude == null && longitude == null) return null;
  return ChatLocationData(
    latitude: latitude,
    longitude: longitude,
    name: name,
    address: address,
  );
}

/// Extracts poll data from a content map.
ChatPollData? extractPollData(Map<String, dynamic>? content) {
  if (content == null) return null;
  final poll = content['poll'];
  final map =
      poll is Map<String, dynamic> ? poll : Map<String, dynamic>.from(content);
  final question =
      _extractString(map['question']) ?? _extractString(map['title']) ?? '';
  final isMultiple = map['isMultiSelect'] == true || map['multiple'] == true;
  final isClosed = map['isClosed'] == true || map['isClose'] == true;
  final options = _parsePollOptions(map['options']);
  if (question.isEmpty && options.isEmpty) return null;
  final totalVotes = options.fold<int>(0, (sum, item) => sum + item.votes);
  return ChatPollData(
    question: question.isNotEmpty ? question : 'Poll',
    options: options,
    isMultiple: isMultiple,
    isClosed: isClosed,
    totalVotes: totalVotes,
  );
}

/// Parses reply data from a JSON map.
ChatReplyData? parseReplyData(Map<String, dynamic>? replyTo) {
  if (replyTo == null || replyTo.isEmpty) return null;

  final sender = replyTo['sender'];
  final senderMap = sender is Map ? Map<String, dynamic>.from(sender) : null;
  final id = _extractString(replyTo['id']) ??
      _extractString(replyTo['_id']) ??
      _extractString(replyTo['messageId']) ??
      '';
  final senderId = _extractString(replyTo['senderId']) ??
      _extractString(replyTo['userId']) ??
      _extractString(replyTo['createBy']) ??
      _extractString(senderMap?['id']) ??
      _extractString(senderMap?['_id']) ??
      '';
  final senderName = _extractString(replyTo['senderName']) ??
      _extractString(replyTo['name']) ??
      _extractString(replyTo['username']) ??
      _extractString(senderMap?['name']) ??
      _extractString(senderMap?['username']) ??
      '';
  final message = _extractString(replyTo['message']) ??
      _extractString(replyTo['text']) ??
      _extractString(replyTo['content']) ??
      _extractString(replyTo['body']) ??
      '';
  final type = chatMessageTypeFromString(
    _extractString(replyTo['messageType']) ??
        _extractString(replyTo['type']) ??
        'text',
  );
  final thumbnailUrl =
      _extractString(replyTo['thumbnail']) ?? _extractString(replyTo['thumb']);

  if (id.isEmpty && message.isEmpty) return null;

  return ChatReplyData(
    id: id,
    senderId: senderId,
    senderName: senderName.isNotEmpty ? senderName : senderId,
    message: message,
    type: type,
    thumbnailUrl: thumbnailUrl,
  );
}

/// Formats duration in seconds to a readable string.
String formatDuration(int seconds) {
  if (seconds <= 0) return '0:00';
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

/// Formats file size in bytes to a readable string.
String formatFileSize(int bytes) {
  if (bytes <= 0) return '';
  const suffixes = ['B', 'KB', 'MB', 'GB'];
  var i = 0;
  double size = bytes.toDouble();
  while (size >= 1024 && i < suffixes.length - 1) {
    size /= 1024;
    i++;
  }
  return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
}

// Private helpers

String? _extractString(dynamic value) {
  if (value is String) return value;
  if (value is num) return value.toString();
  return null;
}

int? _extractInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

Map<String, dynamic>? _extractMediaMap(Map<String, dynamic> content) {
  const keys = [
    'image',
    'video',
    'audio',
    'file',
    'document',
    'media',
    'attachment',
  ];
  for (final key in keys) {
    final value = content[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
  }
  final attachments = content['attachments'];
  if (attachments is List && attachments.isNotEmpty) {
    final first = attachments.first;
    if (first is Map<String, dynamic>) {
      return first;
    }
  }
  return null;
}

Map<String, dynamic>? _extractDimensionsMap(Map<String, dynamic> content) {
  final direct = content['dimensions'];
  if (direct is Map<String, dynamic>) return direct;
  final mediaMap = _extractMediaMap(content);
  if (mediaMap != null) {
    final nested = mediaMap['dimensions'];
    if (nested is Map<String, dynamic>) return nested;
  }
  return null;
}

List<ChatPollOption> _parsePollOptions(dynamic options) {
  if (options is! List) return const [];
  final parsed = <ChatPollOption>[];
  for (var i = 0; i < options.length; i++) {
    final raw = options[i];
    if (raw is String) {
      parsed.add(ChatPollOption(id: '${i + 1}', title: raw.trim()));
      continue;
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final title = _extractString(map['title']) ??
          _extractString(map['text']) ??
          _extractString(map['label']) ??
          '';
      final id = _extractString(map['id']) ?? '${i + 1}';
      final votes = (map['votes'] is num)
          ? (map['votes'] as num).toInt()
          : int.tryParse(map['votes']?.toString() ?? '') ?? 0;
      if (title.isNotEmpty) {
        parsed.add(ChatPollOption(id: id, title: title, votes: votes));
      }
    }
  }
  return parsed;
}

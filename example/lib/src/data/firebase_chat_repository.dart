import 'dart:typed_data';

import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'example_message.dart';

class FirebaseChatRepository {
  FirebaseChatRepository({
    required this.chatId,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final String chatId;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _messagesRef =>
      _firestore.collection('chats').doc(chatId).collection('messages');

  Stream<List<ExampleMessage>> messageStream({int limit = 50}) {
    return _messagesRef
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromDoc).toList());
  }

  String newMessageId() => _messagesRef.doc().id;

  Future<void> sendMessage(ExampleMessage message) async {
    await _messagesRef.doc(message.id).set(_toMap(message));
  }

  Future<void> updateMessage(ExampleMessage message) async {
    await _messagesRef.doc(message.id).update(_toMap(message));
  }

  Future<String> uploadBytes({
    required Uint8List bytes,
    required String path,
    required String contentType,
  }) async {
    final ref = _storage.ref().child(path);
    final metadata = SettableMetadata(contentType: contentType);
    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  ExampleMessage _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    final createdAt = _parseDate(data['createdAt']);
    final updatedAt = _parseDate(data['updatedAt']);
    final type = _parseMessageType(data['type']);
    final status = _parseMessageStatus(data['status']);
    final senderData = _parseSender(data['senderData']);

    return ExampleMessage(
      id: doc.id,
      chatId: data['chatId']?.toString() ?? chatId,
      senderId: data['senderId']?.toString() ?? '',
      senderData: senderData,
      type: type,
      status: status,
      textContent: data['textContent']?.toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      mediaData: _parseMedia(data['mediaData']),
      contactData: _parseContact(data['contactData']),
      locationData: _parseLocation(data['locationData']),
      pollData: _parsePoll(data['pollData']),
      meetingReportData: null,
      replyData: _parseReply(data['replyData']),
      replyToId: data['replyToId']?.toString(),
      isDeleted: data['isDeleted'] == true,
      isPinned: data['isPinned'] == true,
      isEdited: data['isEdited'] == true,
      isForwarded: data['isForwarded'] == true,
      forwardedFromId: data['forwardedFromId']?.toString(),
      reactions: _parseReactions(data['reactions']),
    );
  }

  Map<String, dynamic> _toMap(ExampleMessage message) {
    return {
      'chatId': message.chatId,
      'senderId': message.senderId,
      'senderData': _mapSender(message.senderData),
      'type': message.type.name,
      'status': message.status.name,
      'textContent': message.textContent,
      'createdAt': message.createdAt != null
          ? Timestamp.fromDate(message.createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': message.updatedAt != null
          ? Timestamp.fromDate(message.updatedAt!)
          : null,
      'mediaData': _mapMedia(message.mediaData),
      'contactData': _mapContact(message.contactData),
      'locationData': _mapLocation(message.locationData),
      'pollData': _mapPoll(message.pollData),
      'replyData': _mapReply(message.replyData),
      'replyToId': message.replyToId,
      'isDeleted': message.isDeleted,
      'isPinned': message.isPinned,
      'isEdited': message.isEdited,
      'isForwarded': message.isForwarded,
      'forwardedFromId': message.forwardedFromId,
      'reactions': _mapReactions(message.reactions),
    };
  }

  DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  ChatMessageType _parseMessageType(dynamic value) {
    final raw = value?.toString();
    return ChatMessageType.values.firstWhere(
      (type) => type.name == raw,
      orElse: () => ChatMessageType.text,
    );
  }

  ChatMessageStatus _parseMessageStatus(dynamic value) {
    final raw = value?.toString();
    return ChatMessageStatus.values.firstWhere(
      (status) => status.name == raw,
      orElse: () => ChatMessageStatus.sent,
    );
  }

  ChatSenderData? _parseSender(dynamic value) {
    if (value is! Map) return null;
    return ChatSenderData(
      id: value['id']?.toString() ?? '',
      name: value['name']?.toString(),
      username: value['username']?.toString(),
      imageUrl: value['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic>? _mapSender(ChatSenderData? sender) {
    if (sender == null) return null;
    return {
      'id': sender.id,
      'name': sender.name,
      'username': sender.username,
      'imageUrl': sender.imageUrl,
    };
  }

  ChatMediaData? _parseMedia(dynamic value) {
    if (value is! Map) return null;
    final mediaType = _parseMessageType(value['mediaType']);
    final duration = value['duration'] is num ? value['duration'].toInt() : null;
    final fileSize = value['fileSize'] is num ? value['fileSize'].toInt() : null;
    final aspectRatio = value['aspectRatio'] is num
        ? (value['aspectRatio'] as num).toDouble()
        : null;

    final url = value['url']?.toString();
    if (url == null) return null;

    return ChatMediaData(
      url: url,
      mediaType: mediaType,
      thumbnailUrl: value['thumbnailUrl']?.toString(),
      duration: duration,
      fileName: value['fileName']?.toString(),
      fileSize: fileSize,
      aspectRatio: aspectRatio,
    );
  }

  Map<String, dynamic>? _mapMedia(ChatMediaData? media) {
    if (media == null) return null;
    return {
      'url': media.url,
      'mediaType': media.mediaType.name,
      'thumbnailUrl': media.thumbnailUrl,
      'duration': media.duration,
      'fileName': media.fileName,
      'fileSize': media.fileSize,
      'aspectRatio': media.aspectRatio,
    };
  }

  ChatContactData? _parseContact(dynamic value) {
    if (value is! Map) return null;
    final name = value['name']?.toString();
    if (name == null || name.isEmpty) return null;
    return ChatContactData(
      name: name,
      phone: value['phone']?.toString(),
      email: value['email']?.toString(),
      avatar: value['avatar']?.toString(),
    );
  }

  Map<String, dynamic>? _mapContact(ChatContactData? contact) {
    if (contact == null) return null;
    return {
      'name': contact.name,
      'phone': contact.phone,
      'email': contact.email,
      'avatar': contact.avatar,
    };
  }

  ChatLocationData? _parseLocation(dynamic value) {
    if (value is! Map) return null;
    return ChatLocationData(
      latitude: (value['latitude'] as num?)?.toDouble(),
      longitude: (value['longitude'] as num?)?.toDouble(),
      name: value['name']?.toString(),
      address: value['address']?.toString(),
    );
  }

  Map<String, dynamic>? _mapLocation(ChatLocationData? location) {
    if (location == null) return null;
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'name': location.name,
      'address': location.address,
    };
  }

  ChatPollData? _parsePoll(dynamic value) {
    if (value is! Map) return null;
    final question = value['question']?.toString();
    if (question == null || question.isEmpty) return null;
    final options = <ChatPollOption>[];
    final rawOptions = value['options'];
    if (rawOptions is List) {
      for (final option in rawOptions) {
        if (option is Map) {
          options.add(
            ChatPollOption(
              id: option['id']?.toString() ?? '',
              title: option['title']?.toString() ?? '',
              votes: option['votes'] is num ? option['votes'].toInt() : 0,
              voterIds: (option['voterIds'] as List?)
                      ?.map((item) => item.toString())
                      .toList() ??
                  const [],
            ),
          );
        }
      }
    }
    return ChatPollData(
      question: question,
      options: options,
      totalVotes: value['totalVotes'] is num ? value['totalVotes'].toInt() : 0,
      isMultiple: value['isMultiple'] == true,
      isClosed: value['isClosed'] == true,
      isAnonymous: value['isAnonymous'] == true,
      expiresAt: _parseDate(value['expiresAt']),
    );
  }

  Map<String, dynamic>? _mapPoll(ChatPollData? poll) {
    if (poll == null) return null;
    return {
      'question': poll.question,
      'options': poll.options
          .map(
            (option) => {
              'id': option.id,
              'title': option.title,
              'votes': option.votes,
              'voterIds': option.voterIds,
            },
          )
          .toList(),
      'totalVotes': poll.totalVotes,
      'isMultiple': poll.isMultiple,
      'isClosed': poll.isClosed,
      'isAnonymous': poll.isAnonymous,
      'expiresAt': poll.expiresAt != null
          ? Timestamp.fromDate(poll.expiresAt!)
          : null,
    };
  }

  ChatReplyData? _parseReply(dynamic value) {
    if (value is! Map) return null;
    final id = value['id']?.toString();
    if (id == null || id.isEmpty) return null;
    return ChatReplyData(
      id: id,
      senderId: value['senderId']?.toString() ?? '',
      senderName: value['senderName']?.toString() ?? '',
      message: value['message']?.toString() ?? '',
      type: _parseMessageType(value['type']),
      thumbnailUrl: value['thumbnailUrl']?.toString(),
    );
  }

  Map<String, dynamic>? _mapReply(ChatReplyData? reply) {
    if (reply == null) return null;
    return {
      'id': reply.id,
      'senderId': reply.senderId,
      'senderName': reply.senderName,
      'message': reply.message,
      'type': reply.type.name,
      'thumbnailUrl': reply.thumbnailUrl,
    };
  }

  List<ChatReactionData> _parseReactions(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map>()
        .map(
          (reaction) => ChatReactionData(
            emoji: reaction['emoji']?.toString() ?? '',
            userId: reaction['userId']?.toString() ?? '',
            createdAt: _parseDate(reaction['createdAt']),
          ),
        )
        .where((reaction) => reaction.emoji.isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> _mapReactions(List<ChatReactionData> reactions) {
    return reactions
        .map(
          (reaction) => {
            'emoji': reaction.emoji,
            'userId': reaction.userId,
            'createdAt': reaction.createdAt != null
                ? Timestamp.fromDate(reaction.createdAt!)
                : null,
          },
        )
        .toList();
  }
}

import 'dart:async';
import 'dart:typed_data';

import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:http/http.dart' as http;
import 'package:smart_pagination/pagination.dart';

import 'example_message.dart';
import 'example_sample_data.dart';
import 'firebase_chat_repository.dart';

class FirebaseChatController {
  FirebaseChatController({
    required this.currentUserId,
    required this.chatId,
    FirebaseChatRepository? repository,
  }) : _repository = repository ?? FirebaseChatRepository(chatId: chatId) {
    messagesCubit = SmartPaginationCubit<IChatMessageData>(
      request: const PaginationRequest(page: 1, pageSize: 50),
      provider: PaginationProvider.future(_fetchMessages),
    );

    _subscription = _repository.messageStream().listen((messages) {
      _items = messages;
      messagesCubit.setItems(_items);
    });
  }

  final String currentUserId;
  final String chatId;
  final FirebaseChatRepository _repository;
  late final SmartPaginationCubit<IChatMessageData> messagesCubit;

  List<ExampleMessage> _items = [];
  StreamSubscription<List<ExampleMessage>>? _subscription;

  Future<List<IChatMessageData>> _fetchMessages(PaginationRequest request) async {
    return _items;
  }

  Future<void> loadInitial() async {
    messagesCubit.fetchPaginatedList();
  }

  Future<void> refresh() async {
    messagesCubit.refreshPaginatedList();
  }

  Future<void> sendText(String text, {ChatReplyData? reply}) async {
    final message = _baseMessage(
      id: _repository.newMessageId(),
      type: ChatMessageType.text,
      textContent: text.trim(),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> sendImage({ChatReplyData? reply}) async {
    final messageId = _repository.newMessageId();
    final url = await _uploadFromUrl(
      url: ExampleSampleData.defaultImageUrls.first,
      pathSuffix: 'image.jpg',
      contentType: 'image/jpeg',
      messageId: messageId,
    );
    final message = _baseMessage(
      id: messageId,
      type: ChatMessageType.image,
      textContent: 'Shared an image',
      mediaData: ChatMediaData(
        url: url,
        mediaType: ChatMessageType.image,
        aspectRatio: 1.2,
      ),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> sendVideo({ChatReplyData? reply}) async {
    final messageId = _repository.newMessageId();
    final url = await _uploadFromUrl(
      url: ExampleSampleData.defaultVideoUrls.first,
      pathSuffix: 'video.mp4',
      contentType: 'video/mp4',
      messageId: messageId,
    );
    final message = _baseMessage(
      id: messageId,
      type: ChatMessageType.video,
      textContent: 'Shared a video clip',
      mediaData: ChatMediaData(
        url: url,
        thumbnailUrl: ExampleSampleData.defaultImageUrls[1],
        mediaType: ChatMessageType.video,
        duration: 90,
        aspectRatio: 1.6,
      ),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> sendAudio({ChatReplyData? reply}) async {
    final messageId = _repository.newMessageId();
    final url = await _uploadFromUrl(
      url: ExampleSampleData.defaultAudioUrls.first,
      pathSuffix: 'audio.mp3',
      contentType: 'audio/mpeg',
      messageId: messageId,
    );
    final message = _baseMessage(
      id: messageId,
      type: ChatMessageType.audio,
      mediaData: ChatMediaData(
        url: url,
        mediaType: ChatMessageType.audio,
        duration: 24,
      ),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> sendDocument({ChatReplyData? reply}) async {
    final messageId = _repository.newMessageId();
    final url = await _uploadFromUrl(
      url: ExampleSampleData.defaultDocUrls.first,
      pathSuffix: 'document.pdf',
      contentType: 'application/pdf',
      messageId: messageId,
    );
    final message = _baseMessage(
      id: messageId,
      type: ChatMessageType.document,
      textContent: 'Project-Overview.pdf',
      mediaData: ChatMediaData(
        url: url,
        mediaType: ChatMessageType.document,
        fileName: 'Project-Overview.pdf',
        fileSize: 2457600,
      ),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> sendContact({ChatReplyData? reply}) async {
    final message = _baseMessage(
      id: _repository.newMessageId(),
      type: ChatMessageType.contact,
      contactData: const ChatContactData(
        name: 'Lina Qasem',
        phone: '+971 55 123 7890',
        email: 'lina.qasem@example.com',
      ),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> sendLocation({ChatReplyData? reply}) async {
    final message = _baseMessage(
      id: _repository.newMessageId(),
      type: ChatMessageType.location,
      textContent: 'Meeting point shared',
      locationData: const ChatLocationData(
        latitude: 25.2048,
        longitude: 55.2708,
        name: 'DIFC Gate Village',
        address: 'Dubai, UAE',
      ),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> sendPoll({ChatReplyData? reply}) async {
    final message = _baseMessage(
      id: _repository.newMessageId(),
      type: ChatMessageType.poll,
      pollData: const ChatPollData(
        question: 'Which feature should we ship next?',
        options: [
          ChatPollOption(id: 'opt_1', title: 'Message search', votes: 3),
          ChatPollOption(id: 'opt_2', title: 'Media caching', votes: 2),
          ChatPollOption(id: 'opt_3', title: 'Pinned messages', votes: 1),
        ],
        totalVotes: 6,
      ),
      reply: reply,
    );
    await _repository.sendMessage(message);
  }

  Future<void> seedSampleMessages() async {
    await sendText('Welcome to the Firebase demo chat.');
    await sendImage();
    await sendVideo();
    await sendAudio();
    await sendDocument();
    await sendContact();
    await sendLocation();
    await sendPoll();
  }

  void toggleReaction(IChatMessageData message, String emoji) {
    if (message is! ExampleMessage) return;
    final reactions = List<ChatReactionData>.from(message.reactions);
    final existingIndex = reactions.indexWhere(
      (reaction) =>
          reaction.emoji == emoji && reaction.userId == currentUserId,
    );

    if (existingIndex >= 0) {
      reactions.removeAt(existingIndex);
    } else {
      reactions.add(
        ChatReactionData(
          emoji: emoji,
          userId: currentUserId,
          createdAt: DateTime.now(),
        ),
      );
    }

    final updated = message.copyWith(reactions: reactions);
    _repository.updateMessage(updated);
  }

  void deleteMessages(Set<IChatMessageData> messages) {
    for (final message in messages) {
      if (message is! ExampleMessage) continue;
      final deleted = message.copyWith(isDeleted: true);
      _repository.updateMessage(deleted);
    }
  }

  Future<String> _uploadFromUrl({
    required String url,
    required String pathSuffix,
    required String contentType,
    required String messageId,
  }) async {
    final bytes = await _downloadBytes(url);
    if (bytes == null) return url;

    final path = 'chat_media/$chatId/$messageId/$pathSuffix';
    try {
      return await _repository.uploadBytes(
        bytes: bytes,
        path: path,
        contentType: contentType,
      );
    } catch (_) {
      return url;
    }
  }

  Future<Uint8List?> _downloadBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      }
    } catch (_) {}
    return null;
  }

  ExampleMessage _baseMessage({
    required String id,
    required ChatMessageType type,
    String? textContent,
    ChatMediaData? mediaData,
    ChatContactData? contactData,
    ChatLocationData? locationData,
    ChatPollData? pollData,
    ChatReplyData? reply,
  }) {
    return ExampleMessage(
      id: id,
      chatId: chatId,
      senderId: currentUserId,
      senderData: ExampleSampleData.users[currentUserId] ??
          ChatSenderData(id: currentUserId, name: 'You'),
      type: type,
      textContent: textContent,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.sent,
      mediaData: mediaData,
      contactData: contactData,
      locationData: locationData,
      pollData: pollData,
      replyData: reply,
      replyToId: reply?.id,
    );
  }

  void dispose() {
    _subscription?.cancel();
    messagesCubit.dispose();
  }
}

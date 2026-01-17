import 'dart:io';

import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import 'example_message.dart';
import 'example_sample_data.dart';

class ExampleChatRepository {
  ExampleChatRepository({required List<ExampleMessage> messages})
      : _messages = List<ExampleMessage>.from(messages);

  final List<ExampleMessage> _messages;

  List<ExampleMessage> get messages =>
      List<ExampleMessage>.unmodifiable(_messages);

  Future<List<IChatMessageData>> fetchMessages(
      PaginationRequest request) async {
    final pageSize = request.pageSize ?? 20;
    final startIndex = (request.page - 1) * pageSize;

    if (startIndex >= _messages.length) {
      return [];
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _messages.skip(startIndex).take(pageSize).toList();
  }

  void insertMessage(ExampleMessage message) {
    _messages.insert(0, message);
  }

  void updateMessage(ExampleMessage message) {
    final index = _messages.indexWhere((item) => item.id == message.id);
    if (index != -1) {
      _messages[index] = message;
    }
  }
}

class ExampleChatController {
  ExampleChatController({
    required this.currentUserId,
    required List<ExampleMessage> seedMessages,
  }) : _repository = ExampleChatRepository(messages: seedMessages) {
    messagesCubit = SmartPaginationCubit<IChatMessageData>(
      request: const PaginationRequest(page: 1, pageSize: 12),
      provider: PaginationProvider.future(_repository.fetchMessages),
    );
  }

  final String currentUserId;
  final ExampleChatRepository _repository;
  late final SmartPaginationCubit<IChatMessageData> messagesCubit;

  List<ExampleMessage> get allMessages => _repository.messages;

  Future<void> loadInitial() async {
    messagesCubit.fetchPaginatedList();
  }

  Future<void> refresh() async {
    messagesCubit.refreshPaginatedList();
  }

  Future<void> sendText(String text, {ChatReplyData? reply}) async {
    final message = ExampleMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      chatId: 'demo-chat',
      senderId: currentUserId,
      senderData: ExampleSampleData.users[currentUserId],
      type: ChatMessageType.text,
      textContent: text.trim(),
      createdAt: DateTime.now(),
      status: ChatMessageStatus.pending,
      replyData: reply,
      replyToId: reply?.id,
    );

    // Insert immediately into cubit for instant UI update
    _repository.insertMessage(message);
    messagesCubit.insertEmit(message, index: 0);

    // Simulate backend send (in real app, this would be an API call)
    await _simulateBackendSend(message);
  }

  /// Sends an image message
  Future<void> sendImage(
    File file, {
    ChatReplyData? reply,
    String? caption,
  }) async {
    final message = ExampleMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      chatId: 'demo-chat',
      senderId: currentUserId,
      senderData: ExampleSampleData.users[currentUserId],
      type: ChatMessageType.image,
      textContent: caption,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.pending,
      replyData: reply,
      replyToId: reply?.id,
      mediaData: ChatMediaData(
          url: file.path,
          mediaType: ChatMessageType.image,
          metadata: MediaMetadata(
            fileName: file.path.split('/').last,
            fileSize: await file.length(),
          )),
    );

    _repository.insertMessage(message);
    messagesCubit.insertEmit(message, index: 0);

    await _simulateBackendSend(message);
  }

  /// Sends a video message
  Future<void> sendVideo(
    File file, {
    ChatReplyData? reply,
    String? caption,
    String? thumbnailPath,
  }) async {
    final message = ExampleMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      chatId: 'demo-chat',
      senderId: currentUserId,
      senderData: ExampleSampleData.users[currentUserId],
      type: ChatMessageType.video,
      textContent: caption,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.pending,
      replyData: reply,
      replyToId: reply?.id,
      mediaData: ChatMediaData(
        url: file.path,
        thumbnailUrl: thumbnailPath,
        mediaType: ChatMessageType.video,
        metadata: MediaMetadata(
          fileName: file.path.split('/').last,
          fileSize: await file.length(),
        ),
      ),
    );

    _repository.insertMessage(message);
    messagesCubit.insertEmit(message, index: 0);

    await _simulateBackendSend(message);
  }

  /// Sends a document message
  Future<void> sendDocument(
    File file, {
    ChatReplyData? reply,
    String? fileName,
  }) async {
    final name = fileName ?? file.path.split('/').last;
    final message = ExampleMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      chatId: 'demo-chat',
      senderId: currentUserId,
      senderData: ExampleSampleData.users[currentUserId],
      type: ChatMessageType.document,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.pending,
      replyData: reply,
      replyToId: reply?.id,
      mediaData: ChatMediaData(
        url: file.path,
        mediaType: ChatMessageType.document,
        metadata: MediaMetadata(
          fileName: name,
          fileSize: await file.length(),
        ),
      ),
    );

    _repository.insertMessage(message);
    messagesCubit.insertEmit(message, index: 0);

    await _simulateBackendSend(message);
  }

  /// Sends an audio message
  Future<void> sendAudio(
    String filePath, {
    int? duration,
    List<double>? waveform,
    ChatReplyData? reply,
  }) async {
    final file = File(filePath);
    final message = ExampleMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      chatId: 'demo-chat',
      senderId: currentUserId,
      senderData: ExampleSampleData.users[currentUserId],
      type: ChatMessageType.audio,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.pending,
      replyData: reply,
      replyToId: reply?.id,
      mediaData: ChatMediaData(
        url: filePath,
        mediaType: ChatMessageType.audio,
        metadata: MediaMetadata(
          fileName: filePath.split('/').last,
          fileSize: await file.length(),
          durationInSeconds: duration?.toDouble(),
          waveform: waveform == null ? null : WaveformData(samples: waveform),
        ),
      ),
    );

    _repository.insertMessage(message);
    messagesCubit.insertEmit(message, index: 0);

    await _simulateBackendSend(message);
  }

  /// Simulates backend send and updates message status
  Future<void> _simulateBackendSend(ExampleMessage message) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Update to sent status
    final sentMessage = message.copyWith(status: ChatMessageStatus.sent);
    _repository.updateMessage(sentMessage);
    messagesCubit.addOrUpdateEmit(sentMessage, index: 0);

    // Simulate delivery confirmation
    await Future<void>.delayed(const Duration(seconds: 1));
    final deliveredMessage =
        sentMessage.copyWith(status: ChatMessageStatus.delivered);
    _repository.updateMessage(deliveredMessage);
    messagesCubit.addOrUpdateEmit(deliveredMessage, index: 0);
  }

  void toggleReaction(IChatMessageData message, String emoji) {
    if (message is! ExampleMessage) return;

    final updatedReactions = List<ChatReactionData>.from(message.reactions);
    final existingIndex = updatedReactions.indexWhere(
      (reaction) => reaction.emoji == emoji && reaction.userId == currentUserId,
    );

    if (existingIndex >= 0) {
      updatedReactions.removeAt(existingIndex);
    } else {
      updatedReactions.add(
        ChatReactionData(
          emoji: emoji,
          userId: currentUserId,
          createdAt: DateTime.now(),
        ),
      );
    }

    final updated = message.copyWith(reactions: updatedReactions);
    _repository.updateMessage(updated);
    messagesCubit.addOrUpdateEmit(updated, index: 0);
  }

  void deleteMessages(Set<IChatMessageData> messages) {
    for (final message in messages) {
      if (message is! ExampleMessage) continue;
      final deleted = message.copyWith(isDeleted: true);
      _repository.updateMessage(deleted);
      messagesCubit.addOrUpdateEmit(deleted, index: 0);
    }
  }

  void dispose() {
    messagesCubit.dispose();
  }
}

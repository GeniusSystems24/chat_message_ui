import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import 'example_message.dart';

class ExampleChatRepository {
  ExampleChatRepository({required List<ExampleMessage> messages})
      : _messages = List<ExampleMessage>.from(messages);

  final List<ExampleMessage> _messages;

  List<ExampleMessage> get messages => List<ExampleMessage>.unmodifiable(_messages);

  Future<List<IChatMessageData>> fetchMessages(PaginationRequest request) async {
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
      senderData: ChatSenderData(id: currentUserId, name: 'You'),
      type: ChatMessageType.text,
      textContent: text.trim(),
      createdAt: DateTime.now(),
      status: ChatMessageStatus.sent,
      replyData: reply,
      replyToId: reply?.id,
    );

    _repository.insertMessage(message);
    messagesCubit.insertEmit(message, index: 0);
  }

  void toggleReaction(IChatMessageData message, String emoji) {
    if (message is! ExampleMessage) return;

    final updatedReactions = List<ChatReactionData>.from(message.reactions);
    final existingIndex = updatedReactions.indexWhere(
      (reaction) =>
          reaction.emoji == emoji && reaction.userId == currentUserId,
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

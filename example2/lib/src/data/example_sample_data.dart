import 'package:chat_message_ui/chat_message_ui.dart';

import 'example_message.dart';

class ExampleSampleData {
  static const String chatId = 'demo-chat';
  static const String currentUserId = 'user_1';

  static final Map<String, ChatSenderData> users = {
    'user_1': const ChatSenderData(
      id: 'user_1',
      name: 'Amina',
      imageUrl: 'https://i.pravatar.cc/150?img=32',
    ),
    'user_2': const ChatSenderData(
      id: 'user_2',
      name: 'Omar',
      imageUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    'user_3': const ChatSenderData(
      id: 'user_3',
      name: 'Sara',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
  };

  static const List<String> _defaultImageUrls = [
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/operation.png?alt=media&token=6e1d3457-f2f3-43db-bcf3-70332e19d298',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/primary_sys%2F%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AC%D8%A7%D8%AA%2F125.jpg?alt=media&token=a3694a14-7774-411d-aeee-7d9ccaa732c5',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/primary_sys%2F%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AC%D8%A7%D8%AA%2F133.jpg?alt=media&token=61b704f4-ec12-47e2-8dd9-6ff2cae0f21b',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/primary_sys%2F%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AC%D8%A7%D8%AA%2F138.jpg?alt=media&token=73d01be7-b109-495e-b8de-fd9f9bd22261',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/primary_sys%2F%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AC%D8%A7%D8%AA%2F140.jpg?alt=media&token=8e801d2a-5694-469c-9be8-bb24765df45e',
  ];

  static const List<String> _defaultVideoUrls = [
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/What%20are%20Chatbots-.mp4?alt=media&token=68b7385c-8394-48d3-9ac3-2b26b22abb1d',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/What%20are%20Chatbots-.mp4?alt=media&token=68b7385c-8394-48d3-9ac3-2b26b22abb1d',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/What%20are%20Chatbots-.mp4?alt=media&token=68b7385c-8394-48d3-9ac3-2b26b22abb1d',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/What%20are%20Chatbots-.mp4?alt=media&token=68b7385c-8394-48d3-9ac3-2b26b22abb1d',
  ];

  static const List<String> _defaultDocUrls = [
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/0106%D8%B9%D9%84%D9%88%D9%85%20%D8%B5%D9%81%20%D8%A7%D9%88%D9%84%20%D8%AC%D8%B2%D8%A1%201.pdf?alt=media&token=9c0c552c-bc33-4bd9-9c5b-3a287ef7794d',
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/0405%D8%B1%D9%8A%D8%A7%D8%B6%D9%8A%D8%A7%D8%AA%20%D8%B1%D8%A7%D8%A8%D8%B9%20%D8%AC%D8%B2%D8%A1%20%D8%AB%D8%A7%D9%86%D9%8A.pdf?alt=media&token=6c291fd8-4137-42be-8ae5-8e56df982eef',
  ];

  static const List<String> _defaultAudioUrls = [
    'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/WhatsApp%20Ptt%202026-01-06%20at%2019.11.56.mp3?alt=media&token=8bc5b4c3-d4d1-4fb5-a207-63f0744079b1',
  ];

  static List<ExampleMessage> buildMessages() {
    final baseTime = DateTime.now().subtract(const Duration(minutes: 90));

    final messages = <ExampleMessage>[
      ExampleMessage(
        id: 'msg_1',
        chatId: chatId,
        senderId: 'user_2',
        senderData: users['user_2'],
        type: ChatMessageType.text,
        textContent:
            'Welcome to chat_message_ui. Explore the package on https://pub.dev and try message search.',
        createdAt: baseTime,
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'msg_2',
        chatId: chatId,
        senderId: 'user_1',
        senderData: users['user_1'],
        type: ChatMessageType.text,
        textContent:
            'Thanks @omar! I added #release notes. Email support@demo.dev or call +1 415 555 0123.',
        createdAt: baseTime.add(const Duration(minutes: 6)),
        status: ChatMessageStatus.read,
        reactions: const [
          ChatReactionData(emoji: '👍', userId: 'user_2'),
          ChatReactionData(emoji: '🔥', userId: 'user_3'),
        ],
      ),
      ExampleMessage(
        id: 'msg_3',
        chatId: chatId,
        senderId: 'user_3',
        senderData: users['user_3'],
        type: ChatMessageType.image,
        textContent: 'Design mock from the new onboarding flow.',
        createdAt: baseTime.add(const Duration(minutes: 12)),
        status: ChatMessageStatus.read,
        mediaData: ChatMediaData(
          url: _defaultImageUrls[0],
          mediaType: ChatMessageType.image,
          aspectRatio: 1.2,
        ),
      ),
      ExampleMessage(
        id: 'msg_4',
        chatId: chatId,
        senderId: 'user_1',
        senderData: users['user_1'],
        type: ChatMessageType.video,
        textContent: 'Quick demo recording.',
        createdAt: baseTime.add(const Duration(minutes: 18)),
        status: ChatMessageStatus.delivered,
        mediaData: ChatMediaData(
          url: _defaultVideoUrls[0],
          thumbnailUrl: _defaultImageUrls[1],
          mediaType: ChatMessageType.video,
          duration: 90,
          aspectRatio: 1.6,
        ),
      ),
      ExampleMessage(
        id: 'msg_5',
        chatId: chatId,
        senderId: 'user_2',
        senderData: users['user_2'],
        type: ChatMessageType.audio,
        createdAt: baseTime.add(const Duration(minutes: 26)),
        status: ChatMessageStatus.read,
        mediaData: ChatMediaData(
          url: _defaultAudioUrls[0],
          mediaType: ChatMessageType.audio,
          duration: 24,
        ),
      ),
      ExampleMessage(
        id: 'msg_6',
        chatId: chatId,
        senderId: 'user_2',
        senderData: users['user_2'],
        type: ChatMessageType.document,
        textContent: 'Architecture-Overview.pdf',
        createdAt: baseTime.add(const Duration(minutes: 34)),
        status: ChatMessageStatus.read,
        mediaData: ChatMediaData(
          url: _defaultDocUrls[0],
          mediaType: ChatMessageType.document,
          fileName: 'Architecture-Overview.pdf',
          fileSize: 2457600,
        ),
      ),
      ExampleMessage(
        id: 'msg_7',
        chatId: chatId,
        senderId: 'user_3',
        senderData: users['user_3'],
        type: ChatMessageType.location,
        textContent: 'Let’s meet here.',
        createdAt: baseTime.add(const Duration(minutes: 42)),
        status: ChatMessageStatus.read,
        locationData: const ChatLocationData(
          latitude: 25.2048,
          longitude: 55.2708,
          name: 'DIFC Gate Village',
          address: 'Dubai, UAE',
        ),
      ),
      ExampleMessage(
        id: 'msg_8',
        chatId: chatId,
        senderId: 'user_2',
        senderData: users['user_2'],
        type: ChatMessageType.contact,
        createdAt: baseTime.add(const Duration(minutes: 50)),
        status: ChatMessageStatus.read,
        contactData: const ChatContactData(
          name: 'Noura Al Ali',
          phone: '+971 50 123 4567',
          email: 'noura@example.com',
        ),
      ),
      ExampleMessage(
        id: 'msg_9',
        chatId: chatId,
        senderId: 'user_3',
        senderData: users['user_3'],
        type: ChatMessageType.poll,
        createdAt: baseTime.add(const Duration(minutes: 58)),
        status: ChatMessageStatus.read,
        pollData: const ChatPollData(
          question: 'Which sprint goal should we prioritize?',
          options: [
            ChatPollOption(id: 'opt_1', title: 'Search experience', votes: 6),
            ChatPollOption(id: 'opt_2', title: 'Media performance', votes: 4),
            ChatPollOption(id: 'opt_3', title: 'Accessibility polish', votes: 2),
          ],
          totalVotes: 12,
          isMultiple: false,
        ),
      ),
      ExampleMessage(
        id: 'msg_10',
        chatId: chatId,
        senderId: 'user_1',
        senderData: users['user_1'],
        type: ChatMessageType.text,
        textContent: 'Replying with context and attachments below.',
        createdAt: baseTime.add(const Duration(minutes: 64)),
        status: ChatMessageStatus.sent,
        replyToId: 'msg_3',
        replyData: ChatReplyData(
          id: 'msg_3',
          senderId: 'user_3',
          senderName: 'Sara',
          message: 'Design mock from the new onboarding flow.',
          type: ChatMessageType.image,
          thumbnailUrl: _defaultImageUrls[0],
        ),
      ),
      ExampleMessage(
        id: 'msg_11',
        chatId: chatId,
        senderId: 'user_2',
        senderData: users['user_2'],
        type: ChatMessageType.text,
        textContent: 'I edited this note to include the final ETA.',
        createdAt: baseTime.add(const Duration(minutes: 70)),
        status: ChatMessageStatus.read,
        isEdited: true,
      ),
      ExampleMessage(
        id: 'msg_12',
        chatId: chatId,
        senderId: 'user_1',
        senderData: users['user_1'],
        type: ChatMessageType.text,
        textContent: 'Forwarded insight from the product team.',
        createdAt: baseTime.add(const Duration(minutes: 74)),
        status: ChatMessageStatus.delivered,
        isForwarded: true,
        forwardedFromId: 'chat_product',
      ),
      ExampleMessage(
        id: 'msg_13',
        chatId: chatId,
        senderId: 'user_3',
        senderData: users['user_3'],
        type: ChatMessageType.text,
        textContent: 'This message was deleted.',
        createdAt: baseTime.add(const Duration(minutes: 79)),
        status: ChatMessageStatus.read,
        isDeleted: true,
      ),
      ExampleMessage(
        id: 'msg_14',
        chatId: chatId,
        senderId: 'user_1',
        senderData: users['user_1'],
        type: ChatMessageType.text,
        textContent: 'Queued message while offline.',
        createdAt: baseTime.add(const Duration(minutes: 86)),
        status: ChatMessageStatus.pending,
      ),
    ];

    return messages.reversed.toList();
  }
}

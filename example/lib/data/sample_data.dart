import 'package:chat_message_ui/chat_message_ui.dart';
import 'mock_message.dart';

/// Current user ID used throughout the example
const String currentUserId = 'user_1';

/// Sample sender data
const ChatSenderData sender1 = ChatSenderData(
  id: 'user_1',
  name: 'Ahmed Hassan',
  username: 'ahmed_h',
  imageUrl: 'https://i.pravatar.cc/150?img=1',
);

const ChatSenderData sender2 = ChatSenderData(
  id: 'user_2',
  name: 'Sara Mohamed',
  username: 'sara_m',
  imageUrl: 'https://i.pravatar.cc/150?img=5',
);

const ChatSenderData sender3 = ChatSenderData(
  id: 'user_3',
  name: 'Omar Ali',
  username: 'omar_a',
  imageUrl: 'https://i.pravatar.cc/150?img=3',
);

/// Sample text messages
List<MockChatMessage> get sampleTextMessages => [
      MockChatMessage(
        id: 'msg_1',
        chatId: 'chat_1',
        senderId: 'user_2',
        type: ChatMessageType.text,
        textContent: 'Hello! How are you doing today?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: ChatMessageStatus.read,
        senderData: sender2,
      ),
      MockChatMessage(
        id: 'msg_2',
        chatId: 'chat_1',
        senderId: currentUserId,
        type: ChatMessageType.text,
        textContent: 'I\'m doing great, thanks for asking! Working on a new Flutter project.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 28)),
        status: ChatMessageStatus.read,
        senderData: sender1,
        reactions: const [
          ChatReactionData(emoji: '👍', userId: 'user_2'),
          ChatReactionData(emoji: '❤️', userId: 'user_3'),
        ],
      ),
      MockChatMessage(
        id: 'msg_3',
        chatId: 'chat_1',
        senderId: 'user_2',
        type: ChatMessageType.text,
        textContent: 'That sounds exciting! What kind of project?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        status: ChatMessageStatus.read,
        senderData: sender2,
        replyData: const ChatReplyData(
          id: 'msg_2',
          senderId: 'user_1',
          senderName: 'Ahmed Hassan',
          message: 'I\'m doing great, thanks for asking!',
          type: ChatMessageType.text,
        ),
      ),
      MockChatMessage(
        id: 'msg_4',
        chatId: 'chat_1',
        senderId: currentUserId,
        type: ChatMessageType.text,
        textContent: 'A chat UI library with support for various message types like images, videos, audio, and more!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        status: ChatMessageStatus.delivered,
        senderData: sender1,
      ),
    ];

/// Sample image messages
List<MockChatMessage> get sampleImageMessages => [
      MockChatMessage(
        id: 'img_1',
        chatId: 'chat_1',
        senderId: 'user_2',
        type: ChatMessageType.image,
        textContent: 'Check out this beautiful sunset!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        status: ChatMessageStatus.read,
        senderData: sender2,
        mediaData: const ChatMediaData(
          url: 'https://picsum.photos/800/600',
          thumbnailUrl: 'https://picsum.photos/200/150',
          mediaType: ChatMessageType.image,
          fileSize: 1024 * 500, // 500 KB
          fileName: 'sunset.jpg',
          aspectRatio: 1.33,
        ),
      ),
      MockChatMessage(
        id: 'img_2',
        chatId: 'chat_1',
        senderId: currentUserId,
        type: ChatMessageType.image,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        status: ChatMessageStatus.read,
        senderData: sender1,
        mediaData: const ChatMediaData(
          url: 'https://picsum.photos/600/800',
          thumbnailUrl: 'https://picsum.photos/150/200',
          mediaType: ChatMessageType.image,
          fileSize: 1024 * 750, // 750 KB
          fileName: 'photo.jpg',
          aspectRatio: 0.75,
        ),
      ),
    ];

/// Sample audio messages
List<MockChatMessage> get sampleAudioMessages => [
      MockChatMessage(
        id: 'audio_1',
        chatId: 'chat_1',
        senderId: 'user_2',
        type: ChatMessageType.audio,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        status: ChatMessageStatus.read,
        senderData: sender2,
        mediaData: const ChatMediaData(
          url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          mediaType: ChatMessageType.audio,
          duration: 185, // 3:05
          fileSize: 1024 * 1024 * 3, // 3 MB
          fileName: 'voice_message.m4a',
        ),
      ),
      MockChatMessage(
        id: 'audio_2',
        chatId: 'chat_1',
        senderId: currentUserId,
        type: ChatMessageType.audio,
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
        status: ChatMessageStatus.delivered,
        senderData: sender1,
        mediaData: const ChatMediaData(
          url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
          mediaType: ChatMessageType.audio,
          duration: 45, // 0:45
          fileSize: 1024 * 512, // 512 KB
          fileName: 'audio_reply.m4a',
        ),
      ),
    ];

/// Sample video messages
List<MockChatMessage> get sampleVideoMessages => [
      MockChatMessage(
        id: 'video_1',
        chatId: 'chat_1',
        senderId: 'user_2',
        type: ChatMessageType.video,
        textContent: 'Amazing video from my trip!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
        status: ChatMessageStatus.read,
        senderData: sender2,
        mediaData: const ChatMediaData(
          url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
          thumbnailUrl: 'https://picsum.photos/400/300',
          mediaType: ChatMessageType.video,
          duration: 65, // 1:05
          fileSize: 1024 * 1024 * 15, // 15 MB
          fileName: 'trip_video.mp4',
          aspectRatio: 1.78,
        ),
      ),
      MockChatMessage(
        id: 'video_2',
        chatId: 'chat_1',
        senderId: currentUserId,
        type: ChatMessageType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        status: ChatMessageStatus.sent,
        senderData: sender1,
        mediaData: const ChatMediaData(
          url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4',
          thumbnailUrl: 'https://picsum.photos/300/400',
          mediaType: ChatMessageType.video,
          duration: 120, // 2:00
          fileSize: 1024 * 1024 * 25, // 25 MB
          fileName: 'my_video.mp4',
          aspectRatio: 0.75,
        ),
      ),
    ];

/// Sample document messages
List<MockChatMessage> get sampleDocumentMessages => [
      MockChatMessage(
        id: 'doc_1',
        chatId: 'chat_1',
        senderId: 'user_2',
        type: ChatMessageType.document,
        textContent: 'Here is the project proposal',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        status: ChatMessageStatus.read,
        senderData: sender2,
        mediaData: const ChatMediaData(
          url: 'https://example.com/proposal.pdf',
          mediaType: ChatMessageType.document,
          fileSize: 1024 * 1024 * 2, // 2 MB
          fileName: 'Project_Proposal_2024.pdf',
        ),
      ),
      MockChatMessage(
        id: 'doc_2',
        chatId: 'chat_1',
        senderId: currentUserId,
        type: ChatMessageType.document,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        status: ChatMessageStatus.delivered,
        senderData: sender1,
        mediaData: const ChatMediaData(
          url: 'https://example.com/spreadsheet.xlsx',
          mediaType: ChatMessageType.document,
          fileSize: 1024 * 500, // 500 KB
          fileName: 'Budget_2024.xlsx',
        ),
      ),
    ];

/// Sample contact message
MockChatMessage get sampleContactMessage => MockChatMessage(
      id: 'contact_1',
      chatId: 'chat_1',
      senderId: 'user_2',
      type: ChatMessageType.contact,
      textContent: 'Here is the contact you asked for',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: ChatMessageStatus.read,
      senderData: sender2,
      contactData: const ChatContactData(
        name: 'John Smith',
        phone: '+1 234 567 8900',
        email: 'john.smith@example.com',
        avatar: 'https://i.pravatar.cc/150?img=8',
      ),
    );

/// Sample location message
MockChatMessage get sampleLocationMessage => MockChatMessage(
      id: 'location_1',
      chatId: 'chat_1',
      senderId: currentUserId,
      type: ChatMessageType.location,
      textContent: 'Let\'s meet here!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
      status: ChatMessageStatus.read,
      senderData: sender1,
      locationData: const ChatLocationData(
        latitude: 25.2048,
        longitude: 55.2708,
        name: 'Burj Khalifa',
        address: '1 Sheikh Mohammed bin Rashid Blvd, Dubai, UAE',
      ),
    );

/// Sample poll message
MockChatMessage get samplePollMessage => MockChatMessage(
      id: 'poll_1',
      chatId: 'chat_1',
      senderId: 'user_3',
      type: ChatMessageType.poll,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: ChatMessageStatus.read,
      senderData: sender3,
      pollData: ChatPollData(
        question: 'What framework should we use for the new project?',
        options: const [
          ChatPollOption(
            id: 'opt_1',
            title: 'Flutter',
            votes: 15,
            voterIds: ['user_1', 'user_2'],
          ),
          ChatPollOption(
            id: 'opt_2',
            title: 'React Native',
            votes: 8,
            voterIds: ['user_3'],
          ),
          ChatPollOption(
            id: 'opt_3',
            title: 'Native (iOS + Android)',
            votes: 5,
            voterIds: [],
          ),
          ChatPollOption(
            id: 'opt_4',
            title: 'Kotlin Multiplatform',
            votes: 3,
            voterIds: [],
          ),
        ],
        isMultiple: false,
        isClosed: false,
        totalVotes: 31,
        isAnonymous: false,
        expiresAt: DateTime.now().add(const Duration(days: 2)),
      ),
    );

/// Sample deleted message
MockChatMessage get sampleDeletedMessage => MockChatMessage(
      id: 'deleted_1',
      chatId: 'chat_1',
      senderId: 'user_2',
      type: ChatMessageType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      status: ChatMessageStatus.read,
      senderData: sender2,
      isDeleted: true,
    );

/// Sample forwarded message
MockChatMessage get sampleForwardedMessage => MockChatMessage(
      id: 'forwarded_1',
      chatId: 'chat_1',
      senderId: currentUserId,
      type: ChatMessageType.text,
      textContent: 'This is a forwarded message from another chat!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
      status: ChatMessageStatus.read,
      senderData: sender1,
      isForwarded: true,
      forwardedFromId: 'original_msg_123',
    );

/// All sample messages combined and sorted by time
List<MockChatMessage> get allSampleMessages {
  final messages = <MockChatMessage>[
    ...sampleTextMessages,
    ...sampleImageMessages,
    ...sampleAudioMessages,
    ...sampleVideoMessages,
    ...sampleDocumentMessages,
    sampleContactMessage,
    sampleLocationMessage,
    samplePollMessage,
    sampleDeletedMessage,
    sampleForwardedMessage,
  ];

  // Sort by creation time (newest first)
  messages.sort((a, b) {
    final aTime = a.createdAt ?? DateTime.now();
    final bTime = b.createdAt ?? DateTime.now();
    return bTime.compareTo(aTime);
  });

  return messages;
}

/// Sample waveform data for audio visualization
List<double> get sampleWaveformData => [
      0.2, 0.4, 0.3, 0.6, 0.8, 0.5, 0.7, 0.9, 0.6, 0.4,
      0.5, 0.7, 0.8, 0.6, 0.3, 0.5, 0.7, 0.4, 0.6, 0.8,
      0.5, 0.3, 0.6, 0.9, 0.7, 0.4, 0.5, 0.8, 0.6, 0.3,
      0.4, 0.6, 0.5, 0.7, 0.8, 0.4, 0.5, 0.6, 0.3, 0.5,
    ];

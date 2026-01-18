# Chat Message UI

[![Pub Version](https://img.shields.io/badge/pub-v1.4.3-blue)](https://pub.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

A comprehensive, feature-rich Chat UI library for Flutter. Platform-agnostic interface supporting multiple data sources through adapters with modern design and smooth animations.

## Features

- 🎨 **Customizable Theming** - Full theme support with `ChatThemeData`
- 📱 **Rich Message Types** - Text, Images, Videos, Audio, Documents, Polls, Locations, Contacts
- ⚡ **Smart Pagination** - Efficient list rendering with `smart_pagination` integration
- 💬 **Interactive Features** - Reactions, swipe-to-reply, message selection
- 🔄 **Adapter Pattern** - Easily integrate with any data source
- 📦 **Cache-First Media** - TransferKit-based download and open flows
- 💡 **Tooltip Suggestions** - Anchored floating suggestions with `TooltipCard`
- 🎯 **Production Ready** - Battle-tested components

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  chat_message_ui:
    path: packages/chat_message_ui
```

## Quick Start

```dart
import 'package:chat_message_ui/chat_message_ui.dart';
```

### TransferKit Setup (Required for Media Downloads)

Initialize TransferKit once in your app startup to enable cache-first
media downloads used by the widgets:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TransferKitBridge.initialize(
    cacheEnabled: true,
    maxCacheSizeBytes: 1024 * 1024 * 1024, // 1 GB
  );

  runApp(const MyApp());
}
```

---

## Table of Contents

- [Data Adapters](#data-adapters)
- [Screens](#screens)
- [Widgets](#widgets)
- [Theme](#theme)
- [Utilities](#utilities)

---

## Data Adapters

### IChatMessageData

The core interface that all UI widgets consume. Implement this to connect your data source:

```dart
class MyMessageAdapter implements IChatMessageData {
  final MyMessage _message;
  
  MyMessageAdapter(this._message);
  
  @override
  String get id => _message.id;
  
  @override
  String get senderId => _message.senderId;
  
  @override
  ChatMessageType get type => ChatMessageType.text;
  
  @override
  String? get textContent => _message.text;
  
  @override
  DateTime? get createdAt => _message.timestamp;
  
  @override
  ChatMessageStatus get status => ChatMessageStatus.sent;
  
  @override
  ChatMediaData? get mediaData => null;
  
  @override
  List<ChatReactionData> get reactions => [];
  
  @override
  ChatReplyData? get replyData => null;
  
  @override
  String? get replyToId => null;
  
  @override
  ChatSenderData? get senderData => ChatSenderData(
    displayName: _message.senderName,
  );
  
  @override
  bool get isDeleted => false;

  @override
  bool get isStarred => _message.isStarred;

  @override
  bool get isSaved => _message.isSaved;

  @override
  ChatPollData? get pollData => null;
  
  @override
  ChatLocationData? get locationData => null;
  
  @override
  ChatContactData? get contactData => null;
}
```

### ChatMessageType

```dart
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
}
```

### Data Models

| Model | Description |
|-------|-------------|
| `ChatMediaData` | Media attachment data (url, thumbnail, size, duration) |
| `ChatReactionData` | Reaction data (emoji, userId) |
| `ChatReplyData` | Reply message data |
| `ChatSenderData` | Sender information |
| `ChatPollData` | Poll question and options |
| `ChatLocationData` | Location coordinates and name |
| `ChatContactData` | Contact information |

`ChatMediaData` supports attaching rich media details from TransferKit:

```dart
ChatMediaData(
  url: mediaUrl,
  mediaType: ChatMessageType.image,
  metadata: MediaMetadata(
    fileName: 'photo.jpg',
    fileSize: 1024 * 1024,
    aspectRatio: 1.33,
    thumbnail: ThumbnailData(base64: '...'),
  ),
);
```

You can also derive `thumbnail`, `waveform`, and other metadata using
TransferKit utilities before constructing `ChatMediaData`.

### IChatData

The interface for chat-level data. Implement this to provide comprehensive chat information:

```dart
class MyChatAdapter implements IChatData {
  final MyChat _chat;
  final ChatMemberCache _memberCache = ChatMemberCache();

  MyChatAdapter(this._chat);

  @override
  String get id => _chat.id;

  @override
  ChatType get type => _chat.isGroup ? ChatType.group : ChatType.individual;

  @override
  String get title => _chat.name;

  @override
  String? get subtitle => _chat.status;

  @override
  String? get imageUrl => _chat.avatarUrl;

  @override
  int? get memberCount => _chat.members.length;

  @override
  List<String> get participantIds => _chat.members.map((m) => m.id).toList();

  @override
  bool get isOnline => _chat.isOnline;

  @override
  List<String> get typingUserIds => _chat.typingUsers;

  @override
  int get unreadCount => _chat.unreadCount;

  @override
  String? get lastMessagePreview => _chat.lastMessage?.text;

  @override
  DateTime? get lastMessageAt => _chat.lastMessage?.createdAt;

  // Member data with caching
  @override
  Future<ChatSenderData?> getMemberData(String userId) async {
    // Check cache first
    final cached = _memberCache.get(userId);
    if (cached != null) return cached;

    // Fetch from API
    final user = await api.getUser(userId);
    if (user != null) {
      final data = ChatSenderData(
        id: user.id,
        name: user.name,
        imageUrl: user.avatar,
      );
      _memberCache.put(userId, data);
      return data;
    }
    return null;
  }

  @override
  ChatSenderData? getCachedMemberData(String userId) {
    return _memberCache.get(userId);
  }

  @override
  void clearMemberCache() => _memberCache.clear();

  // ... other overrides
}
```

### ChatType

```dart
enum ChatType {
  individual,  // 1:1 private chat
  group,       // Group chat with multiple members
  channel,     // Broadcast channel
  support,     // Support/Help chat
}
```

### IChatData Properties

| Section | Properties |
|---------|------------|
| **Identity** | `id`, `type`, `createdAt` |
| **Display** | `title`, `subtitle`, `description`, `imageUrl` |
| **Participants** | `memberCount`, `participantIds`, `creatorId`, `adminIds` |
| **Presence** | `isOnline`, `lastSeenAt`, `typingUserIds` |
| **State** | `isMuted`, `isPinned`, `isArchived`, `isBlocked` |
| **Messages** | `unreadCount`, `lastMessagePreview`, `lastMessageAt`, `lastReadMessageId` |

### IChatData Convenience Methods

```dart
// Check chat type
bool get isGroup => type == ChatType.group || type == ChatType.channel;
bool get isIndividual => type == ChatType.individual;

// Check status
bool get hasTypingUsers => typingUserIds.isNotEmpty;
bool get hasUnread => unreadCount > 0;

// Smart subtitle (typing > online > lastSeen > custom)
String? get displaySubtitle;
```

### ChatMemberCache

In-memory cache for efficient member data retrieval:

```dart
final cache = ChatMemberCache();

// Store member data
cache.put('user_123', ChatSenderData(id: 'user_123', name: 'John'));

// Retrieve member data
final member = cache.get('user_123');

// Check if cached
if (cache.contains('user_123')) {
  // Use cached data
}

// Clear cache
cache.clear();
```

### Using IChatData with ChatAppBar

```dart
// Create ChatAppBarData from IChatData
final appBarData = ChatAppBarData.fromChatData(chatData);

// Use in ChatScreen
ChatScreen(
  appBarData: appBarData,
  // ...
)

// Or create directly
ChatAppBar(
  chat: ChatAppBarData.fromChatData(chatData),
  onTitleTap: () => showChatInfo(),
)
```

---

## Screens

### ChatScreen

A complete chat screen with message list and input area:

```dart
ChatScreen(
  messagesCubit: mySmartPaginationCubit,
  currentUserId: 'user123',
  onSendMessage: (text) async {
    // Send message logic
  },
  onAttachmentSelected: (source) {
    // Handle attachment selection
  },
  onRecordingComplete: (path, duration, {waveform}) async {
    // Send audio message with waveform if available
  },
  onReactionTap: (message, emoji) {
    // Handle reaction
  },
  onForward: (messages) async {
    // Forward selected messages
  },
  onCopy: (messages, resolvedText) async {
    // Use resolvedText or override copy behavior
  },
  onPollVote: (message, optionId) {
    // Handle poll vote
  },
  onRefresh: () async {
    // Refresh messages
  },
  onDelete: (messages) {
    // Delete selected messages
  },
  pinnedMessages: pinnedList,
  onScrollToMessage: (messageId) async {
    // Scroll to the message and return true on success
    return true;
  },
  config: ChatMessageUiConfig(
    enableSuggestions: true,
    enableTextPreview: true,
    pagination: ChatPaginationConfig(
      listPadding: const EdgeInsets.all(16),
      messagesGroupingMode: MessagesGroupingMode.sameMinute,
      messagesGroupingTimeoutInSeconds: 300,
    ),
  ),
  showAvatar: true,
  appBar: AppBar(title: Text('Chat')),
)
```

### ChatScreen Selection Events

```dart
ChatScreen(
  messagesCubit: mySmartPaginationCubit,
  currentUserId: 'user123',
  onReply: (message) async {
    // Set reply message
  },
  onMessageInfo: (message) async {
    // Show message info
  },
  onSelectionChanged: (selected) {
    // Track selection state
  },
)
```

### ChatScreen Pinned Messages

```dart
ChatScreen(
  messagesCubit: mySmartPaginationCubit,
  currentUserId: 'user123',
  pinnedMessages: pinnedList,
  onScrollToMessage: (messageId) async {
    return await scrollToMessage(messageId);
  },
  pinnedMessagesBuilder: (context, message, index, total, onTap) {
    return PinnedMessagesBar(
      message: message,
      index: index,
      total: total,
      onTap: onTap,
    );
  },
)
```

### ChatScreen Input Events

```dart
ChatScreen(
  messagesCubit: mySmartPaginationCubit,
  currentUserId: 'user123',
  enableAttachments: true,
  enableAudioRecording: true,
  onPollRequested: () {
    // Open poll creation flow
  },
  usernameProvider: myMentionProvider,
  hashtagProvider: myHashtagProvider,
  quickReplyProvider: myQuickReplyProvider,
  taskProvider: myTaskProvider,
)
```

### ChatScreen App Bar (Optional)

```dart
ChatScreen(
  messagesCubit: mySmartPaginationCubit,
  currentUserId: 'user123',
  appBarData: ChatAppBarData(
    id: 'chat-1',
    title: 'Team Chat',
    subtitle: '5 members',
  ),
  onAppBarTitleTap: () {},
  onMenuSelection: (value) {},
  onSearch: () {},
)
```

### UI Configuration

Global defaults can be set via `ChatMessageUiConfig.instance`, with optional
per-screen overrides:

```dart
ChatMessageUiConfig.instance = ChatMessageUiConfig(
  enableSuggestions: true,
  enableTextPreview: true,
  autoDownload: ChatAutoDownloadConfig(
    image: AutoDownloadPolicy.never,
    video: AutoDownloadPolicy.never,
    audio: AutoDownloadPolicy.always,
    document: AutoDownloadPolicy.never,
  ),
);

ChatScreen(
  messagesCubit: mySmartPaginationCubit,
  currentUserId: 'user123',
  config: ChatMessageUiConfig.instance.copyWith(
    enableSuggestions: false,
    autoDownload: ChatMessageUiConfig.instance.autoDownload.copyWith(
      audio: AutoDownloadPolicy.never,
    ),
  ),
)
```

`AutoDownloadPolicy.wifiOnly` is available for future network-aware behavior.
Currently, only `always` triggers auto-start; `wifiOnly` behaves like manual
until the host app enforces connectivity constraints.

### ChatMessageSearchView

Search through chat messages:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChatMessageSearchView(
      messages: allMessages,
      currentUserId: 'user123',
      searchHintText: 'Search messages...',
      noResultsText: 'No messages found',
    ),
  ),
).then((selectedMessage) {
  if (selectedMessage != null) {
    // Scroll to selected message
  }
});
```

---

## Widgets

### Message Bubble

#### MessageBubble

The core component for displaying a single message:

```dart
MessageBubble(
  message: messageData,
  currentUserId: 'user123',
  showAvatar: true,
  messageGroupStatus: MessageGroupStatus.resolveGroupStatus(
    items: messages,
    index: index,
  ),
  onLongPress: () {
    // Handle long press
  },
  onReactionTap: (emoji) {
    // Handle reaction
  },
  onReplyTap: () {
    // Handle reply tap
  },
)
```

#### MessageContentBuilder

Automatically renders content based on message type:

```dart
MessageContentBuilder(
  message: messageData,
  isMyMessage: true,
)
```

---

### Chat List

#### ChatMessageList

Paginated message list with `SmartPaginationCubit`:

```dart
ChatMessageList(
  cubit: messagesCubit,
  scrollController: scrollController,
  currentUserId: 'user123',
  onRefresh: () async {
    await loadMessages();
  },
  showAvatar: true,
  selectedMessages: selectedSet,
  onMessageLongPress: (message) {
    // Enter selection mode
  },
  onReplyTap: (message) {
    // Handle reply navigation
  },
  onSwipeToReply: (message) {
    // Set reply message when user swipes
    _replyNotifier.value = ChatReplyData.fromMessage(message);
  },
  onReactionTap: (message, emoji) {
    // Add/remove reaction
  },
  focusedMessageId: highlightedMessageId,
  onSelectionChanged: () => setState(() {}),
  availableReactions: ['👍', '❤️', '😂', '😮', '😢', '😡'],
)
```

#### ChatDateSeparator

Date separator between messages:

```dart
ChatDateSeparator(
  date: messageDate,
  dateFormatter: (date, locale) => DateFormat.yMMMd(locale).format(date),
)
```

#### ChatInitialLoader

Loading indicator for initial load:

```dart
ChatInitialLoader(
  child: CustomLoadingWidget(), // Optional custom widget
)
```

#### ChatEmptyDisplay

Empty state display:

```dart
ChatEmptyDisplay(
  message: 'No messages yet',
  icon: Icons.chat_bubble_outline,
)
```

---

### App Bar

#### ChatAppBar

Customizable chat app bar:

```dart
ChatAppBar(
  chat: ChatAppBarData(
    id: 'chat123',
    title: 'Team Chat',
    subtitle: '5 members',
    imageUrl: 'https://example.com/avatar.jpg',
    memberCount: 5,
  ),
  onTitleTap: () {
    // Open chat info
  },
  onSearch: () {
    // Open search
  },
  onVideoCall: () {
    // Start video call
  },
  showSearch: true,
  showVideoCall: true,
  showMenu: true,
  menuItems: [
    PopupMenuItem(value: 'info', child: Text('Info')),
    PopupMenuItem(value: 'mute', child: Text('Mute')),
  ],
  onMenuSelection: (value) {
    // Handle menu selection
  },
)
```

#### ChatSelectionAppBar

App bar for message selection mode:

```dart
ChatSelectionAppBar(
  selectedCount: selectedMessages.length,
  selectedMessages: selectedMessages,
  currentUserId: 'user123',
  onClose: () {
    selectedMessages.clear();
    setState(() {});
  },
  onReply: (message) {
    // Reply to message
  },
  onCopy: () {
    // Copy selected messages
  },
  onDelete: (messages) {
    // Delete messages
  },
  onForward: (messages) {
    // Forward messages
  },
  deleteTimeRestrictionHours: 8,
)
```

---

### Media Widgets

#### ImageBubble

Display image messages:

```dart
ImageBubble(
  message: messageData,
  chatTheme: ChatThemeData.get(context),
  filePath: '/path/to/local/image.jpg', // Optional local file
  thumbnailFilePath: '/path/to/thumbnail.jpg', // Optional
  onTap: () {
    // Custom tap handler
  },
)
```

#### VideoBubble

Display video messages with player:

```dart
VideoBubble(
  message: messageData,
  chatTheme: ChatThemeData.get(context),
  isMyMessage: true,
  filePath: '/path/to/local/video.mp4', // Optional
  thumbnailFilePath: '/path/to/thumb.jpg', // Optional
  showMiniPlayer: true, // Show inline player with controls
  autoPlay: false,
  muted: false,
  onPlay: () {
    // Called when video starts playing
  },
  onPause: () {
    // Called when video is paused
  },
)
```

**Note:** When a video starts playing, all other audio and video playback
is automatically paused. This behavior is handled by `VideoPlayerFactory`
and `MediaPlaybackManager`.

#### VideoPlayerFactory

Centralized video playback management:

```dart
// Play a video (automatically pauses other media)
await VideoPlayerFactory.play(
  'video-123',
  filePath: '/path/to/video.mp4',
);

// Pause video
await VideoPlayerFactory.pause('video-123');

// Seek to position
await VideoPlayerFactory.seek('video-123', Duration(seconds: 30));

// Control volume
await VideoPlayerFactory.setVolume('video-123', 0.5);

// Listen to state changes
VideoPlayerFactory.stateStream.listen((state) {
  if (state.id == 'video-123') {
    print('Position: ${state.formattedPosition}');
    print('Is playing: ${state.isPlaying}');
  }
});

// Cleanup
await VideoPlayerFactory.dispose('video-123');
```

#### AudioBubble

Display audio messages with waveform:

```dart
AudioBubble(
  message: messageData,
  messageId: 'msg123',
  chatTheme: ChatThemeData.get(context),
  filePath: '/path/to/audio.m4a', // Optional
  waveform: [0.2, 0.5, 0.8, 0.3, ...], // Optional waveform data
  duration: 45, // Duration in seconds
)
```

#### DocumentBubble

Display document attachments:

```dart
DocumentBubble(
  message: messageData,
  chatTheme: ChatThemeData.get(context),
  onTap: () {
    // Open document
  },
)
```

---

### Interactive Widgets

#### Swipe-to-Reply

Enable swipe gestures on message bubbles to trigger reply:

```dart
// In ChatMessageList
ChatMessageList(
  cubit: messagesCubit,
  currentUserId: 'user123',
  onSwipeToReply: (message) {
    // Swipe right on received messages, left on sent messages
    _replyNotifier.value = ChatReplyData(
      id: message.id,
      senderId: message.senderId,
      senderName: message.senderData?.displayName,
      message: message.textContent,
      type: message.type,
    );
  },
)

// Or directly on MessageBubble
MessageBubble(
  message: message,
  currentUserId: 'user123',
  onSwipeToReply: () {
    // Handle swipe-to-reply
    setReplyMessage(message);
  },
)
```

**Features:**
- Swipe direction based on message ownership (right for received, left for sent)
- Reply icon indicator appears during swipe
- Smooth spring animation with haptic feedback
- Automatically disabled for deleted messages

---

#### PollBubble

Display interactive polls:

```dart
PollBubble(
  message: messageData,
  currentUserId: 'user123',
  chatTheme: ChatThemeData.get(context),
  onVote: (optionId) async {
    // Submit vote
  },
  onViewVotes: (option) {
    // Show vote details
  },
)
```

#### CreatePollScreen

WhatsApp-style screen for creating polls:

```dart
// Show as full page
final poll = await CreatePollScreen.showAsPage(
  context,
  onCreatePoll: (pollData) {
    // Handle poll creation
    print('Question: ${pollData.question}');
    print('Options: ${pollData.validOptions}');
    print('Multiple answers: ${pollData.allowMultipleAnswers}');
  },
  minOptions: 2,
  maxOptions: 12,
);

// Or show as bottom sheet
final poll = await CreatePollScreen.showAsBottomSheet(
  context,
  onCreatePoll: (pollData) {
    // Handle poll creation
  },
);

// Or use directly as a widget
CreatePollScreen(
  onCreatePoll: (pollData) {
    // Send poll message
    sendPollMessage(
      question: pollData.question,
      options: pollData.validOptions,
      allowMultiple: pollData.allowMultipleAnswers,
    );
  },
  title: 'Create poll',
  questionHint: 'Ask question',
  optionHint: '+ Add',
  multipleAnswersLabel: 'Allow multiple answers',
)
```

#### LocationBubble

Display location with map preview:

```dart
LocationBubble(
  message: messageData,
  chatTheme: ChatThemeData.get(context),
  onTap: () {
    // Open in maps app
  },
)
```

#### ContactBubble

Display contact card:

```dart
ContactBubble(
  message: messageData,
  chatTheme: ChatThemeData.get(context),
  onTap: () {
    // Open contact
  },
  onCall: () {
    // Call contact
  },
)
```

---

### Input Widgets

#### ChatInputWidget

Full-featured message input:

```dart
ChatInputWidget(
  onSendText: (text) async {
    // Send text message
  },
  onAttachmentSelected: (source) {
    // Handle: cameraImage, galleryImage, cameraVideo, 
    //         galleryVideo, location, document, contact, voting
  },
  onRecordingComplete: (path, duration) async {
    // Send voice message
  },
  controller: textController,
  focusNode: focusNode,
  replyMessage: replyNotifier,
  hintText: 'Type a message...',
  enableAttachments: true,
  enableAudioRecording: true,
)
```

#### AttachmentSource

Available attachment types:

```dart
enum AttachmentSource {
  cameraImage,
  galleryImage,
  cameraVideo,
  galleryVideo,
  location,
  document,
  contact,
  voting,
}
```

---

### Dialogs

#### CopyTextWidget

Copy message text with options:

```dart
showCopyTextBottomSheet(
  context,
  message,
  onCopyComplete: () {
    // Handle completion
  },
);
```

#### DeleteMessageDialog

Confirmation dialog for message deletion:

```dart
DeleteMessageDialog.show(
  context: context,
  message: messageData,
  onDeleteForEveryone: () {
    // Delete for all
  },
  onDeleteForMe: () {
    // Delete locally
  },
  deleteForEveryoneTimeLimit: 8, // hours
);
```

---

### Common Widgets

#### ReactionChip

Compact chip displaying an emoji reaction with count:

```dart
ReactionChip(
  emoji: '❤️',
  users: ['user1', 'user2', 'user3'],
  currentUserId: 'user1',
  chatTheme: ChatThemeData.get(context),
  onTap: (emoji) {
    // Toggle reaction
    toggleReaction(messageId, emoji);
  },
)
```

**Features:**
- Highlights when current user has reacted
- Shows count when multiple users reacted
- Customizable colors via `ChatReactionsTheme`
- Border indicator for active user reactions

**Theme Customization:**
```dart
ChatThemeData(
  reactions: ChatReactionsTheme(
    padding: 8.0,
    verticalPadding: 4.0,
    borderRadius: 12.0,
    emojiSize: 16.0,
    countSize: 12.0,
    activeBackgroundColor: Colors.blue.withOpacity(0.2),
    inactiveBackgroundColor: Colors.grey.shade200,
    activeTextColor: Colors.blue,
    inactiveTextColor: Colors.black87,
  ),
)
```

---

#### CompactReactionChip

WhatsApp-style compact reaction display combining all emojis with total count:

```dart
CompactReactionChip(
  groupedReactions: message.groupedReactions, // Map<String, List<String>>
  currentUserId: 'user1',
  chatTheme: ChatThemeData.get(context),
  onTap: () {
    // Show reaction details or picker
    showReactionDetails(message);
  },
)
```

**Features:**
- All emojis displayed in sequence: "👍❤️😂 5"
- Total count of all reactions
- Professional neutral background (grey tones)
- Subtle shadow for depth
- Dark/Light theme support
- Compact design that doesn't cover message content

**Example Output:**
- Single reaction: "👍 1"
- Multiple reactions: "👍❤️😂 5"

---

#### StatusIcon

Message delivery status indicator:

```dart
StatusIcon(
  status: ChatMessageStatus.delivered,
  chatTheme: ChatThemeData.get(context),
  primaryColor: Colors.blue, // Optional override
)
```

**Status Icons:**
| Status | Icon | Default Color |
|--------|------|---------------|
| `pending` | Clock | Grey |
| `sent` | Double check | Primary |
| `delivered` | Double check | Grey |
| `read` | Double check | Blue |
| `failed` | Error | Red |

**Theme Customization:**
```dart
ChatThemeData(
  status: ChatStatusTheme(
    iconSize: 16.0,
    sendingColor: Colors.grey,
    sentColor: Colors.blue,
    deliveredColor: Colors.grey,
    readColor: Colors.blue,
    errorColor: Colors.red,
  ),
)
```

---

#### Message Status Indicators

Messages automatically display visual indicators in the metadata area based on their status:

| Field | Icon | Description |
|-------|------|-------------|
| `isPinned` | 📌 Push Pin | Message is pinned in the chat |
| `isStarred` | ⭐ Star (amber) | Message is starred/favorited |
| `isSaved` | 🔖 Bookmark | Message is saved/bookmarked |

**Display Order:**
```
[edited] [timestamp] [📌] [⭐] [🔖] [✓✓ status]
```

**Example:**
```dart
// Message with all status indicators
class MyMessage implements IChatMessageData {
  @override
  bool get isPinned => true;  // Shows 📌

  @override
  bool get isStarred => true; // Shows ⭐

  @override
  bool get isSaved => true;   // Shows 🔖

  // ... other fields
}
```

---

#### FileUploadIndicator

Show file upload progress:

```dart
FileUploadIndicator(
  filePath: '/path/to/file.pdf',
  progressPercentage: 45.0,
  status: FileUploadStatus.uploading,
  onCancel: () {
    // Cancel upload
  },
  onRetry: () {
    // Retry upload
  },
)
```

#### FlowShader

Animated gradient shader effect:

```dart
FlowShader(
  duration: Duration(seconds: 2),
  direction: Axis.horizontal,
  flowColors: [Colors.white, Colors.grey],
  child: Text('Recording...'),
)
```

---

## Theme

### ChatThemeData

Customize the appearance:

```dart
ChatTheme(
  data: ChatThemeData(
    colors: ChatColorScheme(
      primary: Colors.blue,
      onPrimary: Colors.white,
      myMessageBubble: Colors.blue,
      otherMessageBubble: Colors.grey[200],
      // ... more colors
    ),
    typography: ChatTypography(
      messageText: TextStyle(fontSize: 16),
      timestamp: TextStyle(fontSize: 12),
      // ... more styles
    ),
    dimensions: ChatDimensions(
      bubbleBorderRadius: 16.0,
      avatarSize: 40.0,
      // ... more dimensions
    ),
  ),
  child: ChatScreen(...),
)
```

Access theme in widgets:

```dart
final chatTheme = ChatThemeData.get(context);
```

---

### Media Playback Management

#### MediaPlaybackManager

Centralized manager ensuring only one media plays at a time:

```dart
// Initialize the manager (call once at app startup)
MediaPlaybackManager.instance.initialize();

// Play audio (pauses any playing video)
await MediaPlaybackManager.instance.playAudio(
  'audio-123',
  filePath: '/path/to/audio.mp3',
);

// Play video (pauses any playing audio or other video)
await MediaPlaybackManager.instance.playVideo(
  'video-123',
  filePath: '/path/to/video.mp4',
);

// Pause all media
await MediaPlaybackManager.instance.pauseAll();

// Check current state
final state = MediaPlaybackManager.instance.state;
print('Current media type: ${state.type}'); // audio, video, or none
print('Is playing: ${state.isPlaying}');

// Listen to state changes
MediaPlaybackManager.instance.stateStream.listen((state) {
  print('Now playing: ${state.mediaId}');
});

// Cleanup
await MediaPlaybackManager.instance.dispose();
```

**Note:** `VideoPlayerFactory` and `AudioPlayerFactory` automatically
coordinate through this manager, so you typically don't need to use
`MediaPlaybackManager` directly unless you need custom playback logic.

#### MessageReactionBar

WhatsApp-style horizontal reaction bar for quick emoji selection:

```dart
MessageReactionBar(
  reactions: const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
  onReactionSelected: (emoji) {
    print('Selected: $emoji');
    addReaction(messageId, emoji);
  },
  onMorePressed: () async {
    // Show full emoji picker
    final emoji = await ReactionEmojiPicker.show(context);
    if (emoji != null) {
      addReaction(messageId, emoji);
    }
  },
  selectedReaction: currentUserReaction, // Highlight user's existing reaction
)
```

#### MessageContextMenu

Full context menu with reactions and actions for long-press on messages:

```dart
// Show context menu on long press
GestureDetector(
  onLongPressStart: (details) async {
    final result = await MessageContextMenu.show(
      context,
      position: details.globalPosition,
      reactions: ['❤️', '😂', '😮', '😢', '🙏', '👍'],
      actions: [
        MessageActionConfig.reply,
        MessageActionConfig.copy,
        MessageActionConfig.forward,
        MessageActionConfig.pin,
        MessageActionConfig.star,
        MessageActionConfig.delete,
      ],
    );

    if (result?.hasReaction == true) {
      addReaction(message.id, result!.reaction!);
    } else if (result?.hasAction == true) {
      handleAction(result!.action!, message);
    }
  },
  child: MessageBubble(message: message),
)
```

**WhatsApp-Style Focused Overlay:**

```dart
// Show focused overlay with centered message (WhatsApp/Telegram style)
final result = await MessageContextMenu.showWithFocusedOverlay(
  context,
  messageBuilder: (ctx) => MessageBubble(
    message: message,
    currentUserId: currentUserId,
  ),
  actions: [
    MessageActionConfig.reply,
    MessageActionConfig.copy,
    MessageActionConfig.forward,
    MessageActionConfig.pin,
    MessageActionConfig.star,
    MessageActionConfig.delete,
  ],
  reactions: ['❤️', '😂', '😮', '😢', '🙏', '👍'],
  showReactions: true,
  showActionLabels: true, // false for horizontal icons only
  isMyMessage: message.senderId == currentUserId,
  barrierColor: Colors.black.withOpacity(0.6),
);
```

**Available Actions:**

| Action | Icon | Description |
|--------|------|-------------|
| `reply` | ↩️ | Reply to message |
| `copy` | 📋 | Copy text content |
| `forward` | ➡️ | Forward message |
| `pin` / `unpin` | 📌 | Pin/Unpin message |
| `star` / `unstar` | ⭐ | Star/Unstar message |
| `edit` | ✏️ | Edit message |
| `delete` | 🗑️ | Delete message |
| `info` | ℹ️ | Message info |

**Display Modes:**

| Mode | `showActionLabels` | Description |
|------|-------------------|-------------|
| Vertical | `true` | List with icon + text labels |
| Horizontal | `false` | Compact row of icons only |

---

#### ChatSelectionAppBar

Enhanced selection app bar with pin, star, and forward actions:

```dart
ChatSelectionAppBar(
  selectedCount: selectedMessages.length,
  selectedMessages: selectedMessages,
  currentUserId: currentUserId,
  onClose: () => clearSelection(),
  onReply: (msg) => replyTo(msg),
  onCopy: () => copyToClipboard(),
  onPin: (msgs) => pinMessages(msgs),
  onUnpin: (msgs) => unpinMessages(msgs),
  onStar: (msgs) => starMessages(msgs),
  onForward: (msgs) => forwardMessages(msgs),
  onDelete: (msgs) => deleteMessages(msgs),
  areAllPinned: checkAllPinned(selectedMessages),
  areAllStarred: checkAllStarred(selectedMessages),
)
```

#### EditMessagePreview

Preview widget shown above input when editing a message:

```dart
if (editingMessage != null)
  EditMessagePreview(
    message: editingMessage,
    onCancel: () => setState(() => editingMessage = null),
  ),
ChatInput(
  initialText: editingMessage?.message,
  onSend: (text) {
    if (editingMessage != null) {
      updateMessage(editingMessage.id, text);
      setState(() => editingMessage = null);
    } else {
      sendMessage(text);
    }
  },
)
```

#### BubbleBuilders

Customize how different message types are rendered with custom builders:

```dart
// Define custom builders
final customBuilders = BubbleBuilders(
  // Custom image bubble
  imageBubbleBuilder: (context, builderContext, media) {
    return MyCustomImageBubble(
      imageUrl: media.url,
      isMyMessage: builderContext.isMyMessage,
      onTap: builderContext.onTap,
    );
  },

  // Custom audio bubble
  audioBubbleBuilder: (context, builderContext, media) {
    return MyCustomAudioPlayer(
      audioUrl: media.url,
      duration: media.duration,
    );
  },

  // Custom poll bubble
  pollBubbleBuilder: (context, builderContext, poll, onVote) {
    return MyCustomPollWidget(
      question: poll.question,
      options: poll.options,
      onVote: onVote,
    );
  },

  // Custom context menu
  contextMenuBuilder: (context, builderContext) async {
    return showMyCustomMenu(
      context,
      position: builderContext.position,
      message: builderContext.message,
    );
  },
);

// Use in MessageBubble
MessageBubble(
  message: message,
  currentUserId: userId,
  bubbleBuilders: customBuilders,
)
```

Available builders:
- `textBubbleBuilder` - Custom text message rendering
- `audioBubbleBuilder` - Custom audio player
- `imageBubbleBuilder` - Custom image display
- `videoBubbleBuilder` - Custom video player
- `pollBubbleBuilder` - Custom poll UI
- `locationBubbleBuilder` - Custom location display
- `contactBubbleBuilder` - Custom contact card
- `documentBubbleBuilder` - Custom document preview
- `contextMenuBuilder` - Custom long-press menu

---

## Utilities

### MessageGroupStatus

Determine message grouping for bubble styling:

```dart
final groupStatus = MessageGroupStatus.resolveGroupStatus(
  items: messages,
  index: currentIndex,
  messagesGroupingMode: MessagesGroupingMode.sameMinute,
  messagesGroupingTimeoutInSeconds: 300,
);

// Use in bubble
if (groupStatus?.isFirst == true) {
  // Show sender name
}
if (groupStatus?.isLast == true) {
  // Show timestamp
}
```

### Message Utils

Helper functions for parsing message data:

```dart
// Parse message type from string
final type = chatMessageTypeFromString('image');

// Extract data from content map
final text = extractMessageText(contentMap);
final url = extractMediaUrl(contentMap);
final thumbnail = extractThumbnailUrl(contentMap);
final duration = extractDuration(contentMap);
final fileSize = extractFileSize(contentMap);

// Format duration
final formatted = formatDuration(125); // "2:05"

// Format file size
final size = formatFileSize(1048576); // "1.0 MB"

// Group reactions
final grouped = groupReactions(reactions); // Map<emoji, List<userId>>
```

---

## Architecture

```
lib/
├── chat_message_ui.dart          # Main export
└── src/
    ├── adapters/                 # Data interfaces
    │   ├── chat_message_data.dart    # IChatMessageData interface
    │   └── chat_data_models.dart     # Data models
    ├── theme/                    # Theming
    │   └── chat_theme.dart           # ChatThemeData
    ├── screens/                  # Complete screens
    │   ├── chat_screen.dart          # Full chat screen
    │   └── chat_message_search_view.dart
    ├── widgets/                  # UI components
    │   ├── message_bubble.dart       # Message bubble
    │   ├── chat_message_list.dart    # Paginated list
    │   ├── appbar/                   # App bar widgets
    │   ├── dialogs/                  # Dialog widgets
    │   ├── input/                    # Input widgets
    │   ├── audio/                    # Audio player
    │   ├── video/                    # Video player
    │   ├── media/                    # Media playback manager
    │   ├── image/                    # Image viewer
    │   ├── poll/                     # Poll widgets
    │   ├── location/                 # Location widgets
    │   ├── contact/                  # Contact widgets
    │   ├── document/                 # Document widgets
    │   ├── reply/                    # Reply widgets
    │   └── common/                   # Shared widgets
    └── utils/                    # Utilities
        ├── messages_grouping.dart    # Message grouping
        └── message_utils.dart        # Parsing helpers
```

---

## Dependencies

```yaml
dependencies:
  flutter: sdk
  cached_network_image: any
  transfer_kit: any
  tooltip_card: any
  url_launcher: any
  intl: any
  lottie: any
  record: any
  just_audio: ^0.10.5
  chewie: any
  video_player: any
  smart_pagination: any
  flutter_animate: any
  font_awesome_flutter: any
  link_preview_generator: any
```

---

## Contributing

1. Update `IChatMessageData` if new data fields are needed
2. Implement fields in your adapters
3. Update `MessageContentBuilder` for new message types
4. Add new widgets to appropriate subdirectory
5. Export in `widgets.dart`
6. Update this README

---

## Complete Examples

### Basic Chat Implementation

```dart
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/smart_pagination.dart';

class ChatPage extends StatefulWidget {
  final IChatData chatData;

  const ChatPage({required this.chatData});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final SmartPaginationCubit<IChatMessageData> _messagesCubit;
  final _replyNotifier = ValueNotifier<ChatReplyData?>(null);

  @override
  void initState() {
    super.initState();
    _messagesCubit = SmartPaginationCubit();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      messagesCubit: _messagesCubit,
      currentUserId: 'current_user_id',
      appBarData: ChatAppBarData.fromChatData(widget.chatData),
      onSendMessage: _sendMessage,
      onAttachmentSelected: _handleAttachment,
      onRecordingComplete: _sendVoiceMessage,
      onReactionTap: _addReaction,
      replyMessage: _replyNotifier,
      onReply: (message) {
        _replyNotifier.value = ChatReplyData(
          id: message.id,
          senderId: message.senderId,
          senderName: message.senderData?.displayName,
          message: message.textContent,
          type: message.type,
        );
      },
    );
  }

  Future<void> _sendMessage(String text) async {
    final message = MyMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      senderId: 'current_user_id',
      status: ChatMessageStatus.pending,
      replyData: _replyNotifier.value,
    );

    // Insert immediately for instant UI
    _messagesCubit.insertEmit(message, index: 0);
    _replyNotifier.value = null;

    // Send to backend
    await api.sendMessage(message);

    // Update status
    final sentMessage = message.copyWith(status: ChatMessageStatus.sent);
    _messagesCubit.addOrUpdateEmit(sentMessage, index: 0);
  }
}
```

### Implementing IChatData with Real-Time Updates

```dart
class RealtimeChatData implements IChatData {
  final String _chatId;
  final ChatMemberCache _memberCache = ChatMemberCache();
  final ApiClient _api;

  // Observable state
  final _typingUsers = ValueNotifier<List<String>>([]);
  final _onlineStatus = ValueNotifier<bool>(false);

  RealtimeChatData(this._chatId, this._api) {
    // Listen to typing events
    _api.onTyping(_chatId).listen((userIds) {
      _typingUsers.value = userIds;
    });

    // Listen to presence updates
    _api.onPresence(_chatId).listen((isOnline) {
      _onlineStatus.value = isOnline;
    });
  }

  @override
  List<String> get typingUserIds => _typingUsers.value;

  @override
  bool get isOnline => _onlineStatus.value;

  @override
  String? get displaySubtitle {
    if (typingUserIds.isNotEmpty) {
      return typingUserIds.length == 1
          ? 'typing...'
          : '${typingUserIds.length} people typing...';
    }
    if (isOnline) return 'Online';
    return null;
  }

  @override
  Future<ChatSenderData?> getMemberData(String userId) async {
    if (_memberCache.contains(userId)) {
      return _memberCache.get(userId);
    }

    final user = await _api.getUser(userId);
    if (user != null) {
      final data = ChatSenderData(
        id: user.id,
        name: user.name,
        username: user.username,
        imageUrl: user.avatarUrl,
      );
      _memberCache.put(userId, data);
      return data;
    }
    return null;
  }

  // ... other implementations
}
```

### Custom Message Bubble with Member Lookup

```dart
class GroupMessageBubble extends StatelessWidget {
  final IChatMessageData message;
  final IChatData chatData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatSenderData?>(
      // First try cache, then fetch
      future: chatData.getMemberData(message.senderId),
      initialData: chatData.getCachedMemberData(message.senderId),
      builder: (context, snapshot) {
        final sender = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sender != null)
              Text(
                sender.displayName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            MessageBubble(
              message: message,
              currentUserId: currentUserId,
            ),
          ],
        );
      },
    );
  }
}
```

### File Picker Integration

```dart
Future<void> _handleAttachment(AttachmentSource source) async {
  switch (source) {
    case AttachmentSource.cameraImage:
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        await _sendImage(File(image.path));
      }
      break;

    case AttachmentSource.galleryImage:
      final images = await ImagePicker().pickMultiImage();
      for (final image in images) {
        await _sendImage(File(image.path));
      }
      break;

    case AttachmentSource.document:
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        await _sendDocument(File(file.path!), fileName: file.name);
      }
      break;

    case AttachmentSource.cameraVideo:
      final video = await ImagePicker().pickVideo(source: ImageSource.camera);
      if (video != null) {
        await _sendVideo(File(video.path));
      }
      break;

    // ... handle other cases
  }
}

Future<void> _sendImage(File file) async {
  // Generate thumbnail
  final thumbnail = await TransferKitUtils.generateThumbnail(file.path);

  final message = MyMessage(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    type: ChatMessageType.image,
    senderId: currentUserId,
    mediaData: ChatMediaData(
      localPath: file.path,
      mediaType: ChatMessageType.image,
      metadata: MediaMetadata(
        fileName: path.basename(file.path),
        thumbnail: thumbnail,
      ),
    ),
    status: ChatMessageStatus.pending,
  );

  _messagesCubit.insertEmit(message, index: 0);

  // Upload and get URL
  final url = await _api.uploadMedia(file);
  final uploadedMessage = message.copyWith(
    mediaData: message.mediaData?.copyWith(url: url),
    status: ChatMessageStatus.sent,
  );

  _messagesCubit.addOrUpdateEmit(uploadedMessage, index: 0);
}
```

### Video Bubble with Download Progress

```dart
VideoBubble(
  message: videoMessage,
  chatTheme: ChatThemeData.get(context),
  isMyMessage: videoMessage.senderId == currentUserId,
  // Shows download button when video not cached
  // Displays circular progress during download
  // Auto-plays after download completes
  onPlay: () {
    // Called when video starts playing
    analytics.trackVideoPlay(videoMessage.id);
  },
  onPause: () {
    // Called when video is paused
  },
)
```

### Poll Creation and Voting

```dart
// Create poll
final poll = await CreatePollScreen.showAsBottomSheet(
  context,
  onCreatePoll: (pollData) async {
    final message = MyMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: ChatMessageType.poll,
      senderId: currentUserId,
      pollData: ChatPollData(
        question: pollData.question,
        options: pollData.validOptions.map((text) =>
          ChatPollOption(id: uuid.v4(), text: text)
        ).toList(),
        isMultiple: pollData.allowMultipleAnswers,
      ),
      status: ChatMessageStatus.pending,
    );

    _messagesCubit.insertEmit(message, index: 0);
    await _api.sendMessage(message);
  },
);

// Handle vote
void _onPollVote(IChatMessageData message, String optionId) async {
  await _api.votePoll(message.id, optionId);
  // Update poll data in cubit
  final updatedPoll = message.pollData?.copyWith(
    options: message.pollData!.options.map((o) {
      if (o.id == optionId) {
        return o.copyWith(voterIds: [...o.voterIds, currentUserId]);
      }
      return o;
    }).toList(),
  );
  // ... update message in cubit
}
```

---

## License

MIT License - See [LICENSE](LICENSE) for details.

---

*Maintained by the Sama App Development Team*

# Chat Message UI

[![Pub Version](https://img.shields.io/badge/pub-v1.0.0-blue)](https://pub.dev)
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
  onReactionTap: (message, emoji) {
    // Handle reaction
  },
  onRefresh: () async {
    // Refresh messages
  },
  onDelete: (messages) {
    // Delete selected messages
  },
  config: ChatMessageUiConfig(
    enableSuggestions: true,
    enableTextPreview: true,
    pagination: ChatPaginationConfig(
      listPadding: const EdgeInsets.all(16),
    ),
  ),
  showAvatar: true,
  appBar: AppBar(title: Text('Chat')),
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
  filePath: '/path/to/local/video.mp4', // Optional
  thumbnailFilePath: '/path/to/thumb.jpg', // Optional
)
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

## License

MIT License - See [LICENSE](LICENSE) for details.

---

*Maintained by the Sama App Development Team*

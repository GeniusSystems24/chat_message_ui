# Chat Message UI

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Status](https://img.shields.io/badge/status-stable-green.svg)

A comprehensive, unified Chat UI library for the ClubApp ecosystem. This library provides a platform-agnostic interface for displaying and interacting with chat messages, supporting multiple data sources transparently through adapters.

## Features

*   **Unified Data Interface**: Uses `IChatMessageData` to abstract underlying data structures, allowing seamless switching between data sources.
*   **Rich Message Support**:
    *   Text handling with preview parsing (URLs, emails, phones).
    *   Media attachments (Images, Videos, Audio, Documents).
    *   Interactive specialized messages (Polls, Locations, Contacts).
*   **Modern UI/UX**:
    *   Customizable `ChatTheme` support.
    *   Swipe-to-reply.
    *   Reactions (Emoji).
    *   Message selection and batch operations.
    *   Date separators and grouping.
*   **Performance**:
    *   Optimized list rendering.
    *   Smart pagination support.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  chat_message_ui:
    path: ../packages/chat_message_ui
```

## Usage

### Basic Implementation

Import the library:

```dart
import 'package:chat_message_ui/chat_message_ui.dart';
```

### Using Adapters

Create your own adapters by implementing `IChatMessageData`:

```dart
class MyMessageAdapter implements IChatMessageData {
  final MyMessage _message;
  
  MyMessageAdapter(this._message);
  
  @override
  String get id => _message.id;
  
  @override
  ChatMessageType get type => ChatMessageType.text;
  
  // ... implement other required properties
}
```

### Widget Reference

#### ChatMessageBubble

The core component for displaying a single message:

```dart
ChatMessageBubble(
  message: messageData,       // IChatMessageData instance
  isMyMessage: true,          // Aligns right if true, left if false
  showAvatar: true,           // Whether to show sender avatar
  isFirstInGroup: true,       // Adjusts border radius
  isLastInGroup: true,        // Adjusts border radius
  currentUserId: 'user123',   // Used for reaction checks
  onLongPress: () { ... },    // Handle multiple selection/options
  onReplyTap: () { ... },     // Handle swipe-to-reply
)
```

#### MessageContentBuilder

Renders content based on `ChatMessageType`:

```dart
MessageContentBuilder(
  message: messageData,
  isMyMessage: true,
)
```

## Architecture

The library is structured using the Adapter pattern to separate UI from data logic.

### Folder Structure

*   **`adapters/`**: Core interfaces and data models.
    *   `IChatMessageData`: The abstract interface all UI widgets consume.
    *   `chat_data_models.dart`: Unified data models (`ChatMediaData`, `ChatPollData`, etc.).
*   **`widgets/`**: Reusable UI components.
    *   `MessageContentBuilder`: Renders the body of the message.
    *   `StatusIcon`: Displays sent/delivered/read status.
    *   Media widgets: Image, Video, Audio, Document bubbles.
*   **`theme/`**: Theming definitions (`ChatThemeData`).

## Contributing

When adding new message features:
1.  Update `IChatMessageData` interface if new data fields are needed.
2.  Implement the fields in your adapters.
3.  Update `MessageContentBuilder` or specific widgets to render the new data.

---
*Maintained by the Sama App Development Team.*

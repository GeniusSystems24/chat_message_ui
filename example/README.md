# Chat Message UI Example

A comprehensive example app demonstrating all features of the `chat_message_ui` Flutter package.

## Features

This example app showcases:

### Main Example Screens

| Screen | Path | Description |
|--------|------|-------------|
| **Basic Chat** | `/basic` | Minimal chat setup with ChatAppBar, ChatSelectionAppBar, and reply functionality |
| **Full Chat** | `/full` | Complete chat with all features including search, polls, and suggestion providers |
| **Firebase Live Chat** | `/firebase/:chatId` | Real-time Firebase integration with deep link support |
| **Message Types** | `/message-types` | All message types: text, image, video, audio, document, contact, location, poll |
| **Input Features** | `/input` | ChatInputWidget with suggestion providers, edit message preview, and attachments |
| **Reactions** | `/reactions` | MessageReactionBar, reaction picker, and ChatInputWidget for replies |
| **Theming** | `/theming` | Custom ChatThemeData, ChatAppBar theming, and multiple color schemes |

### New Feature Screens

| Screen | Path | Widget Demonstrated |
|--------|------|---------------------|
| **Polls** | `/features/poll` | `CreatePollScreen`, `PollBubble`, `PollVoteDetailsView` |
| **Edit Messages** | `/features/edit-message` | `EditMessagePreview`, `ChatEditData` |
| **File Upload** | `/features/file-upload` | `FileUploadIndicator`, `FileUploadStatus` |
| **Pinned & Search** | `/features/pinned-search` | `PinnedMessagesBar`, `SearchMatchesBar` |

### Bubble Screens

Individual demos for each message type:
- `/bubbles/text` - Text messages with formatting
- `/bubbles/image` - Image messages with thumbnails
- `/bubbles/video` - Video messages with playback
- `/bubbles/audio` - Audio messages with waveform
- `/bubbles/document` - Document/file messages
- `/bubbles/contact` - Contact card messages
- `/bubbles/location` - Location messages with maps
- `/bubbles/poll` - Poll messages with voting

## Navigation

This app uses **go_router** with **go_router_builder** for type-safe navigation.

### Type-Safe Route Usage

```dart
// Navigate to routes
context.go(const BasicChatRoute().location);
context.go(FirebaseChatRoute(chatId: 'abc123').location);
context.go(const PollFeatureRoute().location);

// Push routes
context.push(const MessageTypesRoute().location);
```

### Route Classes

All routes are defined in `lib/src/router/routes.dart`:

```dart
// Main routes
const HomeRoute()
const BasicChatRoute()
const FullChatRoute()
FirebaseChatRoute(chatId: 'your-chat-id')
const MessageTypesRoute()
const InputFeaturesRoute()
const ReactionsRoute()
const ThemingRoute()

// Feature routes
const PollFeatureRoute()
const EditMessageFeatureRoute()
const FileUploadFeatureRoute()
const PinnedSearchFeatureRoute()

// Bubble routes
const TextBubbleRoute()
const ImageBubbleRoute()
// ... and more
```

## Deep Links

The app supports deep linking with two schemes:

### Custom Scheme
```
chatui://host/basic
chatui://host/firebase/chat123
chatui://host/features/poll
```

### Web Links (Verified)
```
https://chatui.example.com/basic
https://chatui.example.com/firebase/chat123
https://chatui.example.com/features/poll
```

### Android Configuration

Deep links are configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="chatui" android:host="host" />
</intent-filter>

<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="chatui.example.com" />
</intent-filter>
```

### Testing Deep Links

```bash
# Android
adb shell am start -a android.intent.action.VIEW \
    -d "chatui://host/firebase/test-chat" \
    com.example.chat_message_ui_example

# iOS
xcrun simctl openurl booted "chatui://host/basic"
```

## Running the Example

```bash
# Get dependencies
flutter pub get

# Generate route files (after any route changes)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Testing

### Unit & Widget Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/screens/poll_example_test.dart

# Run with coverage
flutter test --coverage
```

### Integration Tests

```bash
# Run on connected device/emulator
flutter test integration_test/app_test.dart
```

### Test Structure

```
test/
├── test_utils.dart          # Mock classes, builders, helpers
├── router_test.dart         # Router configuration tests
└── screens/
    ├── basic_chat_test.dart
    ├── poll_example_test.dart
    ├── edit_message_example_test.dart
    ├── file_upload_example_test.dart
    └── pinned_search_example_test.dart

integration_test/
└── app_test.dart            # Full app navigation tests
```

## Dependencies

### Runtime
- `chat_message_ui` - The main chat UI package
- `go_router` - Navigation and routing
- `firebase_core`, `cloud_firestore`, `firebase_storage` - Firebase integration
- `smart_pagination` - Message list pagination

### Development
- `go_router_builder` - Type-safe route generation
- `build_runner` - Code generation
- `mocktail` - Mocking for tests
- `flutter_test` - Widget testing
- `integration_test` - Integration testing

## Key Widgets Demonstrated

### Chat Components
- `ChatListWidget` - Message list with pagination
- `ChatInputWidget` - Message input with attachments
- `ChatAppBar` - Custom app bar for chat screens
- `ChatSelectionAppBar` - App bar for selection mode

### Message Bubbles
- `MessageBubble` - Base bubble wrapper
- `TextBubble`, `ImageBubble`, `VideoBubble`, etc.
- `PollBubble` with `PollVoteDetailsView`

### Reactions & Actions
- `MessageReactionBar` - Reaction display
- `MessageActionsBottomSheet` - Message actions menu
- `ReactionPicker` - Emoji picker for reactions

### Search & Navigation
- `ChatMessageSearchView` - Search overlay
- `SearchMatchesBar` - Search results navigation
- `PinnedMessagesBar` - Pinned messages display

### Input Features
- `EditMessagePreview` - Edit mode preview
- `FileUploadIndicator` - Upload progress
- `SuggestionProvider` - Mentions and commands

### Polls
- `CreatePollScreen` - Poll creation UI
- `PollBubble` - Poll display and voting
- `PollVoteDetailsView` - Vote details sheet

## Contributing

When adding new features to the library:

1. Add a demo screen in `lib/src/screens/features/`
2. Export it in `lib/src/screens/features/features.dart`
3. Add a route in `lib/src/router/routes.dart`
4. Run `dart run build_runner build`
5. Add navigation in `home_screen.dart`
6. Write tests in `test/screens/`
7. Update this README

/// Chat Message UI Library
///
/// A comprehensive, unified Chat UI library for displaying and interacting
/// with chat messages. This library provides a platform-agnostic interface
/// supporting multiple data sources transparently through adapters.
///
/// ## Features
/// - Unified Data Interface via `IChatMessageData`
/// - Rich Message Support (Text, Media, Polls, Locations, Contacts)
/// - Customizable theming with `ChatThemeData`
/// - Message reactions and status indicators
/// - Swipe-to-reply support
///
/// ## Usage
///
/// ```dart
/// import 'package:chat_message_ui/chat_message_ui.dart';
///
/// // Create your own adapter by implementing IChatMessageData
/// class MyMessageAdapter implements IChatMessageData {
///   // ... implementation
/// }
///
/// // Use MessageBubble widget
/// MessageBubble(
///   message: myMessageAdapter,
///   currentUserId: 'user123',
///   showAvatar: true,
/// )
/// ```
library;

// Adapters - Core data interfaces and models
export 'src/adapters/adapters.dart';

// Theme - Styling configuration
export 'src/theme/theme.dart';

// Widgets - UI components
export 'src/widgets/widgets.dart';

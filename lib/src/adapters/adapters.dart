/// Chat Message Adapters Library
///
/// This library provides adapters for converting different message data sources
/// to a unified interface for UI consumption.
///
/// Usage:
/// ```dart
/// import 'package:chat_message_ui/adapters.dart';
///
/// // Create your own adapter by implementing IChatMessageData
/// class MyMessageAdapter implements IChatMessageData {
///   // ... implementation
/// }
///
/// // Use in widgets
/// Widget build(BuildContext context) {
///   return MessageBubble(message: adapter);
/// }
/// ```
library;

export 'chat_data_models.dart';
export 'chat_data.dart';
export 'chat_message_data.dart';

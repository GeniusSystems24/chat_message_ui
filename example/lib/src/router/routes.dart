import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/basic_chat_example.dart';
import '../screens/bubbles/bubbles.dart';
import '../screens/features/features.dart';
import '../screens/firebase_full_chat_example.dart';
import '../screens/full_chat_example.dart';
import '../screens/home_screen.dart';
import '../screens/input_features_example.dart';
import '../screens/message_types_example.dart';
import '../screens/reactions_example.dart';
import '../screens/theming_example.dart';

part 'routes.g.dart';

// ============================================================================
// Home Route
// ============================================================================

@TypedGoRoute<HomeRoute>(
  path: "/",
  routes: [
    // Main examples
    TypedGoRoute<BasicChatRoute>(path: 'basic'),
    TypedGoRoute<FullChatRoute>(path: 'full'),
    TypedGoRoute<FirebaseChatRoute>(path: 'firebase/:chatId'),
    TypedGoRoute<MessageTypesRoute>(path: 'message-types'),
    TypedGoRoute<InputFeaturesRoute>(path: 'input'),
    TypedGoRoute<ReactionsRoute>(path: 'reactions'),
    TypedGoRoute<ThemingRoute>(path: 'theming'),

    // Feature demos
    TypedGoRoute<AppBarFeatureRoute>(path: 'features/app-bar'),
    TypedGoRoute<ChatInputFeatureRoute>(path: 'features/chat-input'),
    TypedGoRoute<CustomBuildersFeatureRoute>(path: 'features/custom-builders'),
    TypedGoRoute<ReplyFeatureRoute>(path: 'features/reply'),
    TypedGoRoute<SearchFeatureRoute>(path: 'features/search'),
    TypedGoRoute<PollFeatureRoute>(path: 'features/poll'),
    TypedGoRoute<EditMessageFeatureRoute>(path: 'features/edit-message'),
    TypedGoRoute<FileUploadFeatureRoute>(path: 'features/file-upload'),
    TypedGoRoute<PinnedSearchFeatureRoute>(path: 'features/pinned-search'),
    TypedGoRoute<FocusedOverlayFeatureRoute>(path: 'features/focused-overlay'),

    // Bubble examples
    TypedGoRoute<TextBubbleRoute>(path: 'bubbles/text'),
    TypedGoRoute<ImageBubbleRoute>(path: 'bubbles/image'),
    TypedGoRoute<VideoBubbleRoute>(path: 'bubbles/video'),
    TypedGoRoute<AudioBubbleRoute>(path: 'bubbles/audio'),
    TypedGoRoute<DocumentBubbleRoute>(path: 'bubbles/document'),
    TypedGoRoute<ContactBubbleRoute>(path: 'bubbles/contact'),
    TypedGoRoute<LocationBubbleRoute>(path: 'bubbles/location'),
    TypedGoRoute<PollBubbleRoute>(path: 'bubbles/poll'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

// ============================================================================
// Main Example Routes
// ============================================================================

class BasicChatRoute extends GoRouteData with $BasicChatRoute {
  const BasicChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BasicChatExample();
  }
}

class FullChatRoute extends GoRouteData with $FullChatRoute {
  const FullChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FullChatExample();
  }
}

class FirebaseChatRoute extends GoRouteData with $FirebaseChatRoute {
  const FirebaseChatRoute({required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FirebaseFullChatExample(chatId: chatId);
  }
}

class MessageTypesRoute extends GoRouteData with $MessageTypesRoute {
  const MessageTypesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MessageTypesExample();
  }
}

class InputFeaturesRoute extends GoRouteData with $InputFeaturesRoute {
  const InputFeaturesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InputFeaturesExample();
  }
}

class ReactionsRoute extends GoRouteData with $ReactionsRoute {
  const ReactionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReactionsExample();
  }
}

class ThemingRoute extends GoRouteData with $ThemingRoute {
  const ThemingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ThemingExample();
  }
}

// ============================================================================
// Feature Routes
// ============================================================================

class AppBarFeatureRoute extends GoRouteData with $AppBarFeatureRoute {
  const AppBarFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppBarExample();
  }
}

class ChatInputFeatureRoute extends GoRouteData with $ChatInputFeatureRoute {
  const ChatInputFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatInputExample();
  }
}

class CustomBuildersFeatureRoute extends GoRouteData
    with $CustomBuildersFeatureRoute {
  const CustomBuildersFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomBuildersExample();
  }
}

class ReplyFeatureRoute extends GoRouteData with $ReplyFeatureRoute {
  const ReplyFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReplyExample();
  }
}

class SearchFeatureRoute extends GoRouteData with $SearchFeatureRoute {
  const SearchFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchExample();
  }
}

class PollFeatureRoute extends GoRouteData with $PollFeatureRoute {
  const PollFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PollExample();
  }
}

class EditMessageFeatureRoute extends GoRouteData
    with $EditMessageFeatureRoute {
  const EditMessageFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EditMessageExample();
  }
}

class FileUploadFeatureRoute extends GoRouteData with $FileUploadFeatureRoute {
  const FileUploadFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FileUploadExample();
  }
}

class PinnedSearchFeatureRoute extends GoRouteData
    with $PinnedSearchFeatureRoute {
  const PinnedSearchFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PinnedSearchExample();
  }
}

class FocusedOverlayFeatureRoute extends GoRouteData
    with $FocusedOverlayFeatureRoute {
  const FocusedOverlayFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FocusedOverlayExample();
  }
}

// ============================================================================
// Bubble Routes
// ============================================================================

class TextBubbleRoute extends GoRouteData with $TextBubbleRoute {
  const TextBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TextBubbleExample();
  }
}

class ImageBubbleRoute extends GoRouteData with $ImageBubbleRoute {
  const ImageBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ImageBubbleExample();
  }
}

class VideoBubbleRoute extends GoRouteData with $VideoBubbleRoute {
  const VideoBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VideoBubbleExample();
  }
}

class AudioBubbleRoute extends GoRouteData with $AudioBubbleRoute {
  const AudioBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AudioBubbleExample();
  }
}

class DocumentBubbleRoute extends GoRouteData with $DocumentBubbleRoute {
  const DocumentBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DocumentBubbleExample();
  }
}

class ContactBubbleRoute extends GoRouteData with $ContactBubbleRoute {
  const ContactBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ContactBubbleExample();
  }
}

class LocationBubbleRoute extends GoRouteData with $LocationBubbleRoute {
  const LocationBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LocationBubbleExample();
  }
}

class PollBubbleRoute extends GoRouteData with $PollBubbleRoute {
  const PollBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PollBubbleExample();
  }
}

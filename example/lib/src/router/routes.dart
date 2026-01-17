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

/// Route paths constants for type-safe navigation
abstract class RoutePaths {
  static const home = '/';
  static const basic = '/basic';
  static const full = '/full';
  static const firebase = '/firebase/:chatId';
  static const messageTypes = '/message-types';
  static const inputFeatures = '/input';
  static const reactions = '/reactions';
  static const theming = '/theming';

  // Features
  static const featuresAppBar = '/features/app-bar';
  static const featuresChatInput = '/features/chat-input';
  static const featuresCustomBuilders = '/features/custom-builders';
  static const featuresReply = '/features/reply';
  static const featuresSearch = '/features/search';
  static const featuresPoll = '/features/poll';
  static const featuresEditMessage = '/features/edit-message';
  static const featuresFileUpload = '/features/file-upload';
  static const featuresPinnedSearch = '/features/pinned-search';
  static const featuresFocusedOverlay = '/features/focused-overlay';

  // Bubbles
  static const bubblesText = '/bubbles/text';
  static const bubblesImage = '/bubbles/image';
  static const bubblesVideo = '/bubbles/video';
  static const bubblesAudio = '/bubbles/audio';
  static const bubblesDocument = '/bubbles/document';
  static const bubblesContact = '/bubbles/contact';
  static const bubblesLocation = '/bubbles/location';
  static const bubblesPoll = '/bubbles/poll';
}

// ============================================================================
// Home Route
// ============================================================================

@TypedGoRoute<HomeRoute>(path: '/')
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

@TypedGoRoute<BasicChatRoute>(path: '/basic')
class BasicChatRoute extends GoRouteData with $BasicChatRoute {
  const BasicChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BasicChatExample();
  }
}

@TypedGoRoute<FullChatRoute>(path: '/full')
class FullChatRoute extends GoRouteData with $FullChatRoute {
  const FullChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FullChatExample();
  }
}

@TypedGoRoute<FirebaseChatRoute>(path: '/firebase/:chatId')
class FirebaseChatRoute extends GoRouteData with $FirebaseChatRoute {
  const FirebaseChatRoute({required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FirebaseFullChatExample(chatId: chatId);
  }
}

@TypedGoRoute<MessageTypesRoute>(path: '/message-types')
class MessageTypesRoute extends GoRouteData with $MessageTypesRoute {
  const MessageTypesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MessageTypesExample();
  }
}

@TypedGoRoute<InputFeaturesRoute>(path: '/input')
class InputFeaturesRoute extends GoRouteData with $InputFeaturesRoute {
  const InputFeaturesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InputFeaturesExample();
  }
}

@TypedGoRoute<ReactionsRoute>(path: '/reactions')
class ReactionsRoute extends GoRouteData with $ReactionsRoute {
  const ReactionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReactionsExample();
  }
}

@TypedGoRoute<ThemingRoute>(path: '/theming')
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

@TypedGoRoute<AppBarFeatureRoute>(path: '/features/app-bar')
class AppBarFeatureRoute extends GoRouteData with $AppBarFeatureRoute {
  const AppBarFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppBarExample();
  }
}

@TypedGoRoute<ChatInputFeatureRoute>(path: '/features/chat-input')
class ChatInputFeatureRoute extends GoRouteData with $ChatInputFeatureRoute {
  const ChatInputFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatInputExample();
  }
}

@TypedGoRoute<CustomBuildersFeatureRoute>(path: '/features/custom-builders')
class CustomBuildersFeatureRoute extends GoRouteData with $CustomBuildersFeatureRoute {
  const CustomBuildersFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomBuildersExample();
  }
}

@TypedGoRoute<ReplyFeatureRoute>(path: '/features/reply')
class ReplyFeatureRoute extends GoRouteData with $ReplyFeatureRoute {
  const ReplyFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReplyExample();
  }
}

@TypedGoRoute<SearchFeatureRoute>(path: '/features/search')
class SearchFeatureRoute extends GoRouteData with $SearchFeatureRoute {
  const SearchFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchExample();
  }
}

@TypedGoRoute<PollFeatureRoute>(path: '/features/poll')
class PollFeatureRoute extends GoRouteData with $PollFeatureRoute {
  const PollFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PollExample();
  }
}

@TypedGoRoute<EditMessageFeatureRoute>(path: '/features/edit-message')
class EditMessageFeatureRoute extends GoRouteData with $EditMessageFeatureRoute {
  const EditMessageFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EditMessageExample();
  }
}

@TypedGoRoute<FileUploadFeatureRoute>(path: '/features/file-upload')
class FileUploadFeatureRoute extends GoRouteData with $FileUploadFeatureRoute {
  const FileUploadFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FileUploadExample();
  }
}

@TypedGoRoute<PinnedSearchFeatureRoute>(path: '/features/pinned-search')
class PinnedSearchFeatureRoute extends GoRouteData with $PinnedSearchFeatureRoute {
  const PinnedSearchFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PinnedSearchExample();
  }
}

@TypedGoRoute<FocusedOverlayFeatureRoute>(path: '/features/focused-overlay')
class FocusedOverlayFeatureRoute extends GoRouteData with $FocusedOverlayFeatureRoute {
  const FocusedOverlayFeatureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FocusedOverlayExample();
  }
}

// ============================================================================
// Bubble Routes
// ============================================================================

@TypedGoRoute<TextBubbleRoute>(path: '/bubbles/text')
class TextBubbleRoute extends GoRouteData with $TextBubbleRoute {
  const TextBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TextBubbleExample();
  }
}

@TypedGoRoute<ImageBubbleRoute>(path: '/bubbles/image')
class ImageBubbleRoute extends GoRouteData with $ImageBubbleRoute {
  const ImageBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ImageBubbleExample();
  }
}

@TypedGoRoute<VideoBubbleRoute>(path: '/bubbles/video')
class VideoBubbleRoute extends GoRouteData with $VideoBubbleRoute {
  const VideoBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VideoBubbleExample();
  }
}

@TypedGoRoute<AudioBubbleRoute>(path: '/bubbles/audio')
class AudioBubbleRoute extends GoRouteData with $AudioBubbleRoute {
  const AudioBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AudioBubbleExample();
  }
}

@TypedGoRoute<DocumentBubbleRoute>(path: '/bubbles/document')
class DocumentBubbleRoute extends GoRouteData with $DocumentBubbleRoute {
  const DocumentBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DocumentBubbleExample();
  }
}

@TypedGoRoute<ContactBubbleRoute>(path: '/bubbles/contact')
class ContactBubbleRoute extends GoRouteData with $ContactBubbleRoute {
  const ContactBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ContactBubbleExample();
  }
}

@TypedGoRoute<LocationBubbleRoute>(path: '/bubbles/location')
class LocationBubbleRoute extends GoRouteData with $LocationBubbleRoute {
  const LocationBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LocationBubbleExample();
  }
}

@TypedGoRoute<PollBubbleRoute>(path: '/bubbles/poll')
class PollBubbleRoute extends GoRouteData with $PollBubbleRoute {
  const PollBubbleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PollBubbleExample();
  }
}

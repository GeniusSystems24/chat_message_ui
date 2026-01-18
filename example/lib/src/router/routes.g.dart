// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  factory: $HomeRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'basic', factory: $BasicChatRoute._fromState),
    GoRouteData.$route(path: 'full', factory: $FullChatRoute._fromState),
    GoRouteData.$route(
      path: 'firebase/:chatId',
      factory: $FirebaseChatRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'message-types',
      factory: $MessageTypesRoute._fromState,
    ),
    GoRouteData.$route(path: 'input', factory: $InputFeaturesRoute._fromState),
    GoRouteData.$route(path: 'reactions', factory: $ReactionsRoute._fromState),
    GoRouteData.$route(path: 'theming', factory: $ThemingRoute._fromState),
    GoRouteData.$route(
      path: 'features/app-bar',
      factory: $AppBarFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/chat-input',
      factory: $ChatInputFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/custom-builders',
      factory: $CustomBuildersFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/reply',
      factory: $ReplyFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/search',
      factory: $SearchFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/poll',
      factory: $PollFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/edit-message',
      factory: $EditMessageFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/file-upload',
      factory: $FileUploadFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/pinned-search',
      factory: $PinnedSearchFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/focused-overlay',
      factory: $FocusedOverlayFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'features/status-indicators',
      factory: $StatusIndicatorsFeatureRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/text',
      factory: $TextBubbleRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/image',
      factory: $ImageBubbleRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/video',
      factory: $VideoBubbleRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/audio',
      factory: $AudioBubbleRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/document',
      factory: $DocumentBubbleRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/contact',
      factory: $ContactBubbleRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/location',
      factory: $LocationBubbleRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bubbles/poll',
      factory: $PollBubbleRoute._fromState,
    ),
  ],
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BasicChatRoute on GoRouteData {
  static BasicChatRoute _fromState(GoRouterState state) =>
      const BasicChatRoute();

  @override
  String get location => GoRouteData.$location('/basic');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FullChatRoute on GoRouteData {
  static FullChatRoute _fromState(GoRouterState state) => const FullChatRoute();

  @override
  String get location => GoRouteData.$location('/full');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FirebaseChatRoute on GoRouteData {
  static FirebaseChatRoute _fromState(GoRouterState state) =>
      FirebaseChatRoute(chatId: state.pathParameters['chatId']!);

  FirebaseChatRoute get _self => this as FirebaseChatRoute;

  @override
  String get location =>
      GoRouteData.$location('/firebase/${Uri.encodeComponent(_self.chatId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MessageTypesRoute on GoRouteData {
  static MessageTypesRoute _fromState(GoRouterState state) =>
      const MessageTypesRoute();

  @override
  String get location => GoRouteData.$location('/message-types');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $InputFeaturesRoute on GoRouteData {
  static InputFeaturesRoute _fromState(GoRouterState state) =>
      const InputFeaturesRoute();

  @override
  String get location => GoRouteData.$location('/input');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ReactionsRoute on GoRouteData {
  static ReactionsRoute _fromState(GoRouterState state) =>
      const ReactionsRoute();

  @override
  String get location => GoRouteData.$location('/reactions');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ThemingRoute on GoRouteData {
  static ThemingRoute _fromState(GoRouterState state) => const ThemingRoute();

  @override
  String get location => GoRouteData.$location('/theming');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AppBarFeatureRoute on GoRouteData {
  static AppBarFeatureRoute _fromState(GoRouterState state) =>
      const AppBarFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/app-bar');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChatInputFeatureRoute on GoRouteData {
  static ChatInputFeatureRoute _fromState(GoRouterState state) =>
      const ChatInputFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/chat-input');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomBuildersFeatureRoute on GoRouteData {
  static CustomBuildersFeatureRoute _fromState(GoRouterState state) =>
      const CustomBuildersFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/custom-builders');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ReplyFeatureRoute on GoRouteData {
  static ReplyFeatureRoute _fromState(GoRouterState state) =>
      const ReplyFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/reply');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SearchFeatureRoute on GoRouteData {
  static SearchFeatureRoute _fromState(GoRouterState state) =>
      const SearchFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/search');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PollFeatureRoute on GoRouteData {
  static PollFeatureRoute _fromState(GoRouterState state) =>
      const PollFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/poll');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EditMessageFeatureRoute on GoRouteData {
  static EditMessageFeatureRoute _fromState(GoRouterState state) =>
      const EditMessageFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/edit-message');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FileUploadFeatureRoute on GoRouteData {
  static FileUploadFeatureRoute _fromState(GoRouterState state) =>
      const FileUploadFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/file-upload');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PinnedSearchFeatureRoute on GoRouteData {
  static PinnedSearchFeatureRoute _fromState(GoRouterState state) =>
      const PinnedSearchFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/pinned-search');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FocusedOverlayFeatureRoute on GoRouteData {
  static FocusedOverlayFeatureRoute _fromState(GoRouterState state) =>
      const FocusedOverlayFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/focused-overlay');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StatusIndicatorsFeatureRoute on GoRouteData {
  static StatusIndicatorsFeatureRoute _fromState(GoRouterState state) =>
      const StatusIndicatorsFeatureRoute();

  @override
  String get location => GoRouteData.$location('/features/status-indicators');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TextBubbleRoute on GoRouteData {
  static TextBubbleRoute _fromState(GoRouterState state) =>
      const TextBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/text');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ImageBubbleRoute on GoRouteData {
  static ImageBubbleRoute _fromState(GoRouterState state) =>
      const ImageBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/image');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $VideoBubbleRoute on GoRouteData {
  static VideoBubbleRoute _fromState(GoRouterState state) =>
      const VideoBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/video');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AudioBubbleRoute on GoRouteData {
  static AudioBubbleRoute _fromState(GoRouterState state) =>
      const AudioBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/audio');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DocumentBubbleRoute on GoRouteData {
  static DocumentBubbleRoute _fromState(GoRouterState state) =>
      const DocumentBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/document');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ContactBubbleRoute on GoRouteData {
  static ContactBubbleRoute _fromState(GoRouterState state) =>
      const ContactBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/contact');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LocationBubbleRoute on GoRouteData {
  static LocationBubbleRoute _fromState(GoRouterState state) =>
      const LocationBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/location');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PollBubbleRoute on GoRouteData {
  static PollBubbleRoute _fromState(GoRouterState state) =>
      const PollBubbleRoute();

  @override
  String get location => GoRouteData.$location('/bubbles/poll');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

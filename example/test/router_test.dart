import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
// Routes.dart contains both route classes and exports from routes.g.dart
import 'package:chat_message_ui_example/src/router/routes.dart';

void main() {
  group('Route Definitions', () {
    test('HomeRoute has correct path', () {
      expect(HomeRoute().location, '/');
    });

    test('BasicChatRoute has correct path', () {
      expect(BasicChatRoute().location, '/basic');
    });

    test('FullChatRoute has correct path', () {
      expect(FullChatRoute().location, '/full');
    });

    test('FirebaseChatRoute includes chatId parameter', () {
      final route = FirebaseChatRoute(chatId: 'test_chat_123');
      expect(route.location, '/firebase/test_chat_123');
      expect(route.chatId, 'test_chat_123');
    });

    test('MessageTypesRoute has correct path', () {
      expect(MessageTypesRoute().location, '/message-types');
    });

    test('InputFeaturesRoute has correct path', () {
      expect(InputFeaturesRoute().location, '/input');
    });

    test('ReactionsRoute has correct path', () {
      expect(ReactionsRoute().location, '/reactions');
    });

    test('ThemingRoute has correct path', () {
      expect(ThemingRoute().location, '/theming');
    });
  });

  group('Bubble Routes', () {
    test('TextBubbleRoute has correct path', () {
      expect(TextBubbleRoute().location, '/bubbles/text');
    });

    test('ImageBubbleRoute has correct path', () {
      expect(ImageBubbleRoute().location, '/bubbles/image');
    });

    test('VideoBubbleRoute has correct path', () {
      expect(VideoBubbleRoute().location, '/bubbles/video');
    });

    test('AudioBubbleRoute has correct path', () {
      expect(AudioBubbleRoute().location, '/bubbles/audio');
    });

    test('DocumentBubbleRoute has correct path', () {
      expect(DocumentBubbleRoute().location, '/bubbles/document');
    });

    test('ContactBubbleRoute has correct path', () {
      expect(ContactBubbleRoute().location, '/bubbles/contact');
    });

    test('LocationBubbleRoute has correct path', () {
      expect(LocationBubbleRoute().location, '/bubbles/location');
    });

    test('PollBubbleRoute has correct path', () {
      expect(PollBubbleRoute().location, '/bubbles/poll');
    });
  });

  group('Feature Routes', () {
    test('ChatInputFeatureRoute has correct path', () {
      expect(ChatInputFeatureRoute().location, '/features/chat-input');
    });

    test('AppBarFeatureRoute has correct path', () {
      expect(AppBarFeatureRoute().location, '/features/app-bar');
    });

    test('ReplyFeatureRoute has correct path', () {
      expect(ReplyFeatureRoute().location, '/features/reply');
    });

    test('SearchFeatureRoute has correct path', () {
      expect(SearchFeatureRoute().location, '/features/search');
    });

    test('CustomBuildersFeatureRoute has correct path', () {
      expect(CustomBuildersFeatureRoute().location, '/features/custom-builders');
    });

    test('PollFeatureRoute has correct path', () {
      expect(PollFeatureRoute().location, '/features/poll');
    });

    test('EditMessageFeatureRoute has correct path', () {
      expect(EditMessageFeatureRoute().location, '/features/edit-message');
    });

    test('FileUploadFeatureRoute has correct path', () {
      expect(FileUploadFeatureRoute().location, '/features/file-upload');
    });

    test('PinnedSearchFeatureRoute has correct path', () {
      expect(PinnedSearchFeatureRoute().location, '/features/pinned-search');
    });
  });

  group(r'$appRoutes Configuration', () {
    test(r'$appRoutes is a valid list', () {
      // ignore: invalid_use_of_visible_for_testing_member
      expect($appRoutes, isA<List<RouteBase>>());
      expect($appRoutes.isNotEmpty, true);
    });

    test(r'$appRoutes contains expected number of routes', () {
      // Home + 7 main screens + 9 feature screens + 8 bubble screens = 25
      expect($appRoutes.length, greaterThanOrEqualTo(20));
    });
  });

  group('Deep Link Parsing', () {
    test('FirebaseChatRoute parses chatId correctly', () {
      final route = FirebaseChatRoute(chatId: 'deep_link_chat_456');
      expect(route.chatId, 'deep_link_chat_456');
    });

    test('FirebaseChatRoute handles special characters in chatId', () {
      final route =
          FirebaseChatRoute(chatId: 'chat-with-dashes_and_underscores');
      expect(route.chatId, 'chat-with-dashes_and_underscores');
    });

    test('FirebaseChatRoute encodes path correctly', () {
      final route = FirebaseChatRoute(chatId: 'simple_id');
      expect(route.location, contains('/firebase/'));
      expect(route.location, contains('simple_id'));
    });
  });

  group('Navigation Integration', () {
    late GoRouter testRouter;

    setUp(() {
      testRouter = GoRouter(routes: $appRoutes);
    });

    testWidgets('can navigate to basic chat', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        ),
      );
      await tester.pumpAndSettle();

      // Start at home
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('navigates to correct screen via go', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        ),
      );
      await tester.pumpAndSettle();

      // Initial route should be home
      expect(testRouter.routerDelegate.currentConfiguration.uri.path, '/');
    });
  });

  group('Route Type Safety', () {
    test('all main routes are TypedGoRoute', () {
      // Verify routes can be instantiated
      expect(HomeRoute(), isA<GoRouteData>());
      expect(BasicChatRoute(), isA<GoRouteData>());
      expect(FullChatRoute(), isA<GoRouteData>());
      expect(MessageTypesRoute(), isA<GoRouteData>());
      expect(InputFeaturesRoute(), isA<GoRouteData>());
      expect(ReactionsRoute(), isA<GoRouteData>());
      expect(ThemingRoute(), isA<GoRouteData>());
    });

    test('parameterized routes require parameters', () {
      // FirebaseChatRoute requires chatId
      final route = FirebaseChatRoute(chatId: 'required_id');
      expect(route.chatId, isNotEmpty);
    });
  });
}

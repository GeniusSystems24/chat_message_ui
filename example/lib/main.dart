import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:chat_message_ui_example/src/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

final goRouter = GoRouter(
  routes: $appRoutes,
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await TransferKitBridge.initialize(
    cacheEnabled: true,
  );
  await initializeDateFormatting();
  runApp(const ChatMessageUIExampleApp());
}

/// Example app demonstrating all features of the chat_message_ui package.
///
/// This app showcases:
/// - Different message types (text, image, video, audio, document, etc.)
/// - Theming and customization
/// - Message reactions and status
/// - Reply functionality
/// - Chat input with various features
/// - Polls, locations, and contacts
/// - Type-safe navigation with go_router
/// - Deep link support for Firebase chat
class ChatMessageUIExampleApp extends StatelessWidget {
  const ChatMessageUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat Message UI Example',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        extensions: [ChatThemeData.light()],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        extensions: [ChatThemeData.dark()],
      ),
      themeMode: ThemeMode.system,
    );
  }
}

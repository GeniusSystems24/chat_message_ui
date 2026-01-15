import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
class ChatMessageUIExampleApp extends StatelessWidget {
  const ChatMessageUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Message UI Example',
      debugShowCheckedModeBanner: false,
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
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import 'screens/chat_demo_screen.dart';
import 'screens/message_types_screen.dart';
import 'screens/audio_demo_screen.dart';
import 'screens/video_demo_screen.dart';
import 'screens/image_demo_screen.dart';
import 'screens/input_demo_screen.dart';
import 'screens/theme_demo_screen.dart';

void main() {
  runApp(const ChatMessageUiExampleApp());
}

/// Main example app showcasing all features of chat_message_ui library.
class ChatMessageUiExampleApp extends StatefulWidget {
  const ChatMessageUiExampleApp({super.key});

  @override
  State<ChatMessageUiExampleApp> createState() => _ChatMessageUiExampleAppState();
}

class _ChatMessageUiExampleAppState extends State<ChatMessageUiExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Message UI Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

/// Home screen with navigation to all demo screens.
class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Message UI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Chat Message UI Library',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'A comprehensive Flutter chat UI library with support for multiple message types, theming, and media playback.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Demo sections
          Text(
            'Demo Screens',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _DemoCard(
            icon: Icons.chat,
            title: 'Full Chat Screen',
            description: 'Complete chat interface with message list, input, and interactions.',
            color: Colors.blue,
            onTap: () => _navigateTo(context, const ChatDemoScreen()),
          ),

          _DemoCard(
            icon: Icons.message,
            title: 'Message Types',
            description: 'All supported message types: text, image, video, audio, poll, contact, location.',
            color: Colors.green,
            onTap: () => _navigateTo(context, const MessageTypesScreen()),
          ),

          _DemoCard(
            icon: Icons.audiotrack,
            title: 'Audio Features',
            description: 'AudioBubble widget, AudioPlayerFactory, waveform visualization.',
            color: Colors.orange,
            onTap: () => _navigateTo(context, const AudioDemoScreen()),
          ),

          _DemoCard(
            icon: Icons.videocam,
            title: 'Video Features',
            description: 'VideoBubble widget, VideoPlayerFactory, fullscreen player.',
            color: Colors.red,
            onTap: () => _navigateTo(context, const VideoDemoScreen()),
          ),

          _DemoCard(
            icon: Icons.image,
            title: 'Image Features',
            description: 'ImageBubble widget, fullscreen viewer with zoom and gestures.',
            color: Colors.purple,
            onTap: () => _navigateTo(context, const ImageDemoScreen()),
          ),

          _DemoCard(
            icon: Icons.keyboard,
            title: 'Input Widget',
            description: 'ChatInputWidget with voice recording, attachments, and suggestions.',
            color: Colors.teal,
            onTap: () => _navigateTo(context, const InputDemoScreen()),
          ),

          _DemoCard(
            icon: Icons.palette,
            title: 'Theming',
            description: 'Customize chat appearance with ChatThemeData.',
            color: Colors.pink,
            onTap: () => _navigateTo(context, const ThemeDemoScreen()),
          ),

          const SizedBox(height: 24),

          // Features list
          Text(
            'Key Features',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FeatureChip(label: 'Text Messages'),
              _FeatureChip(label: 'Image Messages'),
              _FeatureChip(label: 'Video Messages'),
              _FeatureChip(label: 'Audio Messages'),
              _FeatureChip(label: 'Voice Recording'),
              _FeatureChip(label: 'Waveform Display'),
              _FeatureChip(label: 'Documents'),
              _FeatureChip(label: 'Polls'),
              _FeatureChip(label: 'Contacts'),
              _FeatureChip(label: 'Locations'),
              _FeatureChip(label: 'Reactions'),
              _FeatureChip(label: 'Reply Messages'),
              _FeatureChip(label: 'Forwarded Messages'),
              _FeatureChip(label: 'Message Status'),
              _FeatureChip(label: 'Selection Mode'),
              _FeatureChip(label: 'Custom Themes'),
              _FeatureChip(label: 'RTL Support'),
              _FeatureChip(label: 'Pagination'),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

/// Demo card widget.
class _DemoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _DemoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature chip widget.
class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

import 'package:flutter/material.dart';

import 'basic_chat_example.dart';
import 'full_chat_example.dart';
import 'input_features_example.dart';
import 'message_types_example.dart';
import 'reactions_example.dart';
import 'theming_example.dart';

/// Home screen showcasing all available examples.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Message UI Showcase'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 24),

          // Quick start
          _buildSectionTitle(context, 'Quick Start'),
          const SizedBox(height: 12),
          _buildQuickStart(context),
          const SizedBox(height: 32),

          // Features grid
          _buildSectionTitle(context, 'Interactive Demos'),
          const SizedBox(height: 12),
          _buildExampleGrid(context),

          const SizedBox(height: 32),

          // Features list
          _buildSectionTitle(context, 'Key Capabilities'),
          const SizedBox(height: 12),
          _buildFeaturesList(context),

          const SizedBox(height: 32),

          // Footer
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_rounded,
                color: theme.colorScheme.onPrimary,
                size: 40,
              ),
              const SizedBox(width: 12),
              Text(
                'chat_message_ui',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Production-ready chat components for Flutter. Build full chat '
            'experiences or compose from fine-grained widgets with adapters, '
            'themes, and smart input.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(context, 'Flutter'),
              _buildTag(context, 'Chat UI'),
              _buildTag(context, 'Messages'),
              _buildTag(context, 'Customizable'),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildStat(context, 'v1.0.0'),
              _buildStat(context, 'Material 3'),
              _buildStat(context, 'Null-safe'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuickStart(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Use the ready-made `ChatScreen` or build with `MessageBubble`, '
            '`ChatInputWidget`, and `ChatMessageList`.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              'ChatScreen(\n'
              '  messagesCubit: cubit,\n'
              '  currentUserId: userId,\n'
              '  onSendMessage: sendText,\n'
              ');',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _ExampleCard(
          title: 'Basic Chat',
          description: 'Simple chat with text messages',
          icon: Icons.chat_outlined,
          color: Colors.blue,
          onTap: () => _navigateTo(context, const BasicChatExample()),
        ),
        _ExampleCard(
          title: 'Message Types',
          description: 'All supported message types',
          icon: Icons.category_outlined,
          color: Colors.green,
          onTap: () => _navigateTo(context, const MessageTypesExample()),
        ),
        _ExampleCard(
          title: 'Theming',
          description: 'Custom themes and styling',
          icon: Icons.palette_outlined,
          color: Colors.purple,
          onTap: () => _navigateTo(context, const ThemingExample()),
        ),
        _ExampleCard(
          title: 'Input Features',
          description: 'Chat input with all options',
          icon: Icons.keyboard_outlined,
          color: Colors.orange,
          onTap: () => _navigateTo(context, const InputFeaturesExample()),
        ),
        _ExampleCard(
          title: 'Reactions',
          description: 'Message reactions & status',
          icon: Icons.add_reaction_outlined,
          color: Colors.pink,
          onTap: () => _navigateTo(context, const ReactionsExample()),
        ),
        _ExampleCard(
          title: 'Full Chat',
          description: 'Complete chat experience',
          icon: Icons.forum_outlined,
          color: Colors.teal,
          onTap: () => _navigateTo(context, const FullChatExample()),
        ),
      ],
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final features = [
      _Feature(
        icon: Icons.extension_outlined,
        title: 'Unified Data Interface',
        description: 'Platform-agnostic via IChatMessageData adapter',
      ),
      _Feature(
        icon: Icons.image_outlined,
        title: 'Rich Message Support',
        description:
            'Text, Image, Video, Audio, Document, Poll, Location, Contact',
      ),
      _Feature(
        icon: Icons.color_lens_outlined,
        title: 'Customizable Theming',
        description: 'Full theme control with ChatThemeData',
      ),
      _Feature(
        icon: Icons.emoji_emotions_outlined,
        title: 'Reactions & Status',
        description: 'Emoji reactions plus delivery state indicators',
      ),
      _Feature(
        icon: Icons.reply_outlined,
        title: 'Replies & Selection',
        description: 'Reply previews, multi-select, and actions',
      ),
      _Feature(
        icon: Icons.search_outlined,
        title: 'Search View',
        description: 'Filter messages with ChatMessageSearchView',
      ),
      _Feature(
        icon: Icons.mic_outlined,
        title: 'Smart Input',
        description: 'Attachments, recording, suggestions, link previews',
      ),
      _Feature(
        icon: Icons.auto_awesome_outlined,
        title: 'Composable Widgets',
        description: 'Use ChatScreen or compose with smaller widgets',
      ),
    ];

    return Column(
      children: features.map((feature) {
        return _FeatureTile(feature: feature);
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'chat_message_ui v1.0.0',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A comprehensive chat UI library for Flutter',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.code,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'MIT License',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;

  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _FeatureTile extends StatelessWidget {
  final _Feature feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              feature.icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  feature.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

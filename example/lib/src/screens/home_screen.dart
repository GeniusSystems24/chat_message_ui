import 'package:flutter/material.dart';

import 'basic_chat_example.dart';
import 'full_chat_example.dart';
import 'input_features_example.dart';
import 'message_types_example.dart';
import 'reactions_example.dart';
import 'theming_example.dart';
import 'firebase_full_chat_example.dart';
import 'bubbles/bubbles.dart';
import 'features/features.dart';
import 'shared/example_scaffold.dart';

/// Home screen showcasing all available examples with modern design.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            stretch: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: _HeroHeader(),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const ExampleDescription(
                  title: 'Screen Overview',
                  icon: Icons.home_outlined,
                  lines: [
                    'Central hub for exploring all chat_message_ui examples.',
                    'Groups demos by bubbles, features, and full chat flows.',
                    'Use this screen to compare layouts and navigate quickly.',
                  ],
                ),
                const SizedBox(height: 24),
                // Quick Start Section
                _buildSectionTitle(context, 'Quick Start', Icons.rocket_launch_outlined),
                const SizedBox(height: 12),
                _QuickStartCard(),
                const SizedBox(height: 28),

                // Bubble Examples Section
                _buildSectionTitle(context, 'Message Bubbles', Icons.chat_bubble_outline),
                const SizedBox(height: 12),
                _BubblesGrid(),
                const SizedBox(height: 28),

                // Features Section
                _buildSectionTitle(context, 'Features', Icons.widgets_outlined),
                const SizedBox(height: 12),
                _FeaturesGrid(context),
                const SizedBox(height: 28),

                // Complete Examples Section
                _buildSectionTitle(context, 'Complete Examples', Icons.apps_outlined),
                const SizedBox(height: 12),
                _CompleteExamplesGrid(context),
                const SizedBox(height: 28),

                // Firebase Section
                _buildSectionTitle(context, 'Firebase Live', Icons.cloud_outlined),
                const SizedBox(height: 12),
                const _FirebaseExampleCard(),
                const SizedBox(height: 28),

                // Capabilities Section
                _buildSectionTitle(context, 'Key Capabilities', Icons.star_outline),
                const SizedBox(height: 12),
                _CapabilitiesList(),
                const SizedBox(height: 28),

                // Footer
                _Footer(),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
            theme.colorScheme.tertiary,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chat_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'chat_message_ui',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Production-ready chat UI components',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip('Flutter'),
                  _buildChip('Material 3'),
                  _buildChip('Null-safe'),
                  _buildChip('Customizable'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _QuickStartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.code,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Get Started',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: SelectableText(
              'ChatScreen(\n'
              '  messagesCubit: cubit,\n'
              '  currentUserId: userId,\n'
              '  onSendMessage: sendText,\n'
              ')',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubblesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bubbles = [
      _BubbleItem('Text', Icons.text_fields, Colors.blue, const TextBubbleExample()),
      _BubbleItem('Image', Icons.image_outlined, Colors.green, const ImageBubbleExample()),
      _BubbleItem('Video', Icons.videocam_outlined, Colors.red, const VideoBubbleExample()),
      _BubbleItem('Audio', Icons.audiotrack_outlined, Colors.orange, const AudioBubbleExample()),
      _BubbleItem('Document', Icons.description_outlined, Colors.indigo, const DocumentBubbleExample()),
      _BubbleItem('Contact', Icons.contact_phone_outlined, Colors.teal, const ContactBubbleExample()),
      _BubbleItem('Location', Icons.location_on_outlined, Colors.pink, const LocationBubbleExample()),
      _BubbleItem('Poll', Icons.poll_outlined, Colors.purple, const PollBubbleExample()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: bubbles.length,
      itemBuilder: (context, index) => _BubbleCard(bubble: bubbles[index]),
    );
  }
}

class _BubbleItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget screen;

  _BubbleItem(this.title, this.icon, this.color, this.screen);
}

class _BubbleCard extends StatelessWidget {
  final _BubbleItem bubble;

  const _BubbleCard({required this.bubble});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => bubble.screen),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bubble.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  bubble.icon,
                  color: bubble.color,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                bubble.title,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  final BuildContext context;

  const _FeaturesGrid(this.context);

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureItem('Chat Input', 'Text, attachments, voice', Icons.keyboard_outlined, Colors.blue, const ChatInputExample()),
      _FeatureItem('App Bar', 'Title, avatar, actions', Icons.web_asset_outlined, Colors.green, const AppBarExample()),
      _FeatureItem('Replies', 'Reply preview & context', Icons.reply_outlined, Colors.orange, const ReplyExample()),
      _FeatureItem('Search', 'Find messages', Icons.search_outlined, Colors.purple, const SearchExample()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) => _FeatureCard(feature: features[index]),
    );
  }
}

class _FeatureItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  _FeatureItem(this.title, this.subtitle, this.icon, this.color, this.screen);
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => feature.screen),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: feature.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  feature.icon,
                  color: feature.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      feature.subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompleteExamplesGrid extends StatelessWidget {
  final BuildContext context;

  const _CompleteExamplesGrid(this.context);

  @override
  Widget build(BuildContext context) {
    final examples = [
      _ExampleItem('Basic Chat', 'Simple text messaging', Icons.chat_outlined, Colors.blue, const BasicChatExample()),
      _ExampleItem('Message Types', 'All bubble types', Icons.category_outlined, Colors.green, const MessageTypesExample()),
      _ExampleItem('Theming', 'Custom themes', Icons.palette_outlined, Colors.purple, const ThemingExample()),
      _ExampleItem('Input Features', 'Advanced input', Icons.keyboard_outlined, Colors.orange, const InputFeaturesExample()),
      _ExampleItem('Reactions', 'Emoji reactions', Icons.add_reaction_outlined, Colors.pink, const ReactionsExample()),
      _ExampleItem('Full Chat', 'Complete experience', Icons.forum_outlined, Colors.teal, const FullChatExample()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: examples.length,
      itemBuilder: (context, index) => _ExampleCard(example: examples[index]),
    );
  }
}

class _FirebaseExampleCard extends StatelessWidget {
  const _FirebaseExampleCard();

  @override
  Widget build(BuildContext context) {
    final example = _ExampleItem(
      'Firebase Live Chat',
      'Realtime Firestore + Storage',
      Icons.cloud_outlined,
      Colors.indigo,
      const FirebaseFullChatExample(),
    );

    return SizedBox(
      height: 140,
      child: _ExampleCard(example: example),
    );
  }
}

class _ExampleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  _ExampleItem(this.title, this.subtitle, this.icon, this.color, this.screen);
}

class _ExampleCard extends StatelessWidget {
  final _ExampleItem example;

  const _ExampleCard({required this.example});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => example.screen),
        ),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: example.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  example.icon,
                  color: example.color,
                  size: 22,
                ),
              ),
              const Spacer(),
              Text(
                example.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                example.subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapabilitiesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final capabilities = [
      _Capability(Icons.extension_outlined, 'Platform-agnostic', 'IChatMessageData adapter interface'),
      _Capability(Icons.image_outlined, 'Rich Media', 'Text, Image, Video, Audio, Document, Poll, Location, Contact'),
      _Capability(Icons.color_lens_outlined, 'Theming', 'Full customization with ChatThemeData'),
      _Capability(Icons.emoji_emotions_outlined, 'Reactions', 'Emoji reactions and status indicators'),
      _Capability(Icons.reply_outlined, 'Replies', 'Reply preview and quoted messages'),
      _Capability(Icons.mic_outlined, 'Voice Input', 'Recording with waveform visualization'),
      _Capability(Icons.auto_awesome_outlined, 'Suggestions', '@mentions, #hashtags, /commands'),
      _Capability(Icons.search_outlined, 'Search', 'Message filtering and search'),
    ];

    return Column(
      children: capabilities.map((cap) => _CapabilityTile(capability: cap)).toList(),
    );
  }
}

class _Capability {
  final IconData icon;
  final String title;
  final String description;

  _Capability(this.icon, this.title, this.description);
}

class _CapabilityTile extends StatelessWidget {
  final _Capability capability;

  const _CapabilityTile({required this.capability});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              capability.icon,
              color: theme.colorScheme.onPrimaryContainer,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capability.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  capability.description,
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

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'chat_message_ui',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'A comprehensive chat UI library for Flutter',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterChip(Icons.code, 'MIT License'),
              const SizedBox(width: 12),
              _FooterChip(Icons.verified, 'v1.0.0'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FooterChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

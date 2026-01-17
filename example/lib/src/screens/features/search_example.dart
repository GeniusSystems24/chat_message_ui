import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_sample_data.dart';
import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing ChatMessageSearchView features.
class SearchExample extends StatefulWidget {
  const SearchExample({super.key});

  @override
  State<SearchExample> createState() => _SearchExampleState();
}

class _SearchExampleState extends State<SearchExample> {
  final _searchController = TextEditingController();
  List<ExampleMessage> _allMessages = [];
  List<ExampleMessage> _filteredMessages = [];
  String _filterType = 'all';
  String? _filterSender;

  @override
  void initState() {
    super.initState();
    _allMessages = _createSampleMessages();
    _filteredMessages = _allMessages;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMessages = _allMessages.where((msg) {
        // Text filter
        final matchesText = query.isEmpty ||
            (msg.textContent?.toLowerCase().contains(query) ?? false);

        // Type filter
        final matchesType =
            _filterType == 'all' || msg.type.name == _filterType;

        // Sender filter
        final matchesSender =
            _filterSender == null || msg.senderId == _filterSender;

        return matchesText && matchesType && matchesSender;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExampleScaffold(
      title: 'Message Search',
      subtitle: 'Search and filter messages',
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ExampleDescription(
              title: 'Screen Overview',
              icon: Icons.search_outlined,
              lines: [
                'Demonstrates client-side search and result highlighting.',
                'Shows how to filter messages as the user types.',
                'Useful template for wiring search to real data sources.',
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Overview Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const ExampleSectionHeader(
                  title: 'Overview',
                  description:
                      'Search through chat messages with real-time filtering',
                  icon: Icons.search_outlined,
                ),
                const SizedBox(height: 16),

                // Search Input Demo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Try searching:',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search messages...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_filteredMessages.length} of ${_allMessages.length} messages',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Filters
                      Row(
                        children: [
                          // Type Filter
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _filterType,
                              decoration: InputDecoration(
                                labelText: 'Type',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'all', child: Text('All')),
                                DropdownMenuItem(
                                    value: 'text', child: Text('Text')),
                                DropdownMenuItem(
                                    value: 'image', child: Text('Image')),
                                DropdownMenuItem(
                                    value: 'video', child: Text('Video')),
                                DropdownMenuItem(
                                    value: 'audio', child: Text('Audio')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _filterType = value);
                                  _applyFilters();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Sender Filter
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              value: _filterSender,
                              decoration: InputDecoration(
                                labelText: 'Sender',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem(
                                    value: null, child: Text('All')),
                                ...ExampleSampleData.users.entries.map(
                                  (e) => DropdownMenuItem(
                                    value: e.key,
                                    child: Text(e.value.displayName),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _filterSender = value);
                                _applyFilters();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Active Filters Display
          if (_filterType != 'all' || _filterSender != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_filterType != 'all')
                    Chip(
                      label: Text('Type: $_filterType'),
                      onDeleted: () {
                        setState(() => _filterType = 'all');
                        _applyFilters();
                      },
                    ),
                  if (_filterSender != null)
                    Chip(
                      label: Text(
                          'From: ${ExampleSampleData.users[_filterSender]?.displayName ?? "Unknown"}'),
                      onDeleted: () {
                        setState(() => _filterSender = null);
                        _applyFilters();
                      },
                    ),
                ],
              ),
            ),

          // Results List
          Expanded(
            child: _filteredMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredMessages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final message = _filteredMessages[index];
                      return _SearchResultItem(
                        message: message,
                        query: _searchController.text,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Navigate to message: ${message.id}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),

          // Properties Section
          _tipsBuild(theme, context),
        ],
      ),
    );
  }

  Container _tipsBuild(ThemeData theme, BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Implementation Tips',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildTip(
                context,
                icon: Icons.filter_list,
                text: 'Filter by message type ✓ Implemented',
              ),
              _buildTip(
                context,
                icon: Icons.person_search,
                text: 'Filter by sender ✓ Implemented',
              ),
              _buildTip(
                context,
                icon: Icons.highlight,
                text: 'Highlight matching text ✓ Implemented',
              ),
              _buildTip(
                context,
                icon: Icons.date_range,
                text: 'Add date range filtering (suggested)',
              ),
              _buildTip(
                context,
                icon: Icons.history,
                text: 'Save recent searches (suggested)',
              ),
              _buildTip(
                context,
                icon: Icons.bookmark,
                text: 'Search in starred/pinned only (suggested)',
              ),
            ],
          ),
        );
  }

  Widget _buildTip(BuildContext context,
      {required IconData icon, required String text}) {
    final theme = Theme.of(context);
    final isImplemented = text.contains('✓');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isImplemented ? Colors.green : theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isImplemented ? Colors.green : null,
                fontWeight: isImplemented ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ExampleMessage> _createSampleMessages() {
    final baseTime = DateTime.now().subtract(const Duration(hours: 5));
    return [
      ExampleMessage(
        id: 'search_1',
        chatId: 'demo',
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'Welcome to the Flutter chat app demo!',
        createdAt: baseTime,
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_2',
        chatId: 'demo',
        senderId: 'user_1',
        senderData: ExampleSampleData.users['user_1'],
        type: ChatMessageType.text,
        textContent: 'Thanks! The UI looks really clean and modern.',
        createdAt: baseTime.add(const Duration(minutes: 5)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_3',
        chatId: 'demo',
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.text,
        textContent: 'Have you tried the voice recording feature?',
        createdAt: baseTime.add(const Duration(minutes: 15)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_4',
        chatId: 'demo',
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent:
            'The attachment system supports images, videos, documents, and more.',
        createdAt: baseTime.add(const Duration(minutes: 25)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_5',
        chatId: 'demo',
        senderId: 'user_1',
        senderData: ExampleSampleData.users['user_1'],
        type: ChatMessageType.text,
        textContent:
            'I really like the reply feature, makes conversations easier to follow.',
        createdAt: baseTime.add(const Duration(minutes: 35)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_6',
        chatId: 'demo',
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.image,
        textContent: 'Check out this screenshot',
        createdAt: baseTime.add(const Duration(minutes: 45)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_7',
        chatId: 'demo',
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.video,
        textContent: 'Demo video of the app',
        createdAt: baseTime.add(const Duration(hours: 1)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_8',
        chatId: 'demo',
        senderId: 'user_1',
        senderData: ExampleSampleData.users['user_1'],
        type: ChatMessageType.audio,
        textContent: 'Voice message',
        createdAt: baseTime.add(const Duration(hours: 1, minutes: 15)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_9',
        chatId: 'demo',
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.text,
        textContent: 'The search feature is very powerful and fast!',
        createdAt: baseTime.add(const Duration(hours: 2)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'search_10',
        chatId: 'demo',
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'Yes, and you can filter by message type and sender too.',
        createdAt: baseTime.add(const Duration(hours: 2, minutes: 5)),
        status: ChatMessageStatus.read,
      ),
    ];
  }
}

/// Search result item widget
class _SearchResultItem extends StatelessWidget {
  final ExampleMessage message;
  final String query;
  final VoidCallback onTap;

  const _SearchResultItem({
    required this.message,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sender = message.senderData;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
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
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                backgroundImage: sender?.imageUrl != null
                    ? NetworkImage(sender!.imageUrl!)
                    : null,
                child: sender?.imageUrl == null
                    ? Icon(
                        Icons.person,
                        color: theme.colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          sender?.name ?? 'Unknown',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(message.createdAt ?? DateTime.now()),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildHighlightedText(
                      context,
                      message.textContent ?? '',
                      query,
                    ),
                  ],
                ),
              ),

              // Arrow
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
      BuildContext context, String text, String query) {
    final theme = Theme.of(context);

    if (query.isEmpty) {
      return Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final endIndex = startIndex + query.length;
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              backgroundColor: theme.colorScheme.primaryContainer,
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../../data/example_sample_data.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing PinnedMessagesBar and SearchMatchesBar.
///
/// Features demonstrated:
/// - PinnedMessagesBar with multiple pinned messages
/// - SearchMatchesBar with search and navigation
/// - Integration between the two bars
class PinnedSearchExample extends StatefulWidget {
  const PinnedSearchExample({super.key});

  @override
  State<PinnedSearchExample> createState() => _PinnedSearchExampleState();
}

class _PinnedSearchExampleState extends State<PinnedSearchExample> {
  // Pinned messages
  late List<ExampleMessage> _pinnedMessages;
  int _currentPinnedIndex = 0;

  // Search state
  bool _showSearchBar = false;
  String _searchQuery = '';
  List<String> _matchedIds = [];
  int _currentMatchIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // All messages for search demo
  late List<ExampleMessage> _allMessages;

  @override
  void initState() {
    super.initState();
    _initMessages();
  }

  void _initMessages() {
    _allMessages = [
      ExampleMessage(
        id: 'msg_1',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'Hey everyone! Welcome to the team meeting.',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'msg_2',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'Thanks for organizing this meeting!',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'msg_3',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.text,
        textContent:
            'The project deadline is next Friday. Please review the requirements.',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'msg_4',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'I have shared the design files in the meeting notes.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: ChatMessageStatus.read,
      ),
      ExampleMessage(
        id: 'msg_5',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'Great work on the meeting preparation!',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        status: ChatMessageStatus.delivered,
      ),
      ExampleMessage(
        id: 'msg_6',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.text,
        textContent: 'Let\'s schedule another meeting for next week.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: ChatMessageStatus.delivered,
      ),
    ];

    // First 3 messages are pinned
    _pinnedMessages = _allMessages.take(3).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Pinned & Search Bars',
      subtitle: 'PinnedMessagesBar & SearchMatchesBar',
      body: Column(
        children: [
          // Search Bar (shown when search is active)
          if (_showSearchBar)
            SearchMatchesBar(
              matchedMessageIds: _matchedIds,
              currentMatchIndex: _currentMatchIndex,
              isSearching: _isSearching,
              controller: _searchController,
              searchHint: 'Search messages...',
              onQueryChanged: _handleSearchQueryChanged,
              onPrevious: _matchedIds.isNotEmpty ? _goToPreviousMatch : null,
              onNext: _matchedIds.isNotEmpty ? _goToNextMatch : null,
              onClose: _closeSearch,
            ),

          // Pinned Messages Bar (shown when search is not active)
          if (!_showSearchBar && _pinnedMessages.isNotEmpty)
            PinnedMessagesBar(
              message: _pinnedMessages[_currentPinnedIndex],
              index: _currentPinnedIndex,
              total: _pinnedMessages.length,
              onTap: _cyclePinnedMessage,
            ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const ExampleDescription(
                  title: 'Screen Overview',
                  icon: Icons.push_pin_outlined,
                  lines: [
                    'PinnedMessagesBar: Navigate between pinned messages.',
                    'SearchMatchesBar: Search with prev/next navigation.',
                    'Both bars can work together in a chat screen.',
                    'Tap pinned bar to cycle, use search bar to find messages.',
                  ],
                ),
                const SizedBox(height: 16),

                // Toggle Buttons
                Row(
                  children: [
                    Expanded(
                      child: _ToggleButton(
                        icon: Icons.push_pin,
                        label: 'Pinned Bar',
                        isActive: !_showSearchBar,
                        onPressed: () => setState(() => _showSearchBar = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ToggleButton(
                        icon: Icons.search,
                        label: 'Search Bar',
                        isActive: _showSearchBar,
                        onPressed: () => setState(() => _showSearchBar = true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // PinnedMessagesBar Section
                const ExampleSectionHeader(
                  title: 'PinnedMessagesBar',
                  description: 'Displays pinned messages with navigation',
                  icon: Icons.push_pin_outlined,
                ),
                const SizedBox(height: 16),

                DemoContainer(
                  title: 'Pinned Messages (${_pinnedMessages.length} total)',
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Demo pinned bar
                      PinnedMessagesBar(
                        message: _pinnedMessages[_currentPinnedIndex],
                        index: _currentPinnedIndex,
                        total: _pinnedMessages.length,
                        onTap: _cyclePinnedMessage,
                      ),
                      const Divider(height: 1),
                      // Current pinned message preview
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: MessageBubble(
                          message: _pinnedMessages[_currentPinnedIndex],
                          currentUserId: ExampleSampleData.currentUserId,
                          showAvatar: true,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const PropertyShowcase(
                  property: 'message',
                  value: 'IChatMessageData (required)',
                  description: 'The pinned message to display',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'index',
                  value: 'int (required)',
                  description: 'Current index (0-based)',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'total',
                  value: 'int (required)',
                  description: 'Total number of pinned messages',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'onTap',
                  value: 'VoidCallback (required)',
                  description: 'Called when bar is tapped',
                ),

                const SizedBox(height: 24),

                // SearchMatchesBar Section
                const ExampleSectionHeader(
                  title: 'SearchMatchesBar',
                  description: 'Search with match navigation',
                  icon: Icons.search,
                ),
                const SizedBox(height: 16),

                DemoContainer(
                  title: 'Search Demo (try: "meeting")',
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SearchMatchesBar(
                        matchedMessageIds: _matchedIds,
                        currentMatchIndex: _currentMatchIndex,
                        isSearching: _isSearching,
                        searchHint: 'Search in messages...',
                        initialQuery: _searchQuery,
                        onQueryChanged: _handleSearchQueryChanged,
                        onPrevious:
                            _matchedIds.isNotEmpty ? _goToPreviousMatch : null,
                        onNext: _matchedIds.isNotEmpty ? _goToNextMatch : null,
                        onClose: _closeSearch,
                      ),
                      if (_matchedIds.isNotEmpty) ...[
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Match ${_currentMatchIndex + 1} of ${_matchedIds.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              MessageBubble(
                                message: _allMessages.firstWhere(
                                  (m) =>
                                      m.id == _matchedIds[_currentMatchIndex],
                                ),
                                currentUserId: ExampleSampleData.currentUserId,
                                showAvatar: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const PropertyShowcase(
                  property: 'matchedMessageIds',
                  value: 'List<String> (required)',
                  description: 'IDs of matched messages',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'currentMatchIndex',
                  value: 'int (required)',
                  description: 'Current match index (0-based)',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'isSearching',
                  value: 'bool',
                  description: 'Shows loading indicator',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'onQueryChanged',
                  value: 'ValueChanged<String>?',
                  description: 'Called when search text changes',
                ),
                const SizedBox(height: 8),
                const PropertyShowcase(
                  property: 'onPrevious / onNext',
                  value: 'VoidCallback?',
                  description: 'Navigation callbacks',
                ),

                const SizedBox(height: 24),

                // All Messages Section
                const ExampleSectionHeader(
                  title: 'All Messages',
                  description: 'Messages used in this demo',
                  icon: Icons.message_outlined,
                ),
                const SizedBox(height: 12),

                ..._allMessages.map((message) {
                  final isPinned = _pinnedMessages.contains(message);
                  final isMatch = _matchedIds.contains(message.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: isMatch
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: MessageBubble(
                            message: message,
                            currentUserId: ExampleSampleData.currentUserId,
                            showAvatar: true,
                          ),
                        ),
                        if (isPinned)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.push_pin,
                                size: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Code Example
                const CodeSnippet(
                  title: 'Usage Example',
                  code: '''
// In your chat screen
Column(
  children: [
    // Search bar (when active)
    if (isSearching)
      SearchMatchesBar(
        matchedMessageIds: matchedIds,
        currentMatchIndex: currentIndex,
        isSearching: isLoading,
        onQueryChanged: (query) async {
          final results = await searchMessages(query);
          setState(() => matchedIds = results);
        },
        onPrevious: () => setState(() {
          currentIndex = (currentIndex - 1) % matchedIds.length;
          scrollToMessage(matchedIds[currentIndex]);
        }),
        onNext: () => setState(() {
          currentIndex = (currentIndex + 1) % matchedIds.length;
          scrollToMessage(matchedIds[currentIndex]);
        }),
        onClose: () => setState(() => isSearching = false),
      )
    
    // Pinned bar (when not searching)
    else if (pinnedMessages.isNotEmpty)
      PinnedMessagesBar(
        message: pinnedMessages[pinnedIndex],
        index: pinnedIndex,
        total: pinnedMessages.length,
        onTap: () {
          scrollToMessage(pinnedMessages[pinnedIndex].id);
          setState(() {
            pinnedIndex = (pinnedIndex + 1) % pinnedMessages.length;
          });
        },
      ),
    
    // Messages list
    Expanded(child: messagesList),
  ],
)''',
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cyclePinnedMessage() {
    setState(() {
      _currentPinnedIndex = (_currentPinnedIndex + 1) % _pinnedMessages.length;
    });
    _showSnackBar(
      'Jumped to pinned message ${_currentPinnedIndex + 1} of ${_pinnedMessages.length}',
    );
  }

  void _handleSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchQuery != query) return; // Query changed, ignore

      final matches = <String>[];
      final lowerQuery = query.toLowerCase();

      if (lowerQuery.isNotEmpty) {
        for (final message in _allMessages) {
          final text = message.textContent?.toLowerCase() ?? '';
          if (text.contains(lowerQuery)) {
            matches.add(message.id);
          }
        }
      }

      setState(() {
        _matchedIds = matches;
        _currentMatchIndex = matches.isNotEmpty ? 0 : 0;
        _isSearching = false;
      });
    });
  }

  void _goToPreviousMatch() {
    if (_matchedIds.isEmpty) return;
    setState(() {
      _currentMatchIndex =
          (_currentMatchIndex - 1 + _matchedIds.length) % _matchedIds.length;
    });
  }

  void _goToNextMatch() {
    if (_matchedIds.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex + 1) % _matchedIds.length;
    });
  }

  void _closeSearch() {
    setState(() {
      _showSearchBar = false;
      _searchQuery = '';
      _matchedIds = [];
      _currentMatchIndex = 0;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}

/// Toggle button widget
class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _ToggleButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isActive
        ? FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
  }
}

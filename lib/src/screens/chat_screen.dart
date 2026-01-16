import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_pagination/pagination.dart';

import '../adapters/chat_message_data.dart';
import '../adapters/chat_data_models.dart';
import '../config/chat_message_ui_config.dart';
import '../widgets/widgets.dart';

/// Callback signature for backend search.
typedef OnBackendSearchCallback = Future<List<String>> Function(String query);

typedef PinnedMessagesBuilder = Widget Function(
  BuildContext context,
  IChatMessageData message,
  int index,
  int total,
  VoidCallback onTap,
);

/// A complete chat screen widget with message list and input area.
///
/// This widget provides a full chat experience with:
/// - Paginated message list using [SmartPaginationCubit]
/// - Message input area
/// - Pull-to-refresh support
/// - Scroll-to-bottom FAB
/// - Message selection mode
/// - Reply functionality
class ChatScreen extends StatefulWidget {
  /// The pagination cubit containing the messages.
  final SmartPaginationCubit<IChatMessageData> messagesCubit;

  /// Current user ID.
  final String currentUserId;

  /// Callback when a text message is sent.
  final Future<void> Function(String text)? onSendMessage;

  /// Callback when an attachment is selected.
  final Function(AttachmentSource type)? onAttachmentSelected;

  /// Callback when an attachment bubble is tapped.
  final ValueChanged<IChatMessageData>? onAttachmentTap;

  /// Callback when a reaction is added to a message.
  final Function(IChatMessageData message, String emoji)? onReactionTap;

  /// Callback when a poll option is selected.
  final Function(IChatMessageData message, String optionId)? onPollVote;

  /// Callback to refresh messages.
  final Future<void> Function()? onRefresh;

  /// Callback when a message is deleted.
  final Function(Set<IChatMessageData> messages)? onDelete;

  /// Callback when messages are forwarded.
  final FutureOr<void> Function(Set<IChatMessageData> messages)? onForward;

  /// Callback when messages are copied.
  final FutureOr<void> Function(
    Set<IChatMessageData> messages,
    String resolvedText,
  )? onCopy;

  /// Callback when reply is requested.
  final FutureOr<void> Function(IChatMessageData message)? onReply;

  /// Callback when message info is requested.
  final FutureOr<void> Function(IChatMessageData message)? onMessageInfo;

  /// Callback when selection changes.
  final ValueChanged<Set<IChatMessageData>>? onSelectionChanged;

  /// Delete time restriction for selection app bar.
  final int deleteTimeRestrictionHours;

  /// Whether to show avatars.
  final bool showAvatar;

  /// Custom app bar widget.
  final PreferredSizeWidget? appBar;

  /// Optional chat app bar data (enables ChatAppBar).
  final ChatAppBarData? appBarData;

  /// App bar title tap callback (ChatAppBar only).
  final VoidCallback? onAppBarTitleTap;

  /// App bar menu selection callback (ChatAppBar only).
  final ValueChanged<String>? onMenuSelection;

  /// Custom app bar menu items (ChatAppBar only).
  final List<PopupMenuItem<String>>? menuItems;

  /// App bar video call callback (ChatAppBar only).
  final VoidCallback? onVideoCall;

  /// App bar tasks callback (ChatAppBar only).
  final VoidCallback? onTasks;

  /// App bar search callback (ChatAppBar only).
  final VoidCallback? onSearch;

  /// Whether to show search action (ChatAppBar only).
  final bool showSearch;

  /// Backend search callback for finding messages not loaded locally.
  /// If provided, will be called when local search doesn't find matches
  /// or to search the full message history on the server.
  final OnBackendSearchCallback? onBackendSearch;

  /// Whether search mode is externally controlled.
  /// If true, use [searchModeNotifier] to control search state.
  final ValueNotifier<bool>? searchModeNotifier;

  /// Search hint text for the search bar.
  final String? searchHint;

  /// Minimum characters required before searching.
  final int searchMinCharacters;

  /// Debounce duration for search input.
  final Duration searchDebounce;

  /// Whether to show video call action (ChatAppBar only).
  final bool showVideoCall;

  /// Whether to show tasks action (ChatAppBar only).
  final bool showTasks;

  /// Whether to show menu action (ChatAppBar only).
  final bool showMenu;

  /// Custom app bar builder (called when not in selection mode).
  final PreferredSizeWidget Function(BuildContext context)? appBarBuilder;

  /// Custom selection app bar builder.
  final PreferredSizeWidget Function(
    BuildContext context,
    Set<IChatMessageData> selectedMessages,
    VoidCallback onClearSelection,
  )? selectionAppBarBuilder;

  /// Reply message notifier.
  final ValueNotifier<ChatReplyData?>? replyMessage;

  /// List of pinned messages (ordered by pin time).
  final List<IChatMessageData> pinnedMessages;

  /// Pinned messages builder (override default WhatsApp-style bar).
  final PinnedMessagesBuilder? pinnedMessagesBuilder;

  /// Callback to scroll to a specific message id.
  final Future<bool> Function(String messageId)? onScrollToMessage;

  /// Callback when audio recording completes.
  final Future<void> Function(
    String filePath,
    int durationInSeconds, {
    List<double>? waveform,
  })? onRecordingComplete;

  /// Callback when audio recording starts.
  final VoidCallback? onRecordingStart;

  /// Callback when audio recording is cancelled.
  final VoidCallback? onRecordingCancel;

  /// Callback when audio recording lock status changes.
  final ValueChanged<bool>? onRecordingLockedChanged;

  /// Recording path resolver.
  final String Function()? getRecordingPath;

  /// Attachment enable flag for input.
  final bool enableAttachments;

  /// Audio recording enable flag for input.
  final bool enableAudioRecording;

  /// Input hint text.
  final String hintText;

  /// Recording duration in seconds.
  final int recordingDuration;

  /// Username suggestions provider.
  final SuggestionDataProvider<ChatUserSuggestion>? usernameProvider;

  /// Hashtag suggestions provider.
  final SuggestionDataProvider<Hashtag>? hashtagProvider;

  /// Quick reply suggestions provider.
  final SuggestionDataProvider<QuickReply>? quickReplyProvider;

  /// Custom task suggestions provider.
  final SuggestionDataProvider<dynamic>? taskProvider;

  /// Callback when poll creation is requested.
  final VoidCallback? onPollRequested;

  /// Padding for the message list.
  final EdgeInsets listPadding;

  /// Empty state message.
  final String emptyMessage;

  /// Optional UI configuration override.
  final ChatMessageUiConfig? config;

  const ChatScreen({
    super.key,
    required this.messagesCubit,
    required this.currentUserId,
    this.onSendMessage,
    this.onAttachmentSelected,
    this.onAttachmentTap,
    this.onReactionTap,
    this.onPollVote,
    this.onRefresh,
    this.onDelete,
    this.onForward,
    this.onCopy,
    this.onReply,
    this.onMessageInfo,
    this.onSelectionChanged,
    this.deleteTimeRestrictionHours = 8,
    this.showAvatar = true,
    this.appBar,
    this.appBarData,
    this.onAppBarTitleTap,
    this.onMenuSelection,
    this.menuItems,
    this.onVideoCall,
    this.onTasks,
    this.onSearch,
    this.showSearch = true,
    this.onBackendSearch,
    this.searchModeNotifier,
    this.searchHint,
    this.searchMinCharacters = 2,
    this.searchDebounce = const Duration(milliseconds: 300),
    this.showVideoCall = false,
    this.showTasks = false,
    this.showMenu = true,
    this.appBarBuilder,
    this.selectionAppBarBuilder,
    this.replyMessage,
    this.pinnedMessages = const [],
    this.pinnedMessagesBuilder,
    this.onScrollToMessage,
    this.onRecordingComplete,
    this.onRecordingStart,
    this.onRecordingCancel,
    this.onRecordingLockedChanged,
    this.getRecordingPath,
    this.enableAttachments = true,
    this.enableAudioRecording = true,
    this.hintText = 'Message',
    this.recordingDuration = 0,
    this.usernameProvider,
    this.hashtagProvider,
    this.quickReplyProvider,
    this.taskProvider,
    this.onPollRequested,
    this.listPadding = const EdgeInsets.all(12),
    this.emptyMessage = 'No messages yet',
    this.config,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Set<IChatMessageData> _selectedMessages = {};
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isAtBottom = true;
  String? _focusedMessageId;
  int _pinnedIndex = 0;

  // Search state
  bool _isSearchMode = false;
  String _searchQuery = '';
  List<String> _matchedMessageIds = [];
  int _currentMatchIndex = 0;
  bool _isSearching = false;
  Timer? _searchDebounceTimer;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _syncPinnedIndex();

    // Listen to external search mode if provided
    widget.searchModeNotifier?.addListener(_onSearchModeChanged);
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pinnedMessages != widget.pinnedMessages) {
      _syncPinnedIndex();
    }
    // Update search mode listener
    if (oldWidget.searchModeNotifier != widget.searchModeNotifier) {
      oldWidget.searchModeNotifier?.removeListener(_onSearchModeChanged);
      widget.searchModeNotifier?.addListener(_onSearchModeChanged);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    widget.searchModeNotifier?.removeListener(_onSearchModeChanged);
    super.dispose();
  }

  void _onSearchModeChanged() {
    final isSearchMode = widget.searchModeNotifier?.value ?? false;
    if (isSearchMode != _isSearchMode) {
      setState(() {
        _isSearchMode = isSearchMode;
        if (!isSearchMode) {
          _clearSearch();
        } else {
          _searchFocusNode.requestFocus();
        }
      });
    }
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final offset = position.pixels;

    final atBottom = offset <= 100;
    if (atBottom != _isAtBottom) {
      setState(() => _isAtBottom = atBottom);
    }
  }

  void _scrollToBottom() {
    // Try using smart_pagination's jumpToIndex for instant scroll
    if (widget.messagesCubit.hasObserverController) {
      widget.messagesCubit.jumpToIndex(0);
      return;
    }
  }

  Future<void> _handleRefresh() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }
  }

  Future<void> _handleSendMessage(String text) async {
    if (widget.onSendMessage != null) {
      await widget.onSendMessage!(text);
      _scrollToBottom();
    }
  }

  void _handleMessageLongPress(IChatMessageData message) {
    setState(() {
      _selectedMessages.add(message);
    });
  }

  void _handleReplyTap(IChatMessageData message) {
    final replyId = message.replyData?.id ?? message.replyToId;
    if (replyId == null || replyId.isEmpty) return;

    setState(() => _focusedMessageId = replyId);
    _scrollToMessage(replyId);
    Future.delayed(
      const Duration(milliseconds: 800),
      () {
        if (mounted) {
          setState(() => _focusedMessageId = null);
        }
      },
    );
  }

  Future<bool> _scrollToMessage(String messageId) async {
    // Use custom callback if provided
    final canHandle = (await widget.onScrollToMessage?.call(messageId)) ?? true;

    if (!canHandle) return false;

    // Try animateFirstWhere first (requires observer controller)
    final result = await widget.messagesCubit.animateFirstWhere(
      (message) => message.id == messageId,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.3, // Position message 30% from top
    );

    return result;
  }

  void _clearSelection() {
    setState(() {
      _selectedMessages.clear();
    });
  }

  Future<void> _handleCopyMessages() async {
    if (_selectedMessages.isEmpty) return;
    final resolvedText = _buildCopyText(_selectedMessages);
    if (widget.onCopy != null) {
      await widget.onCopy!(_selectedMessages, resolvedText);
    } else {
      await Clipboard.setData(ClipboardData(text: resolvedText));
    }
    _clearSelection();
  }

  String _buildCopyText(Set<IChatMessageData> messages) {
    if (messages.length == 1) {
      return _resolveMessageText(messages.first);
    }
    final buffer = StringBuffer();
    for (final message in messages) {
      final sender = message.senderData?.displayName ?? message.senderId;
      buffer.writeln('$sender: ${_resolveMessageText(message)}');
    }
    return buffer.toString().trim();
  }

  String _resolveMessageText(IChatMessageData message) {
    final text = message.textContent?.trim();
    if (text != null && text.isNotEmpty) return text;
    final fileName = message.mediaData?.resolvedFileName;
    if (fileName != null && fileName.isNotEmpty) return fileName;
    return message.type.name;
  }

  Future<void> _handleForwardMessages() async {
    if (_selectedMessages.isEmpty || widget.onForward == null) return;
    await widget.onForward!(_selectedMessages);
    _clearSelection();
  }

  Future<void> _handleDeleteMessages() async {
    if (_selectedMessages.isEmpty || widget.onDelete == null) return;
    widget.onDelete!(_selectedMessages);
    _clearSelection();
  }

  IChatMessageData? get _currentPinnedMessage {
    if (widget.pinnedMessages.isEmpty) return null;
    final index = _pinnedIndex.clamp(0, widget.pinnedMessages.length - 1);
    return widget.pinnedMessages[index];
  }

  void _syncPinnedIndex() {
    if (widget.pinnedMessages.isEmpty) {
      _pinnedIndex = 0;
      return;
    }
    _pinnedIndex = widget.pinnedMessages.length - 1;
  }

  Future<void> _handlePinnedTap() async {
    final message = _currentPinnedMessage;
    if (message == null) return;
    final didScroll = await _scrollToMessage(message.id);
    if (!didScroll || !mounted) return;
    setState(() {
      _pinnedIndex = (_pinnedIndex + 1) % widget.pinnedMessages.length;
    });
  }

  // ============ Search Methods ============

  void _openSearch() {
    setState(() {
      _isSearchMode = true;
      _searchFocusNode.requestFocus();
    });
    widget.searchModeNotifier?.value = true;
  }

  void _closeSearch() {
    setState(() {
      _isSearchMode = false;
      _clearSearch();
    });
    widget.searchModeNotifier?.value = false;
  }

  void _clearSearch() {
    _searchQuery = '';
    _searchController.clear();
    _matchedMessageIds.clear();
    _currentMatchIndex = 0;
    _isSearching = false;
    _searchDebounceTimer?.cancel();
    _focusedMessageId = null;
  }

  void _onSearchQueryChanged(String query) {
    _searchDebounceTimer?.cancel();

    if (query.length < widget.searchMinCharacters) {
      setState(() {
        _searchQuery = query;
        _matchedMessageIds.clear();
        _currentMatchIndex = 0;
        _focusedMessageId = null;
      });
      return;
    }

    _searchDebounceTimer = Timer(widget.searchDebounce, () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (!mounted) return;

    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    // First, search locally in loaded messages
    final localMatches = _searchLocalMessages(query);

    // If onBackendSearch is provided, also search backend
    List<String> backendMatches = [];
    if (widget.onBackendSearch != null) {
      try {
        backendMatches = await widget.onBackendSearch!(query);
      } catch (e) {
        // Backend search failed, continue with local results
        debugPrint('Backend search error: $e');
      }
    }

    if (!mounted) return;

    // Combine results, prioritizing backend matches (they include full history)
    // Backend matches take priority as they're authoritative
    final allMatches =
        widget.onBackendSearch != null ? backendMatches : localMatches;

    setState(() {
      _matchedMessageIds = allMatches;
      _currentMatchIndex = 0;
      _isSearching = false;
    });

    // Navigate to first match if available
    if (_matchedMessageIds.isNotEmpty) {
      _navigateToCurrentMatch();
    }
  }

  List<String> _searchLocalMessages(String query) {
    final lowerQuery = query.toLowerCase();
    final matches = <String>[];

    for (final message in widget.messagesCubit.currentItems) {
      if (_messageMatchesQuery(message, lowerQuery)) {
        matches.add(message.id);
      }
    }

    // Return in order from newest to oldest (list is already in that order)
    return matches;
  }

  bool _messageMatchesQuery(IChatMessageData message, String lowerQuery) {
    // Search in text content
    final text = message.textContent?.toLowerCase();
    if (text != null && text.contains(lowerQuery)) {
      return true;
    }

    // Search in media file name
    final fileName = message.mediaData?.resolvedFileName?.toLowerCase();
    if (fileName != null && fileName.contains(lowerQuery)) {
      return true;
    }

    return false;
  }

  void _navigateToCurrentMatch() {
    if (_matchedMessageIds.isEmpty) return;
    if (_currentMatchIndex < 0 ||
        _currentMatchIndex >= _matchedMessageIds.length) {
      return;
    }

    final messageId = _matchedMessageIds[_currentMatchIndex];
    setState(() => _focusedMessageId = messageId);
    _scrollToMessage(messageId);

    // Clear focus highlight after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _focusedMessageId == messageId) {
        setState(() => _focusedMessageId = null);
      }
    });
  }

  void _goToPreviousMatch() {
    if (_matchedMessageIds.isEmpty || _currentMatchIndex <= 0) return;
    setState(() {
      _currentMatchIndex--;
    });
    _navigateToCurrentMatch();
  }

  void _goToNextMatch() {
    if (_matchedMessageIds.isEmpty ||
        _currentMatchIndex >= _matchedMessageIds.length - 1) {
      return;
    }
    setState(() {
      _currentMatchIndex++;
    });
    _navigateToCurrentMatch();
  }

  // ============ End Search Methods ============

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiConfig = widget.config ?? ChatMessageUiConfig.instance;
    final pinnedMessage = _currentPinnedMessage;
    final pinnedSection = widget.pinnedMessages.isEmpty || pinnedMessage == null
        ? null
        : (widget.pinnedMessagesBuilder?.call(
              context,
              pinnedMessage,
              _pinnedIndex,
              widget.pinnedMessages.length,
              _handlePinnedTap,
            ) ??
            PinnedMessagesBar(
              message: pinnedMessage,
              index: _pinnedIndex,
              total: widget.pinnedMessages.length,
              onTap: _handlePinnedTap,
            ));

    // Determine search query to pass to list (only if >= min characters)
    final activeSearchQuery =
        _searchQuery.length >= widget.searchMinCharacters ? _searchQuery : null;

    final content = Column(
      children: [
        // Show pinned section only when not in search mode
        if (!_isSearchMode && pinnedSection != null) pinnedSection,
        Expanded(
          child: ChatMessageList(
            cubit: widget.messagesCubit,
            scrollController: _scrollController,
            currentUserId: widget.currentUserId,
            onRefresh: _handleRefresh,
            showAvatar: widget.showAvatar,
            selectedMessages: _selectedMessages,
            onMessageLongPress: _handleMessageLongPress,
            onReplyTap: _handleReplyTap,
            onReactionTap: widget.onReactionTap,
            onAttachmentTap: widget.onAttachmentTap,
            onPollVote: widget.onPollVote,
            focusedMessageId: _focusedMessageId,
            searchQuery: activeSearchQuery,
            matchedMessageIds: _matchedMessageIds,
            currentMatchIndex: _currentMatchIndex,
            onSelectionChanged: () {
              setState(() {});
              widget.onSelectionChanged?.call(_selectedMessages);
            },
            padding: uiConfig.pagination.listPadding ?? widget.listPadding,
            availableReactions: uiConfig.pagination.availableReactions ??
                const ['👍', '❤️', '😂', '😮', '😢', '😡'],
            autoDownloadConfig: uiConfig.autoDownload,
            messagesGroupingMode: uiConfig.pagination.messagesGroupingMode,
            messagesGroupingTimeoutInSeconds:
                uiConfig.pagination.messagesGroupingTimeoutInSeconds,
            emptyBuilder: (context) => ChatEmptyDisplay(
              message: widget.emptyMessage,
            ),
          ),
        ),
        ChatInputWidget(
          onSendText: _handleSendMessage,
          onAttachmentSelected: widget.onAttachmentSelected,
          replyMessage: widget.replyMessage,
          controller: _textController,
          focusNode: _focusNode,
          enableFloatingSuggestions: uiConfig.enableSuggestions,
          enableTextDataPreview: uiConfig.enableTextPreview,
          inputDecoration: uiConfig.inputDecoration,
          onRecordingComplete: widget.onRecordingComplete,
          onRecordingStart: widget.onRecordingStart,
          onRecordingCancel: widget.onRecordingCancel,
          onRecordingLockedChanged: widget.onRecordingLockedChanged,
          getRecordingPath: widget.getRecordingPath,
          enableAttachments: widget.enableAttachments,
          enableAudioRecording: widget.enableAudioRecording,
          hintText: widget.hintText,
          recordingDuration: widget.recordingDuration,
          usernameProvider: widget.usernameProvider,
          hashtagProvider: widget.hashtagProvider,
          quickReplyProvider: widget.quickReplyProvider,
          taskProvider: widget.taskProvider,
          onPollRequested: widget.onPollRequested,
        ),
      ],
    );

    final body = uiConfig.bubbleTheme == null
        ? content
        : Theme(
            data: theme.copyWith(
              extensions: <ThemeExtension<dynamic>>[
                uiConfig.bubbleTheme!,
              ],
            ),
            child: content,
          );

    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: _isAtBottom
          ? null
          : Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: FloatingActionButton.small(
                backgroundColor: theme.floatingActionButtonTheme.backgroundColor
                        ?.withValues(alpha: 0.5) ??
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                onPressed: _scrollToBottom,
                child: const Icon(Icons.arrow_downward),
              ),
            ),
      body: body,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Show search bar as AppBar when in search mode
    if (_isSearchMode) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 6.0),
        child: SafeArea(
          child: SearchMatchesBar(
            matchedMessageIds: _matchedMessageIds,
            currentMatchIndex: _currentMatchIndex,
            isSearching: _isSearching,
            onPrevious: _goToPreviousMatch,
            onNext: _goToNextMatch,
            onClose: _closeSearch,
            onQueryChanged: _onSearchQueryChanged,
            searchHint: widget.searchHint,
            controller: _searchController,
            focusNode: _searchFocusNode,
          ),
        ),
      );
    }

    if (_selectedMessages.isNotEmpty) {
      if (widget.selectionAppBarBuilder != null) {
        return widget.selectionAppBarBuilder!(
          context,
          _selectedMessages,
          _clearSelection,
        );
      }
      return _buildDefaultSelectionAppBar(context);
    }

    if (widget.appBar != null) return widget.appBar!;
    if (widget.appBarBuilder != null) return widget.appBarBuilder!(context);
    if (widget.appBarData != null) {
      return ChatAppBar(
        chat: widget.appBarData!,
        onTitleTap: widget.onAppBarTitleTap,
        onMenuSelection: widget.onMenuSelection,
        onVideoCall: widget.onVideoCall,
        onTasks: widget.onTasks,
        onSearch: widget.onSearch ?? _openSearch,
        showSearch: widget.showSearch,
        showVideoCall: widget.showVideoCall,
        showTasks: widget.showTasks,
        showMenu: widget.showMenu,
        menuItems: widget.menuItems,
      );
    }

    return AppBar(title: const Text('Chat'));
  }

  PreferredSizeWidget _buildDefaultSelectionAppBar(BuildContext context) {
    return ChatSelectionAppBar(
      selectedCount: _selectedMessages.length,
      selectedMessages: _selectedMessages,
      currentUserId: widget.currentUserId,
      onClose: _clearSelection,
      deleteTimeRestrictionHours: widget.deleteTimeRestrictionHours,
      onReply: widget.onReply != null
          ? (message) async {
              await widget.onReply!(message);
              _clearSelection();
            }
          : null,
      onCopy: _handleCopyMessages,
      onInfo: widget.onMessageInfo != null
          ? (message) async => widget.onMessageInfo!(message)
          : null,
      onDelete: widget.onDelete != null ? (_) => _handleDeleteMessages() : null,
      onForward:
          widget.onForward != null ? (_) => _handleForwardMessages() : null,
    );
  }
}

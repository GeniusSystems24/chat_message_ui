import 'package:flutter/material.dart';
import 'package:smart_pagination/pagination.dart';

import '../adapters/chat_message_data.dart';
import '../adapters/chat_data_models.dart';
import '../config/chat_message_ui_config.dart';
import '../widgets/widgets.dart';

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

  /// Callback when a reaction is added to a message.
  final Function(IChatMessageData message, String emoji)? onReactionTap;

  /// Callback to refresh messages.
  final Future<void> Function()? onRefresh;

  /// Callback when a message is deleted.
  final Function(Set<IChatMessageData> messages)? onDelete;

  /// Whether to show avatars.
  final bool showAvatar;

  /// Custom app bar widget.
  final PreferredSizeWidget? appBar;

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
    this.onReactionTap,
    this.onRefresh,
    this.onDelete,
    this.showAvatar = true,
    this.appBar,
    this.appBarBuilder,
    this.selectionAppBarBuilder,
    this.replyMessage,
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
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

  Future<void> _scrollToMessage(String messageId) async {
    // This would require finding the index of the message and scrolling to it
    // For now, this is a placeholder - the implementation depends on how
    // the cubit exposes its items
  }

  void _clearSelection() {
    setState(() {
      _selectedMessages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiConfig = widget.config ?? ChatMessageUiConfig.instance;

    final content = Column(
      children: [
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
            focusedMessageId: _focusedMessageId,
            onSelectionChanged: () => setState(() {}),
            padding: uiConfig.pagination.listPadding ?? widget.listPadding,
            availableReactions: uiConfig.pagination.availableReactions ??
                const ['👍', '❤️', '😂', '😮', '😢', '😡'],
            autoDownloadConfig: uiConfig.autoDownload,
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
          : FloatingActionButton.small(
              backgroundColor: theme.floatingActionButtonTheme.backgroundColor
                  ?.withValues(alpha: 0.5),
              onPressed: _scrollToBottom,
              child: const Icon(Icons.arrow_downward),
            ),
      body: body,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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

    return AppBar(title: const Text('Chat'));
  }

  PreferredSizeWidget _buildDefaultSelectionAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _clearSelection,
      ),
      title: Text('${_selectedMessages.length} selected'),
      actions: [
        if (widget.onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete!(_selectedMessages);
              _clearSelection();
            },
          ),
      ],
    );
  }
}

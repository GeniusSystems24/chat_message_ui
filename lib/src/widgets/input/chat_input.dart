import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:record/record.dart';
import 'package:text_preview/text_preview.dart';

import '../../adapters/adapters.dart';
import '../common/flow_shader.dart';
import '../common/lottie_animation.dart';
import '../reply/reply_preview_widget.dart';
import 'attachment_source_selector.dart';
import 'chat_input_mixins.dart';
import 'floating_suggestion_card.dart';
import 'input_models.dart';
import 'text_data_preview_card.dart';

part 'voice_recorder.dart';
part 'recording_waveform.dart';

/// Callback type for text message sending
typedef OnSendText = Future<void> Function(String text);

/// Callback type for attachment selection
typedef OnAttachmentSelected = void Function(AttachmentSource type);

/// Callback type for suggestion data providers
typedef SuggestionDataProvider<T> = Future<List<FloatingSuggestionItem<T>>>
    Function(String query);

/// A reusable chat input widget with attachment options
class ChatInputWidget extends StatefulWidget {
  /// Callback when text message is sent
  final OnSendText onSendText;

  /// Callback when attachment is selected
  final OnAttachmentSelected? onAttachmentSelected;

  /// Callback when audio recording is complete with optional waveform data
  final Future<void> Function(
    String filePath,
    int durationInSeconds, {
    List<double>? waveform,
  })? onRecordingComplete;

  /// Callback when audio recording starts
  final VoidCallback? onRecordingStart;

  /// Callback when audio recording stops
  final VoidCallback? onRecordingCancel;

  /// Callback when audio recording is locked
  final ValueChanged<bool>? onRecordingLockedChanged;

  /// Custom input decoration
  final InputDecoration? inputDecoration;

  /// Whether to enable attachments
  final bool enableAttachments;

  /// Whether to enable audio recording
  final bool enableAudioRecording;

  /// Text editing controller
  final TextEditingController? controller;

  /// Hint text for the input field
  final String hintText;

  /// Recording duration in seconds
  final int recordingDuration;

  /// Reply message
  final ValueNotifier<ChatReplyData?>? replyMessage;

  /// Focus node
  final FocusNode? focusNode;

  /// Get recording path
  final String Function()? getRecordingPath;

  /// Username suggestions provider
  final SuggestionDataProvider<ChatUserSuggestion>? usernameProvider;

  /// Hashtag suggestions provider
  final SuggestionDataProvider<Hashtag>? hashtagProvider;

  /// Quick reply suggestions provider
  final SuggestionDataProvider<QuickReply>? quickReplyProvider;

  /// Custom task suggestions provider (generic)
  final SuggestionDataProvider<dynamic>? taskProvider;

  /// Whether to enable floating suggestions
  final bool enableFloatingSuggestions;

  /// Whether to enable text data preview
  final bool enableTextDataPreview;

  /// Creates a ChatInput widget
  const ChatInputWidget({
    super.key,
    required this.onSendText,
    this.replyMessage,
    this.onAttachmentSelected,
    this.onRecordingStart,
    this.onRecordingCancel,
    this.inputDecoration,
    this.enableAttachments = true,
    this.enableAudioRecording = true,
    this.controller,
    this.hintText = 'Message',
    this.recordingDuration = 0,
    this.focusNode,
    this.onRecordingComplete,
    this.onRecordingLockedChanged,
    this.getRecordingPath,
    this.usernameProvider,
    this.hashtagProvider,
    this.taskProvider,
    this.quickReplyProvider,
    this.enableFloatingSuggestions = true,
    this.enableTextDataPreview = true,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget>
    with
        TextProcessingMixin,
        OverlayManagementMixin,
        PositionCalculationMixin,
        DurationFormattingMixin {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  bool _isRecordingLocked = false;
  bool _isRecording = false;

  // Floating suggestions state
  final ValueNotifier<FloatingSuggestionType?> _currentSuggestionType =
      ValueNotifier(null);
  final ValueNotifier<String> _currentSuggestionQuery = ValueNotifier('');

  // Text data preview state
  final ValueNotifier<TextData?> _textDataPreview = ValueNotifier(null);

  // TextField key
  final GlobalKey _inputKey = GlobalKey(debugLabel: "ChatInput TextField Key");

  // Links for positioning floating cards
  final LayerLink _inputLayerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    // Add text change listener
    _textController.addListener(_listenToTextChanges);
  }

  @override
  void dispose() {
    // Remove text change listener
    _textController.removeListener(_listenToTextChanges);

    // Clean up resources
    removeSuggestionOverlay();
    _currentSuggestionType.dispose();
    _currentSuggestionQuery.dispose();
    _textDataPreview.dispose();

    if (widget.controller == null) {
      _textController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) {
      return;
    }

    await widget.onSendText(_textController.text);
    _textController.clear();
  }

  /// Monitor text changes and handle suggestions and data preview
  void _listenToTextChanges() {
    if (!widget.enableFloatingSuggestions && !widget.enableTextDataPreview) {
      return;
    }

    final text = _textController.text;

    // Handle floating suggestions
    if (widget.enableFloatingSuggestions) {
      _handleFloatingSuggestions(text);
    }

    // Handle text data preview
    if (widget.enableTextDataPreview) {
      _handleTextDataPreview(text);
    }
  }

  /// Handle floating suggestions
  void _handleFloatingSuggestions(String text) {
    // Get word under cursor instead of last word
    final currentWord = getCurrentWordUnderCursor(_textController);

    if (widget.usernameProvider != null &&
        currentWord.startsWith(FloatingSuggestionType.username.symbol)) {
      // Username suggestions
      _showUsernamesFloatingSuggestions(currentWord);
    } else if (widget.hashtagProvider != null &&
        currentWord.startsWith(FloatingSuggestionType.hashtag.symbol)) {
      // Hashtag suggestions
      _showHashtagsFloatingSuggestions(currentWord);
    } else if (widget.quickReplyProvider != null &&
        currentWord.startsWith(FloatingSuggestionType.quickReply.symbol)) {
      // Quick reply suggestions
      _showQuickRepliesFloatingSuggestions(currentWord);
    } else if (widget.taskProvider != null &&
        currentWord.startsWith(FloatingSuggestionType.clubChatTask.symbol)) {
      // Club chat task suggestions
      _showTasksFloatingSuggestions(currentWord);
    } else {
      // Hide suggestions
      _hideFloatingSuggestions();
    }
  }

  /// Handle text data preview
  void _handleTextDataPreview(String text) {
    final parsedData = TextData.parse(text);

    final textData = parsedData.firstWhereOrNull(
      (element) =>
          element is LinkTextData ||
          element is SocialMediaTextData ||
          element is PhoneNumberTextData ||
          element is EmailTextData ||
          element is RouteTextData,
    );

    if (textData != null) {
      _textDataPreview.value = textData;
    } else {
      _textDataPreview.value = null;
    }
  }

  /// Create overlay for username suggestions
  void _createUsernamesSuggestionOverlay(
    List<FloatingSuggestionItem<ChatUserSuggestion>> suggestions,
  ) {
    removeSuggestionOverlay();

    final query = _currentSuggestionQuery.value;

    if (suggestions.isEmpty) return;

    suggestionOverlay = OverlayEntry(
      builder: (context) {
        assert(debugCheckHasMediaQuery(context));

        final boxContext = _inputKey.currentContext;
        if (boxContext == null) return const SizedBox.shrink();
        final box = boxContext.findRenderObject() as RenderBox;

        // Calculate available space above the input
        final overlayY = box.localToGlobal(Offset.zero).dy;
        final maxHeight = (overlayY - MediaQuery.viewPaddingOf(context).top)
            .clamp(0.0, 250.0);

        return PositionedDirectional(
          width: MediaQuery.of(context).size.width - 20,
          child: CompositedTransformFollower(
            link: _inputLayerLink,
            showWhenUnlinked: false,
            offset: Offset(
              0,
              -getPosition(box.globalToLocal(Offset.zero).dy.toInt()) - 4,
            ), // Above input field
            followerAnchor: Alignment.bottomCenter,
            targetAnchor: Alignment.bottomCenter,
            child: FloatingSuggestionCard<ChatUserSuggestion>(
              maxHeight: maxHeight,
              itemHeight: 58,
              query: query,
              type: FloatingSuggestionType.username,
              suggestions: suggestions,
              onSelected: (item) =>
                  _onSuggestionSelected(item.value.mentionText),
              onFilter: (item, query) {
                final lowered = query.toLowerCase();
                return item.label.toLowerCase().contains(lowered) ||
                    (item.subtitle?.toLowerCase().contains(lowered) ?? false);
              },
              onClose: _hideFloatingSuggestions,
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(suggestionOverlay!);
  }

  /// Show floating username suggestions
  Future<void> _showUsernamesFloatingSuggestions(String query) async {
    _currentSuggestionQuery.value = query;

    List<FloatingSuggestionItem<ChatUserSuggestion>> suggestions = [];

    try {
      suggestions = await widget.usernameProvider?.call(query) ?? [];
    } catch (e) {
      // In case of error, ignore and show empty list
      suggestions = [];
    }

    if (suggestions.isNotEmpty) {
      _createUsernamesSuggestionOverlay(suggestions);
    } else {
      _hideFloatingSuggestions();
    }
  }

  /// Create overlay for hashtag suggestions
  void _createHashtagsSuggestionOverlay(
    List<FloatingSuggestionItem<Hashtag>> suggestions,
  ) {
    removeSuggestionOverlay();

    final query = _currentSuggestionQuery.value;

    if (suggestions.isEmpty) return;

    suggestionOverlay = OverlayEntry(
      builder: (context) {
        assert(debugCheckHasMediaQuery(context));

        final boxContext = _inputKey.currentContext;
        if (boxContext == null) return const SizedBox.shrink();
        final box = boxContext.findRenderObject() as RenderBox;

        // Calculate available space above the input
        var localToGlobal = box.localToGlobal(Offset.zero);
        final overlayY = localToGlobal.dy;
        final maxHeight = (overlayY - MediaQuery.viewPaddingOf(context).top)
            .clamp(0.0, 250.0);

        return PositionedDirectional(
          width: MediaQuery.of(context).size.width - 20,
          child: CompositedTransformFollower(
            link: _inputLayerLink,
            showWhenUnlinked: false,
            offset: Offset(
              0,
              -getPosition(box.globalToLocal(Offset.zero).dy.toInt()) - 4,
            ), // Above input field
            followerAnchor: Alignment.bottomCenter,
            targetAnchor: Alignment.bottomCenter,
            child: FloatingSuggestionCard<Hashtag>(
              maxHeight: maxHeight,
              query: query,
              type: FloatingSuggestionType.hashtag,
              suggestions: suggestions,
              onSelected: (item) => _onSuggestionSelected(
                FloatingSuggestionType.hashtag.symbol + item.value.hashtag,
              ),
              onClose: _hideFloatingSuggestions,
              onFilter: (item, query) => item.value.hashtag
                  .toLowerCase()
                  .startsWith(query.toLowerCase()),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(suggestionOverlay!);
  }

  /// Show floating hashtag suggestions
  Future<void> _showHashtagsFloatingSuggestions(String query) async {
    _currentSuggestionQuery.value = query;

    List<FloatingSuggestionItem<Hashtag>> suggestions = [];

    try {
      suggestions = await widget.hashtagProvider?.call(query) ?? [];
    } catch (e) {
      // In case of error, ignore and show empty list
      suggestions = [];
    }

    if (suggestions.isNotEmpty) {
      _createHashtagsSuggestionOverlay(suggestions);
    } else {
      _hideFloatingSuggestions();
    }
  }

  /// Create overlay for quick reply suggestions
  void _createQuickRepliesSuggestionOverlay(
    List<FloatingSuggestionItem<QuickReply>> suggestions,
  ) {
    removeSuggestionOverlay();

    final query = _currentSuggestionQuery.value;

    if (suggestions.isEmpty) return;

    suggestionOverlay = OverlayEntry(
      builder: (context) {
        assert(debugCheckHasMediaQuery(context));

        final boxContext = _inputKey.currentContext;
        if (boxContext == null) return const SizedBox.shrink();
        final box = boxContext.findRenderObject() as RenderBox;

        // Calculate available space above the input
        final overlayY = box.localToGlobal(Offset.zero).dy;
        final maxHeight = (overlayY - MediaQuery.viewPaddingOf(context).top)
            .clamp(0.0, 250.0);

        return PositionedDirectional(
          width: MediaQuery.of(context).size.width - 20,
          child: CompositedTransformFollower(
            link: _inputLayerLink,
            showWhenUnlinked: false,
            offset: Offset(
              0,
              -getPosition(box.globalToLocal(Offset.zero).dy.toInt()) - 4,
            ), // Above input field
            followerAnchor: Alignment.bottomCenter,
            targetAnchor: Alignment.bottomCenter,
            child: FloatingSuggestionCard<QuickReply>(
              maxHeight: maxHeight,
              query: query,
              type: FloatingSuggestionType.quickReply,
              suggestions: suggestions,
              onSelected: (item) => _onSuggestionSelected(item.value.response),
              onClose: _hideFloatingSuggestions,
              onFilter: (item, query) => item.value.response
                  .toLowerCase()
                  .startsWith(query.toLowerCase()),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(suggestionOverlay!);
  }

  /// Show floating quick reply suggestions
  Future<void> _showQuickRepliesFloatingSuggestions(String query) async {
    _currentSuggestionQuery.value = query;
    List<FloatingSuggestionItem<QuickReply>> suggestions = [];

    try {
      suggestions = await widget.quickReplyProvider?.call(query) ?? [];
    } catch (e) {
      // In case of error, ignore and show empty list
      suggestions = [];
    }
    if (suggestions.isNotEmpty) {
      _createQuickRepliesSuggestionOverlay(suggestions);
    } else {
      _hideFloatingSuggestions();
    }
  }

  /// Create overlay for task suggestions (generic)
  void _createTasksSuggestionOverlay(
    List<FloatingSuggestionItem<dynamic>> suggestions,
  ) {
    removeSuggestionOverlay();

    final query = _currentSuggestionQuery.value;

    if (suggestions.isEmpty) return;

    suggestionOverlay = OverlayEntry(
      builder: (context) {
        assert(debugCheckHasMediaQuery(context));

        final boxContext = _inputKey.currentContext;
        if (boxContext == null) return const SizedBox.shrink();
        final box = boxContext.findRenderObject() as RenderBox;

        // Calculate available space above the input
        final overlayY = box.localToGlobal(Offset.zero).dy;
        final maxHeight = (overlayY - MediaQuery.viewPaddingOf(context).top)
            .clamp(0.0, 250.0);

        return PositionedDirectional(
          width: MediaQuery.of(context).size.width - 20,
          child: CompositedTransformFollower(
            link: _inputLayerLink,
            showWhenUnlinked: false,
            offset: Offset(
              0,
              -getPosition(box.globalToLocal(Offset.zero).dy.toInt()) - 4,
            ), // Above input field
            followerAnchor: Alignment.bottomCenter,
            targetAnchor: Alignment.bottomCenter,
            child: FloatingSuggestionCard<dynamic>(
              maxHeight: maxHeight,
              query: query,
              type: FloatingSuggestionType.clubChatTask,
              suggestions: suggestions,
              onSelected: (item) {
                // Assuming item.value is something we can stringify or logic is here
                // Default to string representation or assume it's a string ID.
                // This part needs specific logic if generic.
                // I will assume item.value has a toString() or logic.
                _onSuggestionSelected(
                    FloatingSuggestionType.clubChatTask.symbol +
                        item.value.toString());
              },
              onClose: _hideFloatingSuggestions,
              onFilter: (item, query) =>
                  item.label.toLowerCase().contains(query.toLowerCase()),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(suggestionOverlay!);
  }

  /// Show floating task suggestions
  Future<void> _showTasksFloatingSuggestions(String query) async {
    _currentSuggestionQuery.value = query;
    List<FloatingSuggestionItem<dynamic>> suggestions = [];

    try {
      suggestions = await widget.taskProvider?.call(query) ?? [];
    } catch (e) {
      suggestions = [];
    }
    if (suggestions.isNotEmpty) {
      _createTasksSuggestionOverlay(suggestions);
    } else {
      _hideFloatingSuggestions();
    }
  }

  /// Hide floating suggestions
  void _hideFloatingSuggestions() {
    _currentSuggestionType.value = null;
    _currentSuggestionQuery.value = '';
    removeSuggestionOverlay();
  }

  /// Handle suggestion selection
  void _onSuggestionSelected(String value) {
    replaceWordUnderCursor(_textController, value);
    _hideFloatingSuggestions();
    _focusNode.requestFocus();
  }

  /// Show attachment source selection bottom sheet
  void _showAttachmentSourceSelector() async {
    final result = await showModalBottomSheet<AttachmentSource>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SelectAttachmentSourceActionButton(),
    );

    if (result != null && widget.onAttachmentSelected != null) {
      widget.onAttachmentSelected!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _inputLayerLink,
      child: Column(
        children: [
          if (widget.replyMessage != null)
            // Reply preview
            ValueListenableBuilder<ChatReplyData?>(
              valueListenable: widget.replyMessage!,
              builder: (context, replyMessage, child) {
                if (replyMessage == null) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  child: ReplyPreviewWidget(
                    replyMessage: replyMessage,
                    onCancel: () => widget.replyMessage!.value = null,
                  ),
                );
              },
            ),

          // Text data preview
          ValueListenableBuilder<TextData?>(
            valueListenable: _textDataPreview,
            builder: (context, textData, child) {
              if (textData == null || !widget.enableTextDataPreview) {
                return const SizedBox.shrink();
              }
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: TextDataPreviewCard(
                  textData: textData,
                  constraints:
                      const BoxConstraints(maxHeight: 250, minHeight: 100),
                ),
              );
            },
          ),

          // Recording indicator
          if (_isRecording)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recording... ${formatDuration(widget.recordingDuration)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Input row
          Row(
            children: [
              const SizedBox(width: 8),
              // Text input field
              if (!_isRecordingLocked)
                Expanded(
                  child: TextField(
                    key: _inputKey,
                    controller: _textController,
                    focusNode: _focusNode,
                    decoration: (widget.inputDecoration ??
                            InputDecoration(
                              hintText: _isRecording
                                  ? 'Recording audio...'
                                  : widget.hintText,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ))
                        .copyWith(
                      prefixIcon: widget.enableAttachments && !_isRecording
                          ? IconButton(
                              style: IconButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                iconSize: 24,
                              ),
                              icon: const Icon(Icons.attach_file),
                              onPressed: _showAttachmentSourceSelector,
                            )
                          : null,
                    ),
                    maxLines: 5,
                    minLines: 1,
                    enabled: !_isRecording,
                  ),
                ),
              const SizedBox(width: 4),
              // Record/Send button
              ValueListenableBuilder(
                valueListenable: _textController,
                builder: (context, value, child) {
                  if (widget.enableAudioRecording &&
                      value.text.trim().isEmpty) {
                    // WhatsApp-style voice recorder with waveform
                    return WhatsAppVoiceRecorder(
                      size: 40,
                      showWaveform: true,
                      onRecordingStart: () {
                        setState(() {
                          _isRecording = true;
                        });
                        widget.onRecordingStart?.call();
                      },
                      onRecordingComplete: (path, duration, {waveform}) async {
                        setState(() {
                          _isRecording = false;
                        });
                        if (widget.onRecordingComplete != null) {
                          await widget.onRecordingComplete!(
                            path,
                            duration,
                            waveform: waveform,
                          );
                        }
                      },
                      onRecordingCancel: () {
                        setState(() {
                          _isRecording = false;
                        });
                        widget.onRecordingCancel?.call();
                      },
                      getRecordingPath: widget.getRecordingPath,
                      onRecordingLockedChanged: (locked) {
                        widget.onRecordingLockedChanged?.call(locked);
                        setState(() {
                          _isRecordingLocked = locked;
                        });
                      },
                    );
                  } else {
                    // Send button
                    return IconButton.filled(
                      style: IconButton.styleFrom(
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      icon: const Icon(Icons.send),
                      onPressed:
                          value.text.trim().isNotEmpty ? _sendMessage : null,
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

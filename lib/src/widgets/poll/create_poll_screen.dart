// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../theme/chat_theme.dart';

/// Data model for a new poll to be created.
class CreatePollData {
  /// The poll question.
  final String question;

  /// List of option texts.
  final List<String> options;

  /// Whether multiple answers are allowed.
  final bool allowMultipleAnswers;

  const CreatePollData({
    required this.question,
    required this.options,
    this.allowMultipleAnswers = false,
  });

  /// Validates the poll data.
  bool get isValid =>
      question.trim().isNotEmpty &&
      options.where((o) => o.trim().isNotEmpty).length >= 2;

  /// Gets only non-empty options.
  List<String> get validOptions =>
      options.where((o) => o.trim().isNotEmpty).toList();
}

/// WhatsApp-style screen for creating a new poll.
///
/// Features:
/// - Question input field
/// - Dynamic option fields with add/remove capability
/// - Multiple answers toggle
/// - Validation before submission
/// - Dark/Light theme support
class CreatePollScreen extends StatefulWidget {
  /// Callback when poll is created successfully.
  final void Function(CreatePollData poll)? onCreatePoll;

  /// Minimum number of options required.
  final int minOptions;

  /// Maximum number of options allowed.
  final int maxOptions;

  /// Custom app bar title.
  final String? title;

  /// Custom question hint text.
  final String? questionHint;

  /// Custom option hint text.
  final String? optionHint;

  /// Custom multiple answers label.
  final String? multipleAnswersLabel;

  const CreatePollScreen({
    super.key,
    this.onCreatePoll,
    this.minOptions = 2,
    this.maxOptions = 12,
    this.title,
    this.questionHint,
    this.optionHint,
    this.multipleAnswersLabel,
  });

  /// Shows the create poll screen as a modal bottom sheet.
  static Future<CreatePollData?> showAsBottomSheet(
    BuildContext context, {
    void Function(CreatePollData poll)? onCreatePoll,
    int minOptions = 2,
    int maxOptions = 12,
  }) {
    return showModalBottomSheet<CreatePollData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: CreatePollScreen(
            onCreatePoll: (poll) {
              onCreatePoll?.call(poll);
              Navigator.of(context).pop(poll);
            },
            minOptions: minOptions,
            maxOptions: maxOptions,
          ),
        ),
      ),
    );
  }

  /// Shows the create poll screen as a full page.
  static Future<CreatePollData?> showAsPage(
    BuildContext context, {
    void Function(CreatePollData poll)? onCreatePoll,
    int minOptions = 2,
    int maxOptions = 12,
  }) {
    return Navigator.of(context).push<CreatePollData>(
      MaterialPageRoute(
        builder: (context) => CreatePollScreen(
          onCreatePoll: (poll) {
            onCreatePoll?.call(poll);
            Navigator.of(context).pop(poll);
          },
          minOptions: minOptions,
          maxOptions: maxOptions,
        ),
      ),
    );
  }

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  late final TextEditingController _questionController;
  late final List<TextEditingController> _optionControllers;
  late final List<FocusNode> _optionFocusNodes;
  final FocusNode _questionFocusNode = FocusNode();
  bool _allowMultipleAnswers = false;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();

    // Start with minimum required empty options
    _optionControllers = List.generate(
      widget.minOptions,
      (_) => TextEditingController(),
    );
    _optionFocusNodes = List.generate(
      widget.minOptions,
      (_) => FocusNode(),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _questionFocusNode.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    for (final focusNode in _optionFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  bool get _isValid {
    final question = _questionController.text.trim();
    if (question.isEmpty) return false;

    final validOptions = _optionControllers
        .where((c) => c.text.trim().isNotEmpty)
        .length;
    return validOptions >= widget.minOptions;
  }

  void _addOption() {
    if (_optionControllers.length >= widget.maxOptions) return;

    setState(() {
      _optionControllers.add(TextEditingController());
      _optionFocusNodes.add(FocusNode());
    });

    // Focus the new option field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _optionFocusNodes.last.requestFocus();
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= widget.minOptions) return;

    setState(() {
      _optionControllers[index].dispose();
      _optionFocusNodes[index].dispose();
      _optionControllers.removeAt(index);
      _optionFocusNodes.removeAt(index);
    });
  }

  void _submitPoll() {
    if (!_isValid) return;

    final poll = CreatePollData(
      question: _questionController.text.trim(),
      options: _optionControllers.map((c) => c.text.trim()).toList(),
      allowMultipleAnswers: _allowMultipleAnswers,
    );

    widget.onCreatePoll?.call(poll);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = ChatThemeData.get(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF1F2C34) // WhatsApp dark background
        : theme.scaffoldBackgroundColor;


    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.5);

    final labelColor = isDark
        ? Colors.white.withValues(alpha: 0.7)
        : Colors.black.withValues(alpha: 0.7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title ?? 'Create poll',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Section
                  _SectionLabel(
                    label: 'Question',
                    color: labelColor,
                  ),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: _questionController,
                    focusNode: _questionFocusNode,
                    hintText: widget.questionHint ?? 'Ask question',
                    borderColor: borderColor,
                    hintColor: hintColor,
                    textColor: isDark ? Colors.white : Colors.black,
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 24),

                  // Options Section
                  _SectionLabel(
                    label: 'Options',
                    color: labelColor,
                  ),
                  const SizedBox(height: 8),

                  // Option Fields
                  ...List.generate(_optionControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OptionField(
                        controller: _optionControllers[index],
                        focusNode: _optionFocusNodes[index],
                        hintText: widget.optionHint ?? '+ Add',
                        borderColor: borderColor,
                        hintColor: chatTheme.colors.primary,
                        textColor: isDark ? Colors.white : Colors.black,
                        showRemoveButton:
                            _optionControllers.length > widget.minOptions,
                        onRemove: () => _removeOption(index),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) {
                          if (index == _optionControllers.length - 1) {
                            _addOption();
                          } else {
                            _optionFocusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),

                  // Add Option Button
                  if (_optionControllers.length < widget.maxOptions)
                    _AddOptionButton(
                      onTap: _addOption,
                      borderColor: borderColor,
                      accentColor: chatTheme.colors.primary,
                    ),

                  const SizedBox(height: 24),

                  // Multiple Answers Toggle
                  _MultipleAnswersToggle(
                    value: _allowMultipleAnswers,
                    onChanged: (value) {
                      setState(() => _allowMultipleAnswers = value);
                    },
                    label: widget.multipleAnswersLabel ?? 'Allow multiple answers',
                    textColor: isDark ? Colors.white : Colors.black,
                    activeColor: chatTheme.colors.primary,
                  ),
                ],
              ),
            ),
          ),

          // Send Button
          _SendButton(
            onTap: _isValid ? _submitPoll : null,
            isEnabled: _isValid,
            accentColor: chatTheme.colors.primary,
          ),
        ],
      ),
    );
  }
}

/// Section label widget.
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionLabel({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}

/// Input field with WhatsApp styling.
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Color borderColor;
  final Color hintColor;
  final Color textColor;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.borderColor,
    required this.hintColor,
    required this.textColor,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: hintColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

/// Option field with remove button.
class _OptionField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Color borderColor;
  final Color hintColor;
  final Color textColor;
  final bool showRemoveButton;
  final VoidCallback? onRemove;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const _OptionField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.borderColor,
    required this.hintColor,
    required this.textColor,
    this.showRemoveButton = false,
    this.onRemove,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.next,
            ),
          ),
          if (showRemoveButton)
            IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
                color: textColor.withValues(alpha: 0.5),
              ),
              onPressed: onRemove,
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}

/// Add option button.
class _AddOptionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color borderColor;
  final Color accentColor;

  const _AddOptionButton({
    required this.onTap,
    required this.borderColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 20,
              color: accentColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Add option',
              style: TextStyle(
                fontSize: 16,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Multiple answers toggle switch.
class _MultipleAnswersToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Color textColor;
  final Color activeColor;

  const _MultipleAnswersToggle({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.textColor,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          activeTrackColor: activeColor.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

/// Floating send button.
class _SendButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isEnabled;
  final Color accentColor;

  const _SendButton({
    this.onTap,
    required this.isEnabled,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: isEnabled ? accentColor : accentColor.withValues(alpha: 0.5),
        elevation: isEnabled ? 6 : 0,
        child: Icon(
          Icons.send,
          color: Colors.white.withValues(alpha: isEnabled ? 1.0 : 0.7),
        ),
      ),
    );
  }
}

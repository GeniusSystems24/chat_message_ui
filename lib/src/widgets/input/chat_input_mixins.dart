import 'package:flutter/material.dart';

import 'input_models.dart';

/// Mixin for text processing utilities
mixin TextProcessingMixin {
  /// Get current word under cursor
  String getCurrentWordUnderCursor(TextEditingController controller) {
    final text = controller.text;
    final cursorPosition = controller.selection.baseOffset;

    // Ensure cursor position is valid
    if (cursorPosition < 0 || cursorPosition > text.length || text.isEmpty) {
      return '';
    }

    // If cursor is at end and last character is space, return empty
    if (cursorPosition == text.length && text.endsWith(' ')) {
      return '';
    }

    // Find start of current word
    int wordStart = cursorPosition;
    while (wordStart > 0 &&
        text[wordStart - 1] != ' ' &&
        text[wordStart - 1] != '\n') {
      wordStart--;
    }

    // Find end of current word
    int wordEnd = cursorPosition;
    while (wordEnd < text.length &&
        text[wordEnd] != ' ' &&
        text[wordEnd] != '\n') {
      wordEnd++;
    }

    // Extract word
    if (wordStart < wordEnd) {
      final word = text.substring(wordStart, wordEnd);

      // Ensure word starts with required symbols
      if (word.startsWith(FloatingSuggestionType.username.symbol) ||
          word.startsWith(FloatingSuggestionType.hashtag.symbol) ||
          word.startsWith(FloatingSuggestionType.quickReply.symbol) ||
          word.startsWith(FloatingSuggestionType.clubChatTask.symbol)) {
        return word;
      }
    }

    return '';
  }

  /// Replace word under cursor with suggestion
  void replaceWordUnderCursor(
    TextEditingController controller,
    String replacement,
  ) {
    final text = controller.text;
    final cursorPosition = controller.selection.baseOffset;

    // Ensure cursor position is valid
    if (cursorPosition < 0 || cursorPosition > text.length) {
      return;
    }

    // Find start of current word
    int wordStart = cursorPosition;
    while (wordStart > 0 &&
        text[wordStart - 1] != ' ' &&
        text[wordStart - 1] != '\n') {
      wordStart--;
    }

    // Find end of current word
    int wordEnd = cursorPosition;
    while (wordEnd < text.length &&
        text[wordEnd] != ' ' &&
        text[wordEnd] != '\n') {
      wordEnd++;
    }

    // Replace word under cursor with suggestion
    final beforeWord = text.substring(0, wordStart);
    final afterWord = text.substring(wordEnd);
    final newText = '$beforeWord$replacement $afterWord';

    controller.text = newText;

    // Set cursor after inserted word
    final newCursorPosition = wordStart + replacement.length + 1;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newCursorPosition),
    );
  }
}

/// Mixin for overlay management
mixin OverlayManagementMixin {
  OverlayEntry? _suggestionOverlay;

  /// Remove suggestion overlay
  void removeSuggestionOverlay() {
    _suggestionOverlay?.remove();
    _suggestionOverlay = null;
  }

  /// Get suggestion overlay
  OverlayEntry? get suggestionOverlay => _suggestionOverlay;

  /// Set suggestion overlay
  set suggestionOverlay(OverlayEntry? overlay) {
    _suggestionOverlay = overlay;
  }
}

/// Mixin for duration formatting
mixin DurationFormattingMixin {
  /// Format duration in MM:SS format
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

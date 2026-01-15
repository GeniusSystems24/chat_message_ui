import 'package:flutter/material.dart';

import '../theme/chat_theme.dart';

enum AutoDownloadPolicy {
  never,
  wifiOnly,
  always,
}

class ChatAutoDownloadConfig {
  final AutoDownloadPolicy image;
  final AutoDownloadPolicy video;
  final AutoDownloadPolicy audio;
  final AutoDownloadPolicy document;

  const ChatAutoDownloadConfig({
    required this.image,
    required this.video,
    required this.audio,
    required this.document,
  });

  ChatAutoDownloadConfig copyWith({
    AutoDownloadPolicy? image,
    AutoDownloadPolicy? video,
    AutoDownloadPolicy? audio,
    AutoDownloadPolicy? document,
  }) {
    return ChatAutoDownloadConfig(
      image: image ?? this.image,
      video: video ?? this.video,
      audio: audio ?? this.audio,
      document: document ?? this.document,
    );
  }
}

class ChatPaginationConfig {
  final EdgeInsets? listPadding;
  final List<String>? availableReactions;

  const ChatPaginationConfig({
    this.listPadding,
    this.availableReactions,
  });

  ChatPaginationConfig copyWith({
    EdgeInsets? listPadding,
    List<String>? availableReactions,
  }) {
    return ChatPaginationConfig(
      listPadding: listPadding ?? this.listPadding,
      availableReactions: availableReactions ?? this.availableReactions,
    );
  }
}

class ChatMessageUiConfig {
  static ChatMessageUiConfig instance = const ChatMessageUiConfig();

  final bool enableSuggestions;
  final bool enableTextPreview;
  final InputDecoration? inputDecoration;
  final ChatThemeData? bubbleTheme;
  final ChatPaginationConfig pagination;
  final ChatAutoDownloadConfig autoDownload;

  const ChatMessageUiConfig({
    this.enableSuggestions = true,
    this.enableTextPreview = true,
    this.inputDecoration,
    this.bubbleTheme,
    this.pagination = const ChatPaginationConfig(),
    this.autoDownload = const ChatAutoDownloadConfig(
      image: AutoDownloadPolicy.never,
      video: AutoDownloadPolicy.never,
      audio: AutoDownloadPolicy.always,
      document: AutoDownloadPolicy.never,
    ),
  });

  ChatMessageUiConfig copyWith({
    bool? enableSuggestions,
    bool? enableTextPreview,
    InputDecoration? inputDecoration,
    ChatThemeData? bubbleTheme,
    ChatPaginationConfig? pagination,
    ChatAutoDownloadConfig? autoDownload,
  }) {
    return ChatMessageUiConfig(
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
      enableTextPreview: enableTextPreview ?? this.enableTextPreview,
      inputDecoration: inputDecoration ?? this.inputDecoration,
      bubbleTheme: bubbleTheme ?? this.bubbleTheme,
      pagination: pagination ?? this.pagination,
      autoDownload: autoDownload ?? this.autoDownload,
    );
  }
}

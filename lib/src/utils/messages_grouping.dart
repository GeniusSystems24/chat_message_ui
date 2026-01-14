import 'package:flutter/foundation.dart';

import '../adapters/chat_message_data.dart';

/// Defines the mode for grouping items. Default is [timeDifference].
enum MessagesGroupingMode { timeDifference, sameMinute, sameHour, sameDay }

/// Represents the grouping status of a message within a sequence of messages
/// from the same author sent close together in time.
@immutable
class MessageGroupStatus {
  /// True if this is the first item in the group.
  final bool isFirst;

  /// True if this is the last item in the group.
  final bool isLast;

  /// True if this is a item in the middle of the group (neither first nor last).
  final bool isMiddle;

  /// Creates a [MessageGroupStatus] instance.
  const MessageGroupStatus({
    required this.isFirst,
    required this.isLast,
    required this.isMiddle,
  });

  static MessageGroupStatus? resolveGroupStatus({
    required List<IChatMessageData> items,
    required int index,
    MessagesGroupingMode? messagesGroupingMode,
    int messagesGroupingTimeoutInSeconds = 300,
  }) {
    if (items.isEmpty || index < 0 || index >= items.length) {
      return null;
    }

    final currentItem = items[index];
    final nextMessage = index < items.length - 1 ? items[index + 1] : null;
    final previousMessage = index > 0 ? items[index - 1] : null;

    final currentMessageDate = _messageTimestamp(currentItem);
    final nextMessageDate =
        nextMessage == null ? null : _messageTimestamp(nextMessage);
    final previousMessageDate =
        previousMessage == null ? null : _messageTimestamp(previousMessage);

    final groupingMode =
        messagesGroupingMode ?? MessagesGroupingMode.sameMinute;

    final isGroupedWithNext = nextMessage != null &&
        nextMessage.senderId == currentItem.senderId &&
        shouldGroupMessages(
          currentMessageDate,
          nextMessageDate,
          groupingMode,
          messagesGroupingTimeoutInSeconds,
        );

    final isGroupedWithPrevious = previousMessage != null &&
        previousMessage.senderId == currentItem.senderId &&
        shouldGroupMessages(
          previousMessageDate,
          currentMessageDate,
          groupingMode,
          messagesGroupingTimeoutInSeconds,
        );

    if (!isGroupedWithNext && !isGroupedWithPrevious) {
      return const MessageGroupStatus(
        isFirst: true,
        isLast: true,
        isMiddle: false,
      );
    }

    return MessageGroupStatus(
      isFirst: !isGroupedWithPrevious,
      isLast: !isGroupedWithNext,
      isMiddle: isGroupedWithNext && isGroupedWithPrevious,
    );
  }

  /// Determines if two messages should be grouped together based on the grouping mode.
  ///
  /// [earlierDate] should be the timestamp of the earlier message.
  /// [laterDate] should be the timestamp of the later message.
  static bool shouldGroupMessages(
    DateTime? earlierDate,
    DateTime? laterDate,
    MessagesGroupingMode groupingMode,
    int timeoutInSeconds,
  ) {
    if (earlierDate == null || laterDate == null) return false;
    switch (groupingMode) {
      case MessagesGroupingMode.timeDifference:
        return isWithinTimeThreshold(earlierDate, laterDate, timeoutInSeconds);
      case MessagesGroupingMode.sameMinute:
        return isSameMinute(earlierDate, laterDate);
      case MessagesGroupingMode.sameHour:
        return isSameHour(earlierDate, laterDate);
      case MessagesGroupingMode.sameDay:
        return isSameDay(earlierDate, laterDate);
    }
  }

  /// Checks if two timestamps are within the specified time threshold.
  static bool isWithinTimeThreshold(
    DateTime earlierDate,
    DateTime laterDate,
    int timeoutInSeconds,
  ) {
    return laterDate.difference(earlierDate).inSeconds < timeoutInSeconds;
  }

  /// Checks if two timestamps are in the same minute.
  static bool isSameMinute(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute;
  }

  /// Checks if two timestamps are in the same hour.
  static bool isSameHour(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour;
  }

  /// Checks if two timestamps are on the same day.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

DateTime? _messageTimestamp(IChatMessageData message) {
  return message.createdAt;
}

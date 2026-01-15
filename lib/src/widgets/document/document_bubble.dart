import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transfer_kit/transfer_kit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../adapters/adapters.dart';
import '../../theme/chat_theme.dart';
import '../../transfer/media_transfer_controller.dart';
import 'file_icon.dart';

/// Widget to display a document attachment in a message bubble.
class DocumentBubble extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;

  const DocumentBubble({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
  });

  String? get fileName => message.mediaData?.fileName ?? message.textContent;
  String? get url => message.mediaData?.url;
  int get fileSize => message.mediaData?.fileSize ?? 0;
  String? get localPath =>
      url != null && !(url!.startsWith('http')) ? url : null;

  @override
  Widget build(BuildContext context) {
    if (localPath != null) {
      return _documentTileBuild(context, localPath!);
    }

    final fileUrl = url;
    if (fileUrl == null) {
      return _DocumentErrorWidget(chatTheme: chatTheme);
    }

    final controller = MediaTransferController.instance;
    final downloadTask = controller.buildDownloadTask(
      url: fileUrl,
      fileName: fileName,
    );

    return FutureBuilder(
      future: controller.enqueueOrResume(downloadTask, autoStart: false),
      builder: (context, asyncSnapshot) {
        final (
          String? filePath,
          StreamController<TaskItem>? streamController
        ) = asyncSnapshot.data ?? (null, null);

        if (filePath != null) {
          return _documentTileBuild(context, filePath);
        }

        return StreamBuilder(
          initialData: FileTaskController.instance.fileUpdates[downloadTask.url],
          stream: (streamController ??
                  FileTaskController.instance.createFileController(
                    downloadTask.url,
                  ))
              .stream,
          builder: (context, snapshot) {
            final taskItem = snapshot.data;
            return DocumentDownloadCard(
              item: taskItem,
              fileName: fileName,
              fileSize: fileSize,
              onStart: () => controller.startDownload(downloadTask),
              onPause: controller.pauseDownload,
              onResume: controller.resumeDownload,
              onCancel: controller.cancelDownload,
              onRetry: controller.retryDownload,
              onOpen: controller.openDownloadedFile,
              completedBuilder: (context, item) =>
                  _documentTileBuild(context, item.filePath),
              loadingBuilder: (context, item) => _documentInfoBuild(context),
              errorBuilder: (context, item, error) =>
                  _DocumentErrorWidget(chatTheme: chatTheme),
            );
          },
        );
      },
    );
  }

  Widget _documentTileBuild(BuildContext context, String filePath) {
    return GestureDetector(
      onTap: onTap ?? () => _openLocalFile(context, filePath),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMyMessage
              ? chatTheme.colors.primary.withValues(alpha: 0.1)
              : chatTheme.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: chatTheme.colors.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            FileIcon(fileName: fileName ?? 'Document'),
            const SizedBox(width: 12),
            Expanded(child: _documentInfoBuild(context)),
            const SizedBox(width: 8),
            Icon(
              Icons.open_in_new_rounded,
              size: 20,
              color: chatTheme.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLocalFile(BuildContext context, String filePath) async {
    final uri = Uri.file(filePath);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open document: $filePath')),
        );
      }
    }
  }

  Widget _documentInfoBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fileName ?? 'Document',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: chatTheme.colors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatFileSize(fileSize),
          style: TextStyle(
            fontSize: 12,
            color: chatTheme.colors.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '';
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = 0;
    double size = bytes.toDouble();
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
}

class _DocumentErrorWidget extends StatelessWidget {
  final ChatThemeData chatTheme;

  const _DocumentErrorWidget({required this.chatTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Document not available',
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

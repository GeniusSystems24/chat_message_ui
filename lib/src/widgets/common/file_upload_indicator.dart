import 'package:flutter/material.dart';

/// Widget to display file upload progress
class FileUploadIndicator extends StatelessWidget {
  /// File path being uploaded
  final String filePath;

  /// Progress percentage (0-100)
  final double progressPercentage;

  /// Current status of the upload
  final FileUploadStatus status;

  /// Callback when cancel button is pressed
  final VoidCallback? onCancel;

  /// Callback when retry button is pressed
  final VoidCallback? onRetry;

  /// Creates a FileUploadIndicator widget
  const FileUploadIndicator({
    super.key,
    required this.filePath,
    required this.progressPercentage,
    this.status = FileUploadStatus.uploading,
    this.onCancel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Extract the extension to determine file type
    final fileName = filePath.split('/').last;
    final extension = fileName.split('.').last.toLowerCase();

    // Determine if this is a media file (image or video)
    final bool isImage = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
    ].contains(extension);
    final bool isVideo = [
      'mp4',
      'mov',
      'avi',
      'mkv',
      '3gp',
    ].contains(extension);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          // Thumbnail/Icon area
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Icon(
                isImage
                    ? Icons.image
                    : (isVideo ? Icons.video_file : Icons.insert_drive_file),
                color: isImage
                    ? Theme.of(context).colorScheme.primary
                    : (isVideo
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.onSurfaceVariant),
                size: 30,
              ),
            ),
          ),

          // Info and progress
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File name
                  Text(
                    fileName,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Progress indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressPercentage / 100,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      color: status == FileUploadStatus.error
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      minHeight: 4,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Status text
                  Row(
                    children: [
                      Text(
                        _getStatusText(),
                        style: TextStyle(
                          fontSize: 12,
                          color: status == FileUploadStatus.error
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${progressPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (status == FileUploadStatus.uploading ||
                          status == FileUploadStatus.waiting)
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          onPressed: onCancel,
                        ),
                      if (status == FileUploadStatus.error && onRetry != null)
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: onRetry,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case FileUploadStatus.error:
        return 'Failed';
      case FileUploadStatus.complete:
        return 'Completed';
      case FileUploadStatus.paused:
        return 'Paused';
      case FileUploadStatus.waiting:
        return 'Waiting';
      case FileUploadStatus.cancelled:
        return 'Cancelled';
      case FileUploadStatus.uploading:
        return 'Uploading';
    }
  }
}

/// Enum representing the status of a file upload
enum FileUploadStatus {
  waiting,
  uploading,
  paused,
  complete,
  error,
  cancelled,
}

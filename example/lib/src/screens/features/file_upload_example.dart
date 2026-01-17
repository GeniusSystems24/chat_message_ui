import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../shared/example_scaffold.dart';

/// Example screen showcasing FileUploadIndicator widget.
///
/// Features demonstrated:
/// - All FileUploadStatus states
/// - Progress animation
/// - Cancel and Retry callbacks
/// - Different file types (image, video, document)
class FileUploadExample extends StatefulWidget {
  const FileUploadExample({super.key});

  @override
  State<FileUploadExample> createState() => _FileUploadExampleState();
}

class _FileUploadExampleState extends State<FileUploadExample> {
  // Simulated uploads
  final List<_SimulatedUpload> _uploads = [];
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _initUploads();
    _startProgressSimulation();
  }

  void _initUploads() {
    _uploads.addAll([
      _SimulatedUpload(
        filePath: '/storage/photos/vacation_photo.jpg',
        status: FileUploadStatus.uploading,
        progress: 45.0,
      ),
      _SimulatedUpload(
        filePath: '/storage/videos/meeting_recording.mp4',
        status: FileUploadStatus.waiting,
        progress: 0.0,
      ),
      _SimulatedUpload(
        filePath: '/storage/documents/quarterly_report.pdf',
        status: FileUploadStatus.paused,
        progress: 72.0,
      ),
      _SimulatedUpload(
        filePath: '/storage/photos/team_photo.png',
        status: FileUploadStatus.complete,
        progress: 100.0,
      ),
      _SimulatedUpload(
        filePath: '/storage/documents/presentation.pptx',
        status: FileUploadStatus.error,
        progress: 35.0,
      ),
      _SimulatedUpload(
        filePath: '/storage/videos/demo_video.mov',
        status: FileUploadStatus.cancelled,
        progress: 20.0,
      ),
    ]);
  }

  void _startProgressSimulation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        for (var upload in _uploads) {
          if (upload.status == FileUploadStatus.uploading) {
            upload.progress += 0.5;
            if (upload.progress >= 100) {
              upload.progress = 100;
              upload.status = FileUploadStatus.complete;
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'File Upload Indicator',
      subtitle: 'Upload progress and status display',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.cloud_upload_outlined,
            lines: [
              'Shows FileUploadIndicator widget with all status states.',
              'Demonstrates progress animation for uploads.',
              'Includes Cancel and Retry functionality.',
              'Supports different file types (image, video, document).',
            ],
          ),
          const SizedBox(height: 24),

          // Status Overview Section
          const ExampleSectionHeader(
            title: 'All Status States',
            description: 'FileUploadStatus enum values',
            icon: Icons.list_alt,
          ),
          const SizedBox(height: 16),

          ..._uploads.map((upload) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusLabel(status: upload.status),
                    FileUploadIndicator(
                      filePath: upload.filePath,
                      progressPercentage: upload.progress,
                      status: upload.status,
                      onCancel: () => _handleCancel(upload),
                      onRetry: () => _handleRetry(upload),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 24),

          // Interactive Demo Section
          const ExampleSectionHeader(
            title: 'Interactive Demo',
            description: 'Start a new upload simulation',
            icon: Icons.play_arrow,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.image,
                  label: 'Image',
                  onPressed: () => _startNewUpload('image'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: Icons.video_file,
                  label: 'Video',
                  onPressed: () => _startNewUpload('video'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: Icons.description,
                  label: 'Document',
                  onPressed: () => _startNewUpload('document'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Status Controls Section
          const ExampleSectionHeader(
            title: 'Status Controls',
            description: 'Toggle status for demonstration',
            icon: Icons.toggle_on,
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FileUploadStatus.values.map((status) {
              return FilterChip(
                label: Text(_getStatusName(status)),
                selected: _uploads.any((u) => u.status == status),
                onSelected: (_) => _addUploadWithStatus(status),
                avatar: Icon(_getStatusIcon(status), size: 18),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Properties Section
          const ExampleSectionHeader(
            title: 'FileUploadIndicator Properties',
            description: 'Available parameters',
            icon: Icons.tune,
          ),
          const SizedBox(height: 12),

          const PropertyShowcase(
            property: 'filePath',
            value: 'String (required)',
            description: 'Path of the file being uploaded',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'progressPercentage',
            value: 'double (required)',
            description: 'Progress from 0 to 100',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'status',
            value: 'FileUploadStatus',
            description: 'Current upload status (default: uploading)',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onCancel',
            value: 'VoidCallback?',
            description: 'Called when cancel button is pressed',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onRetry',
            value: 'VoidCallback?',
            description: 'Called when retry button is pressed',
          ),

          const SizedBox(height: 24),

          // FileUploadStatus Enum Section
          const ExampleSectionHeader(
            title: 'FileUploadStatus Enum',
            description: 'All possible status values',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 12),

          ...[
            ('waiting', 'File is queued for upload'),
            ('uploading', 'Upload in progress'),
            ('paused', 'Upload temporarily paused'),
            ('complete', 'Upload finished successfully'),
            ('error', 'Upload failed with error'),
            ('cancelled', 'Upload cancelled by user'),
          ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PropertyShowcase(
                  property: item.$1,
                  value: item.$2,
                ),
              )),

          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''
// Basic usage
FileUploadIndicator(
  filePath: '/storage/photos/image.jpg',
  progressPercentage: 45.0,
  status: FileUploadStatus.uploading,
  onCancel: () {
    // Cancel the upload
    uploadManager.cancel(fileId);
  },
  onRetry: () {
    // Retry failed upload
    uploadManager.retry(fileId);
  },
)

// In a list of uploads
ListView.builder(
  itemCount: uploads.length,
  itemBuilder: (context, index) {
    final upload = uploads[index];
    return FileUploadIndicator(
      filePath: upload.path,
      progressPercentage: upload.progress,
      status: upload.status,
      onCancel: () => cancelUpload(upload.id),
      onRetry: () => retryUpload(upload.id),
    );
  },
)''',
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _handleCancel(_SimulatedUpload upload) {
    setState(() {
      upload.status = FileUploadStatus.cancelled;
    });
    _showSnackBar('Upload cancelled: ${upload.fileName}');
  }

  void _handleRetry(_SimulatedUpload upload) {
    setState(() {
      upload.status = FileUploadStatus.uploading;
      upload.progress = 0;
    });
    _showSnackBar('Retrying upload: ${upload.fileName}');
  }

  void _startNewUpload(String type) {
    final extensions = {
      'image': ['jpg', 'png', 'gif'],
      'video': ['mp4', 'mov', 'avi'],
      'document': ['pdf', 'docx', 'xlsx'],
    };

    final ext = (extensions[type] ?? ['file']).first;
    final filePath = '/storage/$type/new_file_${DateTime.now().millisecondsSinceEpoch}.$ext';

    setState(() {
      _uploads.insert(
        0,
        _SimulatedUpload(
          filePath: filePath,
          status: FileUploadStatus.uploading,
          progress: 0,
        ),
      );
    });

    _showSnackBar('Started uploading: ${filePath.split('/').last}');
  }

  void _addUploadWithStatus(FileUploadStatus status) {
    final filePath = '/storage/demo/demo_file_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final progress = status == FileUploadStatus.complete
        ? 100.0
        : status == FileUploadStatus.waiting
            ? 0.0
            : 50.0;

    setState(() {
      _uploads.insert(
        0,
        _SimulatedUpload(
          filePath: filePath,
          status: status,
          progress: progress,
        ),
      );
    });

    _showSnackBar('Added upload with status: ${_getStatusName(status)}');
  }

  String _getStatusName(FileUploadStatus status) {
    switch (status) {
      case FileUploadStatus.waiting:
        return 'Waiting';
      case FileUploadStatus.uploading:
        return 'Uploading';
      case FileUploadStatus.paused:
        return 'Paused';
      case FileUploadStatus.complete:
        return 'Complete';
      case FileUploadStatus.error:
        return 'Error';
      case FileUploadStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData _getStatusIcon(FileUploadStatus status) {
    switch (status) {
      case FileUploadStatus.waiting:
        return Icons.hourglass_empty;
      case FileUploadStatus.uploading:
        return Icons.cloud_upload;
      case FileUploadStatus.paused:
        return Icons.pause;
      case FileUploadStatus.complete:
        return Icons.check_circle;
      case FileUploadStatus.error:
        return Icons.error;
      case FileUploadStatus.cancelled:
        return Icons.cancel;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}

/// Simulated upload data
class _SimulatedUpload {
  final String filePath;
  FileUploadStatus status;
  double progress;

  _SimulatedUpload({
    required this.filePath,
    required this.status,
    required this.progress,
  });

  String get fileName => filePath.split('/').last;
}

/// Status label widget
class _StatusLabel extends StatelessWidget {
  final FileUploadStatus status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, text) = switch (status) {
      FileUploadStatus.waiting => (Colors.grey, 'WAITING'),
      FileUploadStatus.uploading => (theme.colorScheme.primary, 'UPLOADING'),
      FileUploadStatus.paused => (Colors.orange, 'PAUSED'),
      FileUploadStatus.complete => (Colors.green, 'COMPLETE'),
      FileUploadStatus.error => (theme.colorScheme.error, 'ERROR'),
      FileUploadStatus.cancelled => (Colors.grey, 'CANCELLED'),
    };

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// Action button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
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

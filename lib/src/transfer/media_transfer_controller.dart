import 'dart:async';

import 'package:transfer_kit/transfer_kit.dart';

/// Centralized cache-first transfer controller for chat media.
class MediaTransferController {
  MediaTransferController._();

  static final MediaTransferController instance = MediaTransferController._();

  FileTaskController get _downloadController => FileTaskController.instance;
  FileManagementSystem get _fileManager => FileManagementSystem.instance;

  /// Ensure the download controller is initialized once.
  Future<void> ensureInitialized() async {
    await _downloadController.initialize();
  }

  /// Create a download task for a URL with optional file name.
  DownloadTask buildDownloadTask({
    required String url,
    String? fileName,
  }) {
    return DownloadTask(
      url: url,
      allowPause: true,
      updates: Updates.statusAndProgress,
      directory: '',
      baseDirectory: BaseDirectory.temporary,
      filename: fileName ?? url.toHashName(),
    );
  }

  /// Cache-first resolution using the download controller's stored paths.
  Future<(String? filePath, StreamController<TaskItem>? streamController)>
      enqueueOrResume(DownloadTask task, {bool autoStart = false}) async {
    await ensureInitialized();
    return _downloadController.enqueueOrResume(task, autoStart);
  }

  /// Stream download updates for a URL.
  Stream<TaskItem> watchDownload(String url) {
    return (_downloadController.getFileController(url) ??
            _downloadController.createFileController(url))
        .stream;
  }

  /// Download task controls.
  Future<bool> startDownload(DownloadTask task) =>
      _downloadController.fileDownloader.enqueue(task);
  Future<bool> pauseDownload(TaskItem item) => _downloadController.pause(item);
  Future<bool> resumeDownload(TaskItem item) => _downloadController.resume(item);
  Future<bool> cancelDownload(TaskItem item) => _downloadController.cancel(item);
  Future<bool> retryDownload(TaskItem item) => _downloadController.retry(item);
  Future<bool> openDownloadedFile(TaskItem item) =>
      _downloadController.openFile(item);

  /// Upload task wrappers (Firebase storage via TransferKit).
  Stream<FileTask> uploadTaskStream({
    required FilePathAndURL filePathAndUrl,
    required String taskId,
    FileGroupInfo? group,
    bool autoStart = true,
  }) =>
      _fileManager.uploadTaskStream(
        filePathAndUrl: filePathAndUrl,
        taskId: taskId,
        group: group,
        autoStart: autoStart,
      );

  Future<FileTask> uploadTask({
    required FilePathAndURL filePathAndUrl,
    required String taskId,
    FileGroupInfo? group,
    bool autoStart = true,
  }) =>
      _fileManager.uploadTask(
        filePathAndUrl: filePathAndUrl,
        taskId: taskId,
        group: group,
        autoStart: autoStart,
      );

  Future<bool> startTask(String taskId) => _fileManager.startTask(taskId);
  Future<bool> pauseTask(String taskId) => _fileManager.pauseTask(taskId);
  Future<bool> resumeTask(String taskId) => _fileManager.resumeTask(taskId);
  Future<bool> cancelTask(String taskId) => _fileManager.cancelTask(taskId);
  Future<bool> retryTask(String taskId) => _fileManager.retryTask(taskId);
}

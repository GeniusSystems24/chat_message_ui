import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_audio_toolkit/flutter_audio_toolkit.dart';
import 'package:path_provider/path_provider.dart';

/// Result of waveform extraction containing amplitude data and metadata.
@immutable
class WaveformResult {
  /// Normalized amplitude values (0.0 to 1.0).
  final List<double> amplitudes;

  /// Duration of the audio in milliseconds.
  final int durationMs;

  /// Sample rate of the audio.
  final int sampleRate;

  /// Number of channels in the audio.
  final int channels;

  const WaveformResult({
    required this.amplitudes,
    required this.durationMs,
    this.sampleRate = 44100,
    this.channels = 1,
  });

  /// Duration in seconds.
  int get durationSeconds => (durationMs / 1000).round();

  /// Creates a copy with modified values.
  WaveformResult copyWith({
    List<double>? amplitudes,
    int? durationMs,
    int? sampleRate,
    int? channels,
  }) {
    return WaveformResult(
      amplitudes: amplitudes ?? this.amplitudes,
      durationMs: durationMs ?? this.durationMs,
      sampleRate: sampleRate ?? this.sampleRate,
      channels: channels ?? this.channels,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaveformResult &&
          runtimeType == other.runtimeType &&
          listEquals(amplitudes, other.amplitudes) &&
          durationMs == other.durationMs;

  @override
  int get hashCode => Object.hash(amplitudes.length, durationMs);
}

/// Configuration options for waveform extraction.
@immutable
class WaveformConfig {
  /// Number of samples per second for waveform extraction.
  /// Higher values provide more detail but larger data.
  final int samplesPerSecond;

  /// Whether to normalize amplitudes to 0.0-1.0 range.
  final bool normalize;

  /// Minimum amplitude threshold (values below are set to this).
  final double minAmplitude;

  /// Maximum number of points in the final waveform.
  /// If null, uses all extracted points.
  final int? maxPoints;

  const WaveformConfig({
    this.samplesPerSecond = 100,
    this.normalize = true,
    this.minAmplitude = 0.05,
    this.maxPoints,
  });

  /// Default configuration for voice messages.
  static const WaveformConfig voiceMessage = WaveformConfig(
    samplesPerSecond: 50,
    maxPoints: 60,
  );

  /// Default configuration for music/audio files.
  static const WaveformConfig musicFile = WaveformConfig(
    samplesPerSecond: 100,
    maxPoints: 100,
  );

  /// High quality configuration for detailed visualization.
  static const WaveformConfig highQuality = WaveformConfig(
    samplesPerSecond: 200,
    maxPoints: 150,
  );
}

/// Callback for progress updates during extraction.
typedef WaveformProgressCallback = void Function(double progress);

/// Service for extracting waveform data from audio files.
///
/// This service uses flutter_audio_toolkit for native audio processing
/// and provides methods for extracting waveform data from both local
/// files and network URLs.
///
/// Example usage:
/// ```dart
/// final extractor = WaveformExtractor();
///
/// // Extract from local file
/// final result = await extractor.extractFromFile(
///   '/path/to/audio.mp3',
///   onProgress: (progress) => print('Progress: ${progress * 100}%'),
/// );
///
/// // Extract from URL
/// final networkResult = await extractor.extractFromUrl(
///   'https://example.com/audio.mp3',
/// );
///
/// // Use the waveform data
/// print('Amplitudes: ${result.amplitudes.length} points');
/// print('Duration: ${result.durationSeconds} seconds');
/// ```
class WaveformExtractor {
  final FlutterAudioToolkit _toolkit;

  /// Cache for extracted waveforms.
  static final Map<String, WaveformResult> _cache = {};

  /// Whether to use caching.
  final bool enableCache;

  WaveformExtractor({
    FlutterAudioToolkit? toolkit,
    this.enableCache = true,
  }) : _toolkit = toolkit ?? FlutterAudioToolkit();

  /// Extracts waveform data from a local audio file.
  ///
  /// [filePath] - Path to the audio file.
  /// [config] - Configuration options for extraction.
  /// [onProgress] - Optional callback for progress updates.
  ///
  /// Returns [WaveformResult] containing amplitude data and metadata.
  /// Throws [WaveformExtractionException] if extraction fails.
  Future<WaveformResult> extractFromFile(
    String filePath, {
    WaveformConfig config = const WaveformConfig(),
    WaveformProgressCallback? onProgress,
  }) async {
    // Check cache first
    final cacheKey = _generateCacheKey(filePath, config);
    if (enableCache && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Verify file exists
    final file = File(filePath);
    if (!await file.exists()) {
      throw WaveformExtractionException(
        'Audio file not found: $filePath',
        WaveformExtractionError.fileNotFound,
      );
    }

    try {
      final waveformData = await _toolkit.extractWaveform(
        inputPath: filePath,
        samplesPerSecond: config.samplesPerSecond,
        onProgress: onProgress,
      );

      final result = _processWaveformData(waveformData, config);

      // Cache the result
      if (enableCache) {
        _cache[cacheKey] = result;
      }

      return result;
    } catch (e) {
      throw WaveformExtractionException(
        'Failed to extract waveform: $e',
        WaveformExtractionError.extractionFailed,
      );
    }
  }

  /// Extracts waveform data from a network URL.
  ///
  /// Downloads the audio file to a temporary location and extracts
  /// the waveform data. The temporary file is cleaned up after extraction.
  ///
  /// [url] - URL of the audio file.
  /// [config] - Configuration options for extraction.
  /// [onProgress] - Optional callback for progress updates.
  /// [onDownloadProgress] - Optional callback for download progress.
  ///
  /// Returns [WaveformResult] containing amplitude data and metadata.
  Future<WaveformResult> extractFromUrl(
    String url, {
    WaveformConfig config = const WaveformConfig(),
    WaveformProgressCallback? onProgress,
    WaveformProgressCallback? onDownloadProgress,
  }) async {
    // Check cache first
    final cacheKey = _generateCacheKey(url, config);
    if (enableCache && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    final fileName = _getFileNameFromUrl(url);
    final localPath = '${tempDir.path}/waveform_$fileName';

    try {
      final waveformData = await _toolkit.extractWaveformFromUrl(
        url: url,
        localPath: localPath,
        samplesPerSecond: config.samplesPerSecond,
        onProgress: onProgress,
        onDownloadProgress: onDownloadProgress,
      );

      final result = _processWaveformData(waveformData, config);

      // Cache the result
      if (enableCache) {
        _cache[cacheKey] = result;
      }

      return result;
    } catch (e) {
      throw WaveformExtractionException(
        'Failed to extract waveform from URL: $e',
        WaveformExtractionError.networkError,
      );
    } finally {
      // Clean up temporary file
      final tempFile = File(localPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// Extracts waveform and returns a stream for real-time updates.
  ///
  /// Useful for showing progress in UI while extraction is ongoing.
  Stream<WaveformExtractionProgress> extractFromFileStream(
    String filePath, {
    WaveformConfig config = const WaveformConfig(),
  }) async* {
    final cacheKey = _generateCacheKey(filePath, config);
    if (enableCache && _cache.containsKey(cacheKey)) {
      yield WaveformExtractionProgress(
        progress: 1.0,
        result: _cache[cacheKey],
        isComplete: true,
      );
      return;
    }

    final file = File(filePath);
    if (!await file.exists()) {
      yield WaveformExtractionProgress(
        progress: 0.0,
        error: WaveformExtractionException(
          'Audio file not found: $filePath',
          WaveformExtractionError.fileNotFound,
        ),
        isComplete: true,
      );
      return;
    }

    final completer = Completer<WaveformResult>();
    double currentProgress = 0.0;

    _toolkit.extractWaveform(
      inputPath: filePath,
      samplesPerSecond: config.samplesPerSecond,
      onProgress: (progress) {
        currentProgress = progress;
      },
    ).then((waveformData) {
      final result = _processWaveformData(waveformData, config);
      if (enableCache) {
        _cache[cacheKey] = result;
      }
      completer.complete(result);
    }).catchError((e) {
      completer.completeError(WaveformExtractionException(
        'Failed to extract waveform: $e',
        WaveformExtractionError.extractionFailed,
      ));
    });

    // Yield progress updates
    while (!completer.isCompleted) {
      yield WaveformExtractionProgress(
        progress: currentProgress,
        isComplete: false,
      );
      await Future.delayed(const Duration(milliseconds: 100));
    }

    try {
      final result = await completer.future;
      yield WaveformExtractionProgress(
        progress: 1.0,
        result: result,
        isComplete: true,
      );
    } catch (e) {
      yield WaveformExtractionProgress(
        progress: currentProgress,
        error: e is WaveformExtractionException
            ? e
            : WaveformExtractionException(
                'Failed to extract waveform: $e',
                WaveformExtractionError.extractionFailed,
              ),
        isComplete: true,
      );
    }
  }

  /// Processes raw waveform data into a [WaveformResult].
  WaveformResult _processWaveformData(
    WaveformData waveformData,
    WaveformConfig config,
  ) {
    List<double> amplitudes = waveformData.amplitudes.toList();

    // Apply minimum amplitude threshold
    amplitudes = amplitudes.map((a) {
      if (a < config.minAmplitude) return config.minAmplitude;
      return a;
    }).toList();

    // Downsample if maxPoints is specified
    if (config.maxPoints != null && amplitudes.length > config.maxPoints!) {
      amplitudes = _downsample(amplitudes, config.maxPoints!);
    }

    // Normalize if required
    if (config.normalize && amplitudes.isNotEmpty) {
      final maxVal = amplitudes.reduce((a, b) => a > b ? a : b);
      if (maxVal > 0) {
        amplitudes = amplitudes.map((a) => (a / maxVal).clamp(0.0, 1.0)).toList();
      }
    }

    return WaveformResult(
      amplitudes: amplitudes,
      durationMs: waveformData.durationMs,
      sampleRate: waveformData.sampleRate,
      channels: waveformData.channels,
    );
  }

  /// Downsamples the waveform to the target number of points.
  List<double> _downsample(List<double> data, int targetPoints) {
    if (data.length <= targetPoints) return data;

    final result = <double>[];
    final ratio = data.length / targetPoints;

    for (int i = 0; i < targetPoints; i++) {
      final start = (i * ratio).floor();
      final end = ((i + 1) * ratio).floor().clamp(start + 1, data.length);

      // Take the maximum value in the range for better visual representation
      double maxVal = data[start];
      for (int j = start + 1; j < end; j++) {
        if (data[j] > maxVal) maxVal = data[j];
      }
      result.add(maxVal);
    }

    return result;
  }

  /// Generates a cache key for the given path and config.
  String _generateCacheKey(String path, WaveformConfig config) {
    return '$path:${config.samplesPerSecond}:${config.maxPoints}';
  }

  /// Extracts file name from URL.
  String _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    }
    return '${DateTime.now().millisecondsSinceEpoch}.tmp';
  }

  /// Clears the waveform cache.
  static void clearCache() {
    _cache.clear();
  }

  /// Removes a specific entry from the cache.
  static void removeFromCache(String path) {
    _cache.removeWhere((key, _) => key.startsWith(path));
  }

  /// Gets the current cache size.
  static int get cacheSize => _cache.length;
}

/// Progress information during waveform extraction.
@immutable
class WaveformExtractionProgress {
  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// The result if extraction is complete.
  final WaveformResult? result;

  /// Error if extraction failed.
  final WaveformExtractionException? error;

  /// Whether extraction is complete (success or failure).
  final bool isComplete;

  const WaveformExtractionProgress({
    required this.progress,
    this.result,
    this.error,
    required this.isComplete,
  });

  /// Progress as percentage (0-100).
  int get progressPercent => (progress * 100).round();

  /// Whether extraction completed successfully.
  bool get isSuccess => isComplete && result != null && error == null;

  /// Whether extraction failed.
  bool get isError => isComplete && error != null;
}

/// Error types for waveform extraction.
enum WaveformExtractionError {
  fileNotFound,
  invalidFormat,
  extractionFailed,
  networkError,
  permissionDenied,
}

/// Exception thrown when waveform extraction fails.
class WaveformExtractionException implements Exception {
  final String message;
  final WaveformExtractionError errorType;

  WaveformExtractionException(this.message, this.errorType);

  @override
  String toString() => 'WaveformExtractionException: $message';
}

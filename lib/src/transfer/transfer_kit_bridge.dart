import 'package:flutter/foundation.dart';
import 'package:transfer_kit/transfer_kit.dart';

/// Bridge utilities for initializing and accessing TransferKit.
class TransferKitBridge {
  TransferKitBridge._();

  /// Initialize TransferKit directories and optional configuration.
  ///
  /// Must be called by the host app before using download/upload widgets.
  static Future<void> initialize({
    bool enableLogging = false,
    bool cacheEnabled = true,
    int? maxCacheSizeBytes,
    Duration? cacheExpiration,
  }) async {
    await FileManagementConfig.init(
      enableLogging: enableLogging || kDebugMode,
      cacheEnabled: cacheEnabled,
      maxCacheSize: maxCacheSizeBytes,
      cacheExpiration: cacheExpiration,
    );
  }

  /// Shared file management system instance.
  static FileManagementSystem get fileManager => FileManagementSystem.instance;
}

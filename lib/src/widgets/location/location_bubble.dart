import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../adapters/chat_data_models.dart';
import '../../theme/chat_theme.dart';

/// Widget to display a location attachment in a message bubble.
class LocationBubble extends StatelessWidget {
  final ChatLocationData location;
  final ChatThemeData chatTheme;
  final bool isMyMessage;

  const LocationBubble({
    super.key,
    required this.location,
    required this.chatTheme,
    required this.isMyMessage,
  });

  double? get latitude => location.latitude;
  double? get longitude => location.longitude;
  String get locationName => location.name ?? 'Shared Location';
  String get address => location.address ?? '';
  bool get hasValidCoordinates => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    if (!hasValidCoordinates) {
      return _LocationErrorWidget(chatTheme: chatTheme);
    }

    return GestureDetector(
      onTap: () => _openLocationInMaps(),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: chatTheme.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: chatTheme.colors.onSurface.withValues(alpha: 0.2),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Map Placeholder / Icon
            Container(
              height: 120,
              width: double.infinity,
              color: chatTheme.colors.surfaceContainerHigh,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 48,
                    color: chatTheme.colors.primary.withValues(alpha: 0.5),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tap to view',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: chatTheme.colors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            chatTheme.colors.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLocationInMaps() async {
    if (!hasValidCoordinates) return;

    // Fallback to Google Maps URL scheme
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _LocationErrorWidget extends StatelessWidget {
  final ChatThemeData chatTheme;

  const _LocationErrorWidget({required this.chatTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: chatTheme.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chatTheme.colors.onSurface.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_off_outlined,
            color: Colors.red,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Location unavailable',
            style: TextStyle(
              color: chatTheme.colors.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

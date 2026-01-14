import 'package:flutter/material.dart';

enum AttachmentSource {
  cameraImage(Icons.camera_alt_rounded, Colors.purple),
  galleryImage(Icons.image_rounded, Colors.indigo),
  cameraVideo(Icons.video_camera_back_rounded, Colors.blue),
  galleryVideo(Icons.video_collection_rounded, Colors.deepPurple),
  location(Icons.location_on_rounded, Colors.green),
  document(Icons.file_copy_rounded, Colors.blue),
  contact(Icons.contact_page_rounded, Colors.orange),
  voting(Icons.poll_outlined, Colors.deepPurple);

  final IconData icon;
  final Color color;
  const AttachmentSource(this.icon, this.color);
}

class SelectAttachmentSourceActionButton extends StatelessWidget {
  final Map<AttachmentSource, String>? customLabels;

  const SelectAttachmentSourceActionButton({
    super.key,
    this.customLabels,
  });

  String _getLabel(AttachmentSource source) {
    if (customLabels != null && customLabels!.containsKey(source)) {
      return customLabels![source]!;
    }
    // Default labels (English)
    switch (source) {
      case AttachmentSource.cameraImage:
        return 'Camera (Photo)';
      case AttachmentSource.galleryImage:
        return 'Gallery (Photo)';
      case AttachmentSource.cameraVideo:
        return 'Camera (Video)';
      case AttachmentSource.galleryVideo:
        return 'Gallery (Video)';
      case AttachmentSource.location:
        return 'Location';
      case AttachmentSource.document:
        return 'Document';
      case AttachmentSource.contact:
        return 'Contact';
      case AttachmentSource.voting:
        return 'Poll';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Grid options
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: AttachmentSource.values.map((source) {
              return _buildGridItem(
                context: context,
                icon: source.icon,
                label: _getLabel(source),
                color: source.color,
                onTap: () {
                  Navigator.pop(context, source);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

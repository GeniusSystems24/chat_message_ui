import 'package:flutter/material.dart';

class FileIcon extends StatelessWidget {
  final String? fileName;
  final bool withShimmer;
  final Widget? floatingIcon;

  const FileIcon({
    super.key,
    required this.fileName,
    this.withShimmer = false,
    this.floatingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final (iconData, iconColor) = _getIconAndColor(fileName);

    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        if (floatingIcon != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: floatingIcon!,
            ),
          ),
      ],
    );
  }

  (IconData, Color) _getIconAndColor(String? name) {
    if (name == null) return (Icons.insert_drive_file, Colors.grey);

    final extension = name.split('.').last.toLowerCase();

    return switch (extension) {
      'pdf' => (Icons.picture_as_pdf, Colors.red),
      'doc' || 'docx' => (Icons.description, Colors.blue),
      'xls' || 'xlsx' => (Icons.table_chart, Colors.green),
      'ppt' || 'pptx' => (Icons.slideshow, Colors.orange),
      'jpg' || 'jpeg' || 'png' || 'gif' => (Icons.image, Colors.purple),
      'mp3' || 'wav' || 'aac' => (Icons.audio_file, Colors.teal),
      'mp4' || 'mov' || 'avi' => (Icons.video_file, Colors.pink),
      'zip' || 'rar' => (Icons.folder_zip, Colors.amber),
      'txt' => (Icons.text_snippet, Colors.grey),
      _ => (Icons.insert_drive_file, Colors.indigo),
    };
  }
}

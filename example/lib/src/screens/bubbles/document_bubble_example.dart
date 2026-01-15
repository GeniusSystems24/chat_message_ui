import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing all DocumentBubble features and properties.
class DocumentBubbleExample extends StatelessWidget {
  const DocumentBubbleExample({super.key});

  static const String _sampleDocUrl =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/0106%D8%B9%D9%84%D9%88%D9%85%20%D8%B5%D9%81%20%D8%A7%D9%88%D9%84%20%D8%AC%D8%B2%D8%A1%201.pdf?alt=media&token=9c0c552c-bc33-4bd9-9c5b-3a287ef7794d';

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.light();

    return ExampleScaffold(
      title: 'DocumentBubble',
      subtitle: 'Document/file attachment widget',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Display file attachments with type-specific icons',
            icon: Icons.attach_file_outlined,
          ),
          const SizedBox(height: 16),

          // PDF Document
          DemoContainer(
            title: 'PDF Document',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_1',
                fileName: 'Project-Proposal.pdf',
                fileSize: 2457600, // 2.4 MB
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // Different File Types
          const ExampleSectionHeader(
            title: 'File Type Icons',
            description: 'Icons automatically adapt to file extension',
            icon: Icons.folder_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Word Document (.docx)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_2',
                fileName: 'Meeting-Notes.docx',
                fileSize: 524288, // 512 KB
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Excel Spreadsheet (.xlsx)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_3',
                fileName: 'Budget-2024.xlsx',
                fileSize: 1048576, // 1 MB
              ),
              chatTheme: chatTheme,
              isMyMessage: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'PowerPoint (.pptx)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_4',
                fileName: 'Presentation.pptx',
                fileSize: 5242880, // 5 MB
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'ZIP Archive (.zip)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_5',
                fileName: 'Project-Files.zip',
                fileSize: 15728640, // 15 MB
              ),
              chatTheme: chatTheme,
              isMyMessage: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Text File (.txt)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_6',
                fileName: 'readme.txt',
                fileSize: 4096, // 4 KB
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // Sender Variations
          const ExampleSectionHeader(
            title: 'Message Direction',
            description: 'Different styling for sent/received',
            icon: Icons.swap_horiz_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Received (isMyMessage: false)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_7',
                fileName: 'Received-File.pdf',
                fileSize: 1024000,
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Sent (isMyMessage: true)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_8',
                fileName: 'Sent-File.pdf',
                fileSize: 1024000,
              ),
              chatTheme: chatTheme,
              isMyMessage: true,
            ),
          ),
          const SizedBox(height: 24),

          // File Sizes
          const ExampleSectionHeader(
            title: 'File Size Formatting',
            description: 'Automatic size unit conversion',
            icon: Icons.storage_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Small File (500 B)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_9',
                fileName: 'tiny.txt',
                fileSize: 500,
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Medium File (2.5 MB)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_10',
                fileName: 'medium.pdf',
                fileSize: 2621440,
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Large File (1.2 GB)',
            child: DocumentBubble(
              message: _createDocMessage(
                id: 'doc_11',
                fileName: 'large-video.mp4',
                fileSize: 1288490188,
              ),
              chatTheme: chatTheme,
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available DocumentBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'Message data with document info',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'chatTheme',
            value: 'ChatThemeData',
            description: 'Theme configuration for styling',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isMyMessage',
            value: 'bool',
            description: 'Affects background color',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onTap',
            value: 'VoidCallback?',
            description: 'Custom tap handler (default: open URL)',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''DocumentBubble(
  message: message,
  chatTheme: ChatThemeData.light(),
  isMyMessage: false,
  onTap: () => downloadFile(message.mediaData?.url),
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createDocMessage({
    required String id,
    required String fileName,
    required int fileSize,
  }) {
    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: 'user_1',
      type: ChatMessageType.document,
      textContent: fileName,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
      mediaData: ChatMediaData(
        url: _sampleDocUrl,
        mediaType: ChatMessageType.document,
        fileName: fileName,
        fileSize: fileSize,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../shared/example_scaffold.dart';

/// Example screen showcasing all ContactBubble features and properties.
class ContactBubbleExample extends StatelessWidget {
  const ContactBubbleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'ContactBubble',
      subtitle: 'Contact card display widget',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.contact_phone_outlined,
            lines: [
              'Showcases contact cards with phone and email fields.',
              'Demonstrates name formatting and partial data handling.',
              'Validates sent/received styles for contact bubbles.',
            ],
          ),
          const SizedBox(height: 16),
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Display contact information with tap-to-call',
            icon: Icons.contact_phone_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Contact
          DemoContainer(
            title: 'Basic Contact Card',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'John Smith',
                phone: '+1 415 555 0123',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // With Email
          const ExampleSectionHeader(
            title: 'Contact with Email',
            description: 'Phone and email information',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Phone + Email',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Sarah Johnson',
                phone: '+1 212 555 0456',
                email: 'sarah.johnson@example.com',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // Different Name Formats
          const ExampleSectionHeader(
            title: 'Name Variations',
            description: 'Various contact name formats',
            icon: Icons.person_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Full Name',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Dr. Mohammed Al-Rashid',
                phone: '+971 50 123 4567',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Short Name',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Ali',
                phone: '+20 100 123 4567',
              ),
              isMyMessage: true,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Long Name (Truncated)',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Alexander Christopher Hamilton III',
                phone: '+44 20 7946 0958',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // Phone Number Formats
          const ExampleSectionHeader(
            title: 'Phone Number Formats',
            description: 'International phone formats',
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'US Format',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'US Contact',
                phone: '+1 (555) 123-4567',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'UK Format',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'UK Contact',
                phone: '+44 7911 123456',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'UAE Format',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'UAE Contact',
                phone: '+971 50 123 4567',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 24),

          // Missing Information
          const ExampleSectionHeader(
            title: 'Partial Information',
            description: 'Contacts with missing fields',
            icon: Icons.warning_amber_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'No Phone Number',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Email Only Contact',
                email: 'contact@example.com',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Name Only',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Name Only Contact',
              ),
              isMyMessage: true,
            ),
          ),
          const SizedBox(height: 24),

          // Sender Variations
          const ExampleSectionHeader(
            title: 'Message Direction',
            description: 'Received vs sent styling',
            icon: Icons.swap_horiz_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Received Contact',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Shared Contact',
                phone: '+1 555 0100',
              ),
              isMyMessage: false,
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Sent Contact',
            child: ContactBubble(
              contact: const ChatContactData(
                name: 'Shared Contact',
                phone: '+1 555 0100',
              ),
              isMyMessage: true,
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available ContactBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'contact',
            value: 'ChatContactData',
            description: 'Contact data (name, phone, email)',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isMyMessage',
            value: 'bool',
            description: 'Whether message is from current user',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'backgroundColor',
            value: 'Color?',
            description: 'Custom background color',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'textColor',
            value: 'Color?',
            description: 'Custom text color',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''ContactBubble(
  contact: ChatContactData(
    name: 'John Doe',
    phone: '+1 555 123 4567',
    email: 'john@example.com',
  ),
  isMyMessage: false,
  backgroundColor: Colors.white,
  textColor: Colors.black87,
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

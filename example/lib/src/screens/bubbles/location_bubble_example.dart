import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../shared/example_scaffold.dart';

/// Example screen showcasing all LocationBubble features and properties.
class LocationBubbleExample extends StatelessWidget {
  const LocationBubbleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.light();

    return ExampleScaffold(
      title: 'LocationBubble',
      subtitle: 'Location sharing widget',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Share locations with map preview and tap-to-open',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Location
          DemoContainer(
            title: 'Basic Location',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 25.2048,
                  longitude: 55.2708,
                  name: 'Dubai Mall',
                  address: 'Downtown Dubai, UAE',
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Famous Locations
          const ExampleSectionHeader(
            title: 'World Landmarks',
            description: 'Example locations from around the world',
            icon: Icons.public_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Eiffel Tower, Paris',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 48.8584,
                  longitude: 2.2945,
                  name: 'Eiffel Tower',
                  address: 'Champ de Mars, Paris, France',
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Times Square, NYC',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 40.7580,
                  longitude: -73.9855,
                  name: 'Times Square',
                  address: 'Manhattan, New York City, USA',
                ),
                chatTheme: chatTheme,
                isMyMessage: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Tokyo Tower, Japan',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 35.6586,
                  longitude: 139.7454,
                  name: 'Tokyo Tower',
                  address: 'Minato City, Tokyo, Japan',
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Address Variations
          const ExampleSectionHeader(
            title: 'Address Formats',
            description: 'Different address information levels',
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Full Address',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 51.5074,
                  longitude: -0.1278,
                  name: 'Big Ben',
                  address: 'Westminster, London SW1A 0AA, United Kingdom',
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Short Address',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 40.6892,
                  longitude: -74.0445,
                  name: 'Statue of Liberty',
                  address: 'New York',
                ),
                chatTheme: chatTheme,
                isMyMessage: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'No Address',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 27.1751,
                  longitude: 78.0421,
                  name: 'Taj Mahal',
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Name Only
          const ExampleSectionHeader(
            title: 'Minimal Information',
            description: 'Coordinates with minimal details',
            icon: Icons.pin_drop_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Coordinates Only',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 35.6762,
                  longitude: 139.6503,
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
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
            title: 'Received Location',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 25.2048,
                  longitude: 55.2708,
                  name: 'Meeting Point',
                  address: 'Downtown Dubai',
                ),
                chatTheme: chatTheme,
                isMyMessage: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Sent Location',
            child: Center(
              child: LocationBubble(
                location: const ChatLocationData(
                  latitude: 25.2048,
                  longitude: 55.2708,
                  name: 'Meeting Point',
                  address: 'Downtown Dubai',
                ),
                chatTheme: chatTheme,
                isMyMessage: true,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available LocationBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'location',
            value: 'ChatLocationData',
            description: 'Location data (lat, lng, name, address)',
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
            description: 'Whether message is from current user',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'Usage Example',
            code: '''LocationBubble(
  location: ChatLocationData(
    latitude: 25.2048,
    longitude: 55.2708,
    name: 'Dubai Mall',
    address: 'Downtown Dubai, UAE',
  ),
  chatTheme: ChatThemeData.light(),
  isMyMessage: false,
)''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

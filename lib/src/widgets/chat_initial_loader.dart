import 'package:flutter/material.dart';

/// A loading indicator widget for the initial chat load.
class ChatInitialLoader extends StatelessWidget {
  /// Custom loading widget to display.
  final Widget? child;

  const ChatInitialLoader({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child ??
          const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
    );
  }
}

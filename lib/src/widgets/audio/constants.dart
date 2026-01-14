part of 'audio_bubble.dart';

/// Constants for audio bubble styling and configuration.
abstract class AudioBubbleConstants {
  // Container styling
  static const double maxWidthFactor = 0.7;
  static const double minWidth = 220.0;
  static const double horizontalPadding = 12.0;
  static const double verticalPadding = 8.0;
  static const double borderRadius = 8.0;

  // Button styling
  static const double playButtonSize = 40.0;
  static const double playIconSize = 20.0;
  static const double micIconSize = 18.0;

  // Waveform styling
  static const double waveformHeight = 15.0;

  // Progress and loading
  static const double progressIndicatorSize = 20.0;
  static const double progressStrokeWidth = 2.0;

  // Spacing
  static const double spacing = 12.0;
  static const double smallSpacing = 6.0;
  static const double microSpacing = 8.0;

  // Typography
  static const double durationFontSize = 12.0;

  // Opacity values
  static const double opacitySecondary = 0.3;
  static const double opacityDimmed = 0.7;
  static const double opacityLight = 0.6;
  static const double opacityButton = 0.1;

  // Waveform configuration
  static const int minWaveformPoints = 50;
}

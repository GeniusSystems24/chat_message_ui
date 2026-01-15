part of 'chat_input.dart';

/// Constants for recording waveform styling.
abstract class RecordingWaveformConstants {
  static const double defaultHeight = 32.0;
  static const double barWidth = 3.0;
  static const double barSpacing = 2.0;
  static const double minBarHeight = 4.0;
  static const double maxBarHeightFactor = 0.85;
  static const int maxBars = 50;
  static const Duration animationDuration = Duration(milliseconds: 100);
}

/// A widget that displays a real-time waveform visualization during audio recording.
///
/// Uses amplitude values from the audio recorder to create an animated
/// waveform that updates in real-time as the user records.
class RecordingWaveform extends StatefulWidget {
  /// Stream of amplitude values from the recorder.
  final Stream<double>? amplitudeStream;

  /// Height of the waveform widget.
  final double height;

  /// Color for active (current) bars.
  final Color? activeColor;

  /// Color for inactive (past) bars.
  final Color? inactiveColor;

  /// Whether recording is paused.
  final bool isPaused;

  /// Maximum number of bars to display.
  final int maxBars;

  const RecordingWaveform({
    super.key,
    this.amplitudeStream,
    this.height = RecordingWaveformConstants.defaultHeight,
    this.activeColor,
    this.inactiveColor,
    this.isPaused = false,
    this.maxBars = RecordingWaveformConstants.maxBars,
  });

  @override
  State<RecordingWaveform> createState() => _RecordingWaveformState();
}

class _RecordingWaveformState extends State<RecordingWaveform>
    with SingleTickerProviderStateMixin {
  final List<double> _amplitudes = [];
  StreamSubscription<double>? _amplitudeSubscription;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _subscribeToAmplitude();
  }

  @override
  void didUpdateWidget(RecordingWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amplitudeStream != oldWidget.amplitudeStream) {
      _amplitudeSubscription?.cancel();
      _subscribeToAmplitude();
    }

    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _pulseController.stop();
      } else {
        _pulseController.repeat(reverse: true);
      }
    }
  }

  void _subscribeToAmplitude() {
    _amplitudeSubscription = widget.amplitudeStream?.listen((amplitude) {
      if (!widget.isPaused && mounted) {
        setState(() {
          _amplitudes.add(amplitude);
          // Keep only the last maxBars amplitudes
          if (_amplitudes.length > widget.maxBars) {
            _amplitudes.removeAt(0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor = widget.inactiveColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.3);

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return CustomPaint(
            size: Size(double.infinity, widget.height),
            painter: _RecordingWaveformPainter(
              amplitudes: _amplitudes,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isPaused: widget.isPaused,
              pulseValue: _pulseController.value,
              maxBars: widget.maxBars,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for the recording waveform visualization.
class _RecordingWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color activeColor;
  final Color inactiveColor;
  final bool isPaused;
  final double pulseValue;
  final int maxBars;

  _RecordingWaveformPainter({
    required this.amplitudes,
    required this.activeColor,
    required this.inactiveColor,
    required this.isPaused,
    required this.pulseValue,
    required this.maxBars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) {
      _drawIdleBars(canvas, size);
      return;
    }

    final barWidth = RecordingWaveformConstants.barWidth;
    final barSpacing = RecordingWaveformConstants.barSpacing;
    final totalBarWidth = barWidth + barSpacing;
    final centerY = size.height / 2;
    final maxBarHeight = size.height * RecordingWaveformConstants.maxBarHeightFactor;

    // Calculate starting position to right-align bars
    final totalWidth = amplitudes.length * totalBarWidth;
    final startX = size.width - totalWidth;

    for (int i = 0; i < amplitudes.length; i++) {
      final x = startX + (i * totalBarWidth);
      final amplitude = amplitudes[i];

      // Calculate bar height based on amplitude
      double barHeight = (amplitude * maxBarHeight).clamp(
        RecordingWaveformConstants.minBarHeight,
        maxBarHeight,
      );

      // Add subtle pulse effect to the last few bars when not paused
      final isRecent = i >= amplitudes.length - 3;
      if (!isPaused && isRecent) {
        barHeight *= (1.0 + pulseValue * 0.1);
      }

      // Determine color - recent bars are active colored
      final color = isRecent && !isPaused
          ? activeColor
          : activeColor.withValues(alpha: 0.6);

      final paint = Paint()
        ..color = color
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  /// Draw idle bars when there's no amplitude data yet.
  void _drawIdleBars(Canvas canvas, Size size) {
    final barWidth = RecordingWaveformConstants.barWidth;
    final barSpacing = RecordingWaveformConstants.barSpacing;
    final totalBarWidth = barWidth + barSpacing;
    final centerY = size.height / 2;
    final idleBarCount = 10;

    final totalWidth = idleBarCount * totalBarWidth;
    final startX = size.width - totalWidth;

    final paint = Paint()
      ..color = inactiveColor
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < idleBarCount; i++) {
      final x = startX + (i * totalBarWidth);
      // Create a subtle wave pattern for idle state
      final baseHeight = RecordingWaveformConstants.minBarHeight;
      final variation = (i % 3 == 0 ? 2.0 : 0.0) + pulseValue * 2;
      final barHeight = baseHeight + variation;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RecordingWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes ||
        oldDelegate.isPaused != isPaused ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.activeColor != activeColor;
  }
}

/// A compact waveform display for the locked recording state.
/// Shows the full waveform history with a scrolling effect.
class LockedRecordingWaveform extends StatelessWidget {
  /// List of recorded amplitude values.
  final List<double> amplitudes;

  /// Whether recording is paused.
  final bool isPaused;

  /// Height of the waveform.
  final double height;

  /// Color for the waveform bars.
  final Color? color;

  const LockedRecordingWaveform({
    super.key,
    required this.amplitudes,
    this.isPaused = false,
    this.height = 28.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waveColor = color ?? theme.colorScheme.primary;

    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: _LockedWaveformPainter(
          amplitudes: amplitudes,
          color: waveColor,
          isPaused: isPaused,
        ),
      ),
    );
  }
}

/// Painter for the locked recording waveform.
class _LockedWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;
  final bool isPaused;

  _LockedWaveformPainter({
    required this.amplitudes,
    required this.color,
    required this.isPaused,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final barWidth = 2.5;
    final barSpacing = 1.5;
    final totalBarWidth = barWidth + barSpacing;
    final centerY = size.height / 2;
    final maxBarHeight = size.height * 0.8;

    // Calculate how many bars can fit
    final maxBars = (size.width / totalBarWidth).floor();

    // Get the most recent amplitudes that fit in the view
    final displayAmplitudes = amplitudes.length > maxBars
        ? amplitudes.sublist(amplitudes.length - maxBars)
        : amplitudes;

    // Draw from left to right
    for (int i = 0; i < displayAmplitudes.length; i++) {
      final x = i * totalBarWidth + barSpacing / 2;
      final amplitude = displayAmplitudes[i];

      final barHeight = (amplitude * maxBarHeight).clamp(3.0, maxBarHeight);

      final paint = Paint()
        ..color = isPaused ? color.withValues(alpha: 0.5) : color
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LockedWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes.length != amplitudes.length ||
        oldDelegate.isPaused != isPaused ||
        oldDelegate.color != color;
  }
}

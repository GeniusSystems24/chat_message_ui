part of 'audio_bubble.dart';

/// Waveform rendering mode.
enum WaveformType { recording, playing, paused, static }

/// Simple waveform painter with progress coloring.
class AudioWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final double progress;
  final WaveformType type;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;
  final int targetPoints;

  const AudioWaveformPainter({
    required this.amplitudes,
    required this.progress,
    required this.type,
    required this.primaryColor,
    required this.secondaryColor,
    this.strokeWidth = 3.0,
    this.targetPoints = 60,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) {
      return;
    }

    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    final barCount = math.min(amplitudes.length, targetPoints);
    final barWidth = width / barCount;
    final barSpacing = barWidth * 0.3;
    final actualBarWidth = barWidth - barSpacing;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barSpacing / 2;
      final amplitudeIndex = (i * amplitudes.length / barCount).floor();
      final amplitude = amplitudes[amplitudeIndex];
      final barHeight = _calculateBarHeight(amplitude, height);
      final barProgress = i / barCount;

      final isActive = barProgress <= progress;
      final color = isActive
          ? primaryColor
          : secondaryColor.withValues(alpha: 0.6);

      final paint = Paint()
        ..color = color
        ..strokeWidth = actualBarWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }

    if (type == WaveformType.playing) {
      final progressX = (size.width * progress).clamp(0.0, size.width);
      final linePaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(progressX, 0),
        Offset(progressX, size.height),
        linePaint,
      );
    }
  }

  double _calculateBarHeight(double amplitude, double maxHeight) {
    const minHeight = 4.0;
    final maxBarHeight = maxHeight * 0.85;
    final calculatedHeight = amplitude * maxBarHeight;
    final clampedHeight = math.max(minHeight, calculatedHeight);
    return math.min(clampedHeight, maxHeight);
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes ||
        oldDelegate.progress != progress ||
        oldDelegate.type != type ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}

/// Basic waveform data generator.
class WaveformDataGenerator {
  static List<double> generateRandomWaveform(int pointCount) {
    final random = math.Random();
    return List.generate(pointCount, (index) {
      final baseWave = math.sin(index * 0.3) * 0.5;
      final noise = (random.nextDouble() - 0.5) * 0.3;
      final amplitude = (baseWave + noise + 0.5).clamp(0.1, 1.0);
      return amplitude;
    });
  }
}

/// Interactive waveform widget with tap/drag seek support.
class InteractiveAudioWaveform extends StatelessWidget {
  final List<double> amplitudes;
  final double progress;
  final WaveformType type;
  final double height;
  final Color primaryColor;
  final Color secondaryColor;
  final Function(double position)? onSeek;
  final bool interactive;

  const InteractiveAudioWaveform({
    super.key,
    required this.amplitudes,
    required this.progress,
    required this.type,
    required this.height,
    required this.primaryColor,
    required this.secondaryColor,
    this.onSeek,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: interactive
          ? (details) => _handleTapDown(context, details)
          : null,
      onHorizontalDragUpdate: interactive
          ? (details) => _handleDragUpdate(context, details)
          : null,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          size: Size(double.infinity, height),
          painter: AudioWaveformPainter(
            amplitudes: amplitudes,
            progress: progress,
            type: type,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        ),
      ),
    );
  }

  void _handleTapDown(BuildContext context, TapDownDetails details) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final local = renderBox.globalToLocal(details.globalPosition);
    final progressValue = (local.dx / renderBox.size.width).clamp(0.0, 1.0);
    onSeek?.call(progressValue);
  }

  void _handleDragUpdate(BuildContext context, DragUpdateDetails details) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final local = renderBox.globalToLocal(details.globalPosition);
    final progressValue = (local.dx / renderBox.size.width).clamp(0.0, 1.0);
    onSeek?.call(progressValue);
  }
}

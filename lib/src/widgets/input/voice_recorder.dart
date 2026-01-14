part of 'chat_input.dart';

/// Professional WhatsApp-style voice recorder button
class WhatsAppVoiceRecorder extends StatefulWidget {
  /// Callback when recording starts
  final VoidCallback? onRecordingStart;

  /// Callback when recording stops with file path
  final Function(String filePath, int duration)? onRecordingComplete;

  /// Callback when recording is cancelled
  final VoidCallback? onRecordingCancel;

  /// Callback when recording is locked
  final ValueChanged<bool>? onRecordingLockedChanged;

  /// Size of the record button
  final double size;

  /// Whether recording is enabled
  final bool enabled;

  /// Get recording path
  final String Function()? getRecordingPath;

  const WhatsAppVoiceRecorder({
    super.key,
    this.onRecordingStart,
    this.onRecordingComplete,
    this.onRecordingCancel,
    this.onRecordingLockedChanged,
    this.size = 55.0,
    this.enabled = true,
    this.getRecordingPath,
  });

  @override
  State<WhatsAppVoiceRecorder> createState() => _WhatsAppVoiceRecorderState();
}

class _WhatsAppVoiceRecorderState extends State<WhatsAppVoiceRecorder>
    with SingleTickerProviderStateMixin {
  // Core state
  late bool isRTL;
  bool isLocked = false;
  bool showLottie = false;
  bool isRecording = false;
  bool isPaused = false;

  // Recording state
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentRecordingPath;
  DateTime? startTime;
  Timer? timer;
  int durationInSeconds = 0;

  String get recordDurationString =>
      "${durationInSeconds ~/ 60}:${durationInSeconds % 60}";

  // Animation controllers
  AnimationController? animController;
  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  // UI measurements
  final double borderRadius = 27;
  final double lockerHeight = 200;
  final double defaultPadding = 8;
  double timerWidth = 0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    // Defer RTL check to didChangeDependencies
  }

  void _initAnimations() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: animController!,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );

    animController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isRTL = Directionality.of(context) == TextDirection.rtl;
    timerWidth = MediaQuery.of(context).size.width - 2 * defaultPadding - 4;

    timerAnimation =
        Tween<double>(begin: timerWidth + defaultPadding, end: 0).animate(
      CurvedAnimation(
        parent: animController!,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );

    lockerAnimation =
        Tween<double>(begin: lockerHeight + defaultPadding, end: 0).animate(
      CurvedAnimation(
        parent: animController!,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.dispose();
    animController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var stack = Stack(
      clipBehavior: Clip.none,
      children: [_buildLockSlider(), _buildCancelSlider(), _buildAudioButton()],
    );

    if (!isLocked) return stack;

    return _buildTimerLocked();
  }

  Widget _buildLockSlider() {
    final theme = Theme.of(context);
    return Positioned(
      bottom: -lockerAnimation.value,
      child: Container(
        height: lockerHeight,
        width: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FaIcon(
              FontAwesomeIcons.lock,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            FlowShader(
              direction: Axis.vertical,
              flowColors: [
                theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                theme.colorScheme.primary,
              ],
              child: Column(
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelSlider() {
    final theme = Theme.of(context);
    return PositionedDirectional(
      end: timerAnimation.value + 12,
      child: Container(
        height: widget.size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              showLottie
                  ? const AddToTrashOnCancelLottieAnimation()
                  : _buildDurationText(),
              FlowShader(
                direction: Axis.horizontal,
                duration: const Duration(seconds: 3),
                flowColors: [
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  theme.colorScheme.primary,
                ],
                child: Row(
                  children: [
                    Icon(
                      isRTL
                          ? Icons.keyboard_arrow_right
                          : Icons.keyboard_arrow_left,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      'Slide to cancel', // Localize this later
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: widget.size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationText() {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Recording indicator dot
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isPaused ? Colors.orange : Colors.red,
            shape: BoxShape.circle,
          ),
        )
            .animate(
              onPlay: (controller) => isPaused ? null : controller.repeat(),
            )
            .fadeIn(duration: 500.ms)
            .then()
            .fadeOut(duration: 500.ms),
        const SizedBox(width: 8),
        Text(
          recordDurationString,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isPaused ? Colors.orange : Colors.green,
          ),
        ),
        if (isPaused) ...[
          const SizedBox(width: 8),
          const Icon(Icons.pause_circle_filled, size: 16, color: Colors.orange),
        ],
      ],
    );
  }

  Widget _buildTimerLocked() {
    final theme = Theme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width - 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Delete button
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 0.0),
            child: IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: () async => await _cancelRecordingAndDeleteFile(0),
            ),
          ),

          // Pause/Resume button
          IconButton(
            onPressed: () async {
              if (isPaused) {
                await _resumeRecording();
              } else {
                await _pauseRecording();
              }
            },
            icon: Icon(
              isPaused ? Icons.play_arrow : Icons.pause,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              foregroundColor: theme.colorScheme.onSurfaceVariant,
              minimumSize: const Size(40, 40),
            ),
          ),

          // Duration display
          _buildDurationText(),

          // Send button
          Container(
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: IconButton(
              onPressed: () async {
                setState(() {
                  isLocked = false;
                  isRecording = false;
                  isPaused = false;
                });
                await _stopRecordingAndSave();
              },
              icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioButton() {
    final theme = Theme.of(context);
    return GestureDetector(
      onLongPressDown: (_) {
        if (widget.enabled) {
          animController!.forward();
        }
      },
      onLongPressEnd: (details) async {
        if (!widget.enabled) return;

        bool cancelled = _isCancelled(details.localPosition);
        if (cancelled) {
          await _cancelRecordingAndDeleteFile(1440);
        } else if (_checkIsLocked(details.localPosition)) {
          widget.onRecordingLockedChanged?.call(true);
          animController!.reverse();
          HapticFeedback.heavyImpact();
          setState(() {
            isLocked = true;
          });
        } else {
          await _stopRecordingAndSave();
        }
      },
      onLongPressCancel: () {
        animController!.reverse();
      },
      onLongPress: () async {
        if (!widget.enabled) return;

        bool hasPermission = await _recorder.hasPermission();
        if (hasPermission) {
          await _startRecording();
          HapticFeedback.mediumImpact();
        }
      },
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: Container(
          height: widget.size,
          width: widget.size,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary,
          ),
          child: Icon(Icons.mic, color: theme.colorScheme.onPrimary, size: 24),
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) return;

      // Generate file path

      _currentRecordingPath = widget.getRecordingPath?.call() ??
          '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentRecordingPath!,
      );

      durationInSeconds = 0;
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!isRecording || isPaused) return;
        setState(() {
          durationInSeconds++;
        });
      });

      setState(() {
        isRecording = true;
        isPaused = false;
      });

      widget.onRecordingStart?.call();
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _pauseRecording() async {
    try {
      await _recorder.pause();
      timer?.cancel();
      setState(() {
        isPaused = true;
      });
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error pausing recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _recorder.resume();
      // Resume timer
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!isRecording || isPaused) return;
        setState(() {
          durationInSeconds++;
        });
      });
      setState(() {
        isPaused = false;
      });
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error resuming recording: $e');
    }
  }

  Future<void> _stopRecordingAndSave() async {
    try {
      animController!.reverse();
      HapticFeedback.lightImpact();

      final currentDuration = durationInSeconds;
      timer?.cancel();
      timer = null;
      startTime = null;
      durationInSeconds = 0;

      setState(() {
        isRecording = false;
        isPaused = false;
      });

      final filePath = await _recorder.stop();

      if (filePath != null && widget.onRecordingComplete != null) {
        widget.onRecordingComplete!(filePath, currentDuration);
        widget.onRecordingLockedChanged?.call(false);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _cancelRecordingAndDeleteFile(int delay) async {
    widget.onRecordingCancel?.call();
    widget.onRecordingLockedChanged?.call(false);
    HapticFeedback.heavyImpact();

    timer?.cancel();
    timer = null;
    startTime = null;
    durationInSeconds = 0;

    setState(() {
      showLottie = true;
      isRecording = false;
      isPaused = false;
      isLocked = false;
    });

    Timer(Duration(milliseconds: delay), () async {
      animController!.reverse();

      final filePath = await _recorder.stop();
      if (filePath != null) {
        await File(filePath).delete();
      }

      setState(() {
        showLottie = false;
      });
    });
  }

  bool _checkIsLocked(Offset offset) {
    return offset.dy < -35;
  }

  bool _isCancelled(Offset offset) {
    if (isRTL) {
      return offset.dx > (MediaQuery.of(context).size.width * 0.2);
    }
    return offset.dx < -(MediaQuery.of(context).size.width * 0.2);
  }
}

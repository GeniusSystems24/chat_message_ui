import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AddToTrashOnCancelLottieAnimation extends StatefulWidget {
  final String assetPath;

  const AddToTrashOnCancelLottieAnimation({
    super.key,
    this.assetPath = 'assets/lottie_anim/dustbin_grey.json',
  });

  @override
  State<AddToTrashOnCancelLottieAnimation> createState() =>
      _AddToTrashOnCancelLottieAnimationState();
}

class _AddToTrashOnCancelLottieAnimationState
    extends State<AddToTrashOnCancelLottieAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Lottie.asset(
        widget.assetPath,
        controller: controller,
        onLoaded: (composition) {
          controller
            ?..duration = composition.duration
            ..forward();
          debugPrint("Lottie Duration: ${composition.duration}");
        },
        height: 40,
        width: 40,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.delete, color: Colors.grey, size: 40);
        },
      ),
    );
  }
}

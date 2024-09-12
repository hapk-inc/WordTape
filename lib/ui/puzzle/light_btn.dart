import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../function/puzzle/notifier.dart';
import '../../function/puzzle/pod.dart';

class LightBtn extends ConsumerWidget {
  const LightBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(selectedDateProvider);
    final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(date));
    return LayoutBuilder(builder: (_, constraint) {
      return SizedBox.square(
        dimension: constraint.maxHeight,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: notifier.found.mistake == null
              ? null
              : Lottie.asset('lottie/bulb.json'),
        ),
      );
    });
  }
}

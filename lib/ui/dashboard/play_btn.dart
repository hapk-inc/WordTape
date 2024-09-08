import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../function/puzzle/notifier.dart';
import '../../function/puzzle/pod.dart';
import '../../model/puzzle.dart';

class PlayBtn extends ConsumerWidget {
  const PlayBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.watch(selectedDateProvider);
    final PuzzleNotifier notifier = ref.read(puzzleNotifierProvider(date));
    bool isStarted = notifier.isStarted;
    return FadeIn(
      delay: const Duration(milliseconds: 2400),
      child: ElevatedButton(
        onPressed: () => context.push('/puzzle', extra: date),
        child: Text(isStarted ? "Continue.." : "Try it out"),
      ),
    );
  }
}

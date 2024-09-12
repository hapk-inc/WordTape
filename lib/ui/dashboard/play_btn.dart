import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../function/puzzle/pod.dart';
import '../../model/found.dart';

class PlayBtn extends ConsumerWidget {
  const PlayBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.watch(selectedDateProvider);
    final Found found =
        ref.watch(foundDateArgProvider(date: date)).value ?? Found(date: date);
    bool isStarted = found.i != 1;
    return FadeIn(
      delay: const Duration(milliseconds: 2400),
      child: ElevatedButton(
        onPressed: () => context.push('/puzzle', extra: date),
        child: Text(isStarted ? "Continue" : "Try it out"),
      ),
    );
  }
}

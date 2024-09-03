import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../function/puzzle/pod.dart';
import '../../model/puzzle.dart';

class PlayButton extends ConsumerWidget {
  final Puzzle? puzzle;
  const PlayButton(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FadeIn(
        delay: const Duration(milliseconds: 4500),
        child: ElevatedButton(
          onPressed: puzzle == null
              ? null
              : () => context.push(
                    '/puzzle',
                    extra: ref.read(selectedDateProvider),
                  ),
          child: const Text("Try it out"),
        ),
      );
}

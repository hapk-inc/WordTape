import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/puzzle/bloc.dart';
import '../../model/puzzle.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';

class BoardAppBar extends ConsumerWidget {
  const BoardAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.read(puzzleProvider).valueOrNull;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      leadingWidth: 60,
      title: puzzle == null ? null : Text("Puzzle No. ${puzzle.puzzleNo}"),
      actions: [
        TextButton(
          onPressed: () => context.router.push(HowToPlayRoute()),
          child: Text(
            "HOW TO PLAY",
            style: textTheme.headlineSmall?.copyWith(color: slateGray),
          ),
        ),
        if (kDebugMode) ...[
          /*IconButton(
            //onPressed: () => ref.read(foundNotifierProvider.notifier).delete(),
            icon: const Icon(Icons.delete, color: ashGray), onPressed: () {},
          ),
          Gap(15.r),*/
        ]
      ],
    );
  }
}

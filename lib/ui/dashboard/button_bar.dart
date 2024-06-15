import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../logic/app/bloc.dart';
import '../../logic/auth/auth_notifier.dart';
import '../../logic/puzzle/bloc.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';
import '../common/share_dialog.dart';

class DashboardButtonBar extends StatelessWidget {
  const DashboardButtonBar({super.key});

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          spacing: 9.r,
          children: const [
            PlayNowButton(),
            ShareButton(),
            SizedBox.square(dimension: 7.5)
          ],
        ),
      );
}

class PlayNowButton extends ConsumerWidget {
  const PlayNowButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.watch(puzzleProvider).value;
    final Found? found = ref.watch(selectedFoundProvider).value;
    return ElevatedButton(
      onPressed: puzzle == null
          ? null
          : () {
              final AuthNotifier authNotifier = ref.read(authNotifierProvider);
              if (authNotifier.notLogged) {
                context.router.push(HowToPlayRoute(understand: true));
              } else {
                context.router.push(PuzzleBoardRoute(puzzle: puzzle));
              }
            },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) return ashGray;
            return teal; // Use the component's default.
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) return raisinBlack;
            return greenWhite; // Use the component's default.
          },
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: puzzle == null
            ? const Text("NOT TODAY", key: ValueKey("NOT TODAY"))
            : found == null
                ? const Text("PLAY NOW", key: ValueKey("PLAY NOW"))
                : found.isCompleted
                    ? const Text("COMPLETED", key: ValueKey("COMPLETED"))
                    : const Text("RESUME NOW", key: ValueKey("RESUME NOW")),
      ),
    );
  }
}

class ShareButton extends ConsumerWidget {
  final bool tealColor;
  final bool showPanel;
  const ShareButton({this.tealColor = false, this.showPanel = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.watch(puzzleProvider).value;
    return OutlinedButton(
      style: tealColor
          ? const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(teal),
              foregroundColor: WidgetStatePropertyAll(greenWhite),
            )
          : null,
      onPressed: puzzle == null
          ? null
          : showPanel
              ? () {
                  ref.read(panelNotifierProvider.notifier).state =
                      const ShareDialog();
                  ref.read(panelControllerProvider).open();
                }
              : () => Share.share(puzzle.shareCode)
                      .then(
                    (ShareResult result) =>
                        result.status == ShareResultStatus.success
                            ? ref.read(wordAnalyticsProvider).shareLog(puzzle)
                            : null,
                  )
                      .onError(
                    (error, stackTrace) {
                      if (kIsWeb) {
                        debugPrint("External error - $error");
                        ref.read(wordAnalyticsProvider).shareLog(puzzle);
                      }
                      //debugPrint("94--${error.toString()}");
                    },
                  ),
      child: const Text("SHARE"),
    );
  }
}

/* () => Share.share(puzzle.shareCode).then(
                (ShareResult result) {
                  debugPrint("92--${result.status.name}");
                  return result.status == ShareResultStatus.success
                      ? ref.read(wordAnalyticsProvider).shareLog(puzzle)
                      : null;
                },
              ).onError(
                (error, stackTrace) {
                  if (kIsWeb) {
                    debugPrint("External error - $error");
                    ref.read(wordAnalyticsProvider).shareLog(puzzle);
                  }
                  //debugPrint("94--${error.toString()}");
                },
              )*/

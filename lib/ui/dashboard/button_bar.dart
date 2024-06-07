import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../logic/auth/auth_notifier.dart';
import '../../logic/puzzle/bloc.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';

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
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.watch(puzzleProvider).value;
    return OutlinedButton(
      onPressed: puzzle == null
          ? null
          : () => Share.share(puzzle.shareCode).then(
                (ShareResult result) {},
              ),
      //: () => context.router.push(PuzzleBoardRoute(puzzle: puzzle)),
      child: const Text("SHARE"),
    );
  }
}

/*
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../logic/app/panel.dart';
import '../../logic/auth/auth_notifier.dart';
import '../../logic/puzzle/bloc.dart';
import '../../model/found.dart';
import '../../model/panel_widget.dart';
import '../../model/puzzle.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';
import 'login_dialog.dart';

class DButtonBar extends ConsumerWidget {
  const DButtonBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthNotifier authNotifier = ref.watch(authNotifierProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
      child: ButtonBar(
        children: [
          const PlayNow(),
          if (!authNotifier.loggedIn) const LoginNow()
        ],
      ),
    );
  }
}

class PlayNow extends ConsumerWidget {
  const PlayNow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.watch(puzzleProvider).value;
    final Found? found = ref.watch(selectedFoundProvider).value;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) return ashGray;
            return teal; // Use the component's default.
          },
        ),
      ),
      onPressed: puzzle == null
          ? null
          : () => context.router.push(PuzzleBoardRoute(puzzle: puzzle)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: puzzle == null
            ? const Text("NOT TODAY")
            : found == null
                ? const Text("PLAY NOW", style: TextStyle(color: greenWhite))
                : Text(
                    found.isCompleted ? "COMPLETED" : "RESUME NOW",
                    style: const TextStyle(color: greenWhite),
                  ),
      ),
    );
  }
}

class LoginNow extends ConsumerWidget {
  const LoginNow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(xantHous),
        ),
        //
        onPressed: () {
          final double ratio = 900.h / 360.w;
          if (ratio > 2) {
            ref.read(panelNotifierProvider.notifier).state = PanelWidget(
              height: 210.r,
              child: const LoginDialogState(),
            );
            final PanelController panel = ref.read(dashboardPanelProvider);
            if (panel.isPanelClosed) panel.open();
          } else {
            showDialog(
              context: context,
              builder: (_) => const LoginDialog(),
            );
          }
        },
        child: const Text(
          "LOGIN NOW",
          style: TextStyle(color: raisinBlack),
        ),
      );
}
*/

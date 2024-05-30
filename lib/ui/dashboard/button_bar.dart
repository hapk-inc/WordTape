import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordtape/enum/enum.dart';

import '../../logic/dashboard_notifier.dart';
import '../../model/puzzle.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';
import 'login_dialog.dart';

class DButtonBar extends ConsumerWidget {
  const DButtonBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DashboardNotifier dashboardNotifier =
        ref.watch(dashboardNotifierProvider);
    final AuthValidate validate = dashboardNotifier.authValidate;
    debugPrint(validate.name);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
      child: ButtonBar(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return ashGray;
                  }
                  return teal; // Use the component's default.
                },
              ),
            ),
            onPressed: () => context.router
                .push(PuzzleBoardRoute(puzzle: Puzzle.fromRandom())),
            child: const Text(
              "PLAY NOW",
              style: TextStyle(color: greenWhite),
            ),
          ),
          if (validate != AuthValidate.loggedIn)
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(xantHous),
              ),
              onPressed: () {
                final double ratio = 900.h / 360.w;
                if (ratio > 2) {
                  if (panelController.isPanelClosed) panelController.open();
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => const LoginDialog(),
                  );
                }

                /*if (ref.read(deviceSizeStateNotifierProvider) > 2) {
                if (dashboardPanel.isPanelClosed) dashboardPanel.open();
              } else {
                showDialog(
                  context: context,
                  builder: (_) => const LoginDialog(),
                );
              }*/
              },
              child: const Text(
                "LOGIN NOW",
                style: TextStyle(color: raisinBlack),
              ),
            )
        ],
      ),
    );
  }
}

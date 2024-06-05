import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../logic/app/device_size.dart';
import '../../logic/app/panel.dart';
import '../../model/panel_widget.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';
import 'login_dialog.dart';

class CreateAccount extends ConsumerWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) return ashGray;
            return teal; // Use the component's default.
          },
        ),
      ),
      onPressed: () {
        final double ratio = ref.read(deviceSizeProvider);

        if (ratio > 2) {
          final PanelController panel =
              context.router.current.name == DashboardRoute.name
                  ? ref.read(dashboardPanelProvider)
                  : ref.read(boardPanelProvider);
          panel.close();

          ref.read(panelNotifierProvider.notifier).state = PanelWidget(
            height: 210.r,
            child: const LoginDialogState(),
          );
          Future.delayed(const Duration(milliseconds: 300), () => panel.open());
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (_) => const LoginDialog(),
          );
        }
      },
      child: const Text(
        "CREATE A ACCOUNT",
        style: TextStyle(color: greenWhite),
      ),
    );
  }
}

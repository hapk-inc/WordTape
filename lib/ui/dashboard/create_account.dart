import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/app/panel.dart';
import '../../model/panel_widget.dart';
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
        final double ratio = 900.h / 360.w;

        if (ratio > 2) {
          ref.read(panelNotifierProvider.notifier).state = PanelWidget(
            height: 210.r,
            child: const LoginDialogState(),
          );
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../logic/app/panel.dart';
import '../../model/panel_widget.dart';
import '../../theme/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'login_dialog.dart';

class ReLoginDialog extends StatelessWidget {
  const ReLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 450.r,
      width: 540.r,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.r),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(15.h),
          AutoSizeText(
            "Congratulations on completing today's game! Create your profile now to:",
            style: textTheme.titleMedium
                ?.copyWith(color: raisinBlack, height: 1.8),
            maxLines: 2,
          ),
          Gap(15.h),
          Text("Access and play previous puzzles", style: _subFont),
          Gap(7.5.h),
          Text("View your stats", style: _subFont),
          Gap(7.5.h),
          Text(
            "Suggest a puzzle that might be featured as daily challenge",
            style: _subFont,
          ),
          Gap(15.h),
          const ButtonBar(children: [CreateAccount()])
        ],
      ),
    );
  }
}

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
        ref.read(panelNotifierProvider.notifier).state = PanelWidget(
          height: 210.r,
          child: const LoginDialogState(),
        );
      },
      child:
          const Text("CREATE A ACCOUNT", style: TextStyle(color: greenWhite)),
    );
  }
}

TextStyle get _subFont => const TextStyle(
      color: slateGray,
      height: 1.8,
    );

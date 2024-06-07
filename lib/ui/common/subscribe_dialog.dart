import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../logic/auth/bloc.dart';
import '../../logic/puzzle/bloc.dart';
import '../../model/found.dart';
import '../../theme/colors.dart';
import 'login_dialog.dart';

const String _congratulation = "Congratulations on completing today's game! ";

TextSpan get _singleLine => const TextSpan(text: "\n");

class SubscribeDialog extends ConsumerWidget {
  const SubscribeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("16--");

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(width: 450.r),
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: const CongratulationDialog(),
        )
      ],
    );
  }
}

class CongratulationDialog extends ConsumerWidget {
  const CongratulationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Found? found = ref.read(selectedFoundProvider).valueOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText.rich(
          TextSpan(
            children: [
              if (found?.isCompleted ?? false)
                const TextSpan(text: _congratulation),
              const TextSpan(text: "Create your profile now to:"),
            ],
          ),
          style: textTheme.titleSmall?.copyWith(
            color: teal,
            height: (found?.isCompleted ?? false) ? 1.8 : 0,
          ),
          maxLines: 2,
        ),
        Gap(15.r),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "•   ",
                children: [
                  TextSpan(text: "Access and play previous puzzles"),
                ],
              ),
              _singleLine,
              const TextSpan(
                text: "•   ",
                children: [TextSpan(text: "View your stats")],
              ),
              _singleLine,
              const TextSpan(
                text: "•   ",
                children: [
                  TextSpan(
                    text: "Suggest a puzzle that might be "
                        "featured as daily challenge.",
                  )
                ],
              ),
            ],
            style: textTheme.bodyMedium?.copyWith(
              height: 2.1,
              color: slateGray,
            ),
          ),
        ),
        Gap(15.r),
        Row(
          children: [
            Text(
              "Create account with",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: teal,
                  ),
            ),
            Gap(15.r),
            LoginButton(
              onClick: () => ref.read(googleLoginProvider.future),
              child: Padding(
                padding: EdgeInsets.all(3.6.r),
                child: Image.asset('images/gLogo.png'),
              ),
            ),
            Gap(12.r),
            LoginButton(
              onClick: () {},
              child: const Icon(Icons.apple),
            ),
          ],
        )
        /*Container(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(teal),
                foregroundColor: WidgetStatePropertyAll(greenWhite)),
            onPressed: () {
              ref.read(panelControllerProvider).close();
            },
            child: const Text("CREATE YOUR ACCOUNT"),
          ),
        )*/
      ],
    );
  }
}

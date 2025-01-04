import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toastification/toastification.dart';

import '../../function/auth/pod.dart';
import '../../function/question/notifier.dart';
import '../../function/question/toast.dart';

import '../../model/question.dart';
import '../../router/router.dart';
import '../common/riddle_toast.dart';

class RiddleAppBar extends ConsumerWidget {
  final Question question;
  //final DateTime date;
  const RiddleAppBar(this.question, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PackageInfo? package = ref.read(packageProvider).value;
    final String name = package?.appName ?? "";
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 15.r,
      leading: Container(),
      titleSpacing: 0,
      title: InkWell(
        onTap: () => ref.read(routerProvider).go("/daily-challenge"),
        child: Text("${name.toUpperCase()} ${question.i ?? ""}", maxLines: 1),
      ),
      actions: [LottieHint(question.date), Gap(1.5)],
      titleTextStyle: textTheme.displayMedium,
    );
  }
}

class LottieHint extends ConsumerStatefulWidget {
  final DateTime dateTime;
  const LottieHint(this.dateTime, {super.key});

  @override
  ConsumerState createState() => _LottieHintState();
}

class _LottieHintState extends ConsumerState<LottieHint> {
  late DateTime date;
  //late QuestionNotifier notifier;

  @override
  void initState() {
    date = widget.dateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async {
          final QuestionNotifier notifier =
              ref.read(questionNotifierProvider(date));
          final bool toastOpen = notifier.toastText != null;
          if (toastOpen) return;
          notifier.helpUser();
          ref.read(toastNotifierProvider.notifier).state =
              toastification.showCustom(
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(minutes: 30),
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(7.5.r),
              child: RiddleToast(date, word: notifier.focusedWord),
            ),
          );
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: ref.watch(questionNotifierProvider(date)).done
              ? const SizedBox()
              : SizedBox.square(
                  dimension: 75.r,
                  child: FadeIn(
                    child: Lottie.asset("question_lottie".tr()),
                  ),
                ),
        ),
      );
}

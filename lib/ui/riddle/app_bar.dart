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
import '../../function/date_selected/date_selected.dart';
import '../../function/question/notifier.dart';
import '../../function/question/toast.dart';

import '../../router/router.dart';
import '../common/word_clue.dart';

class RiddleAppBar extends ConsumerWidget {
  const RiddleAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ScreenSize size = ref.watch(sizeProvider);
    // final bool isPC = size == ScreenSize.pc;
    final PackageInfo? package = ref.read(packageProvider).value;
    final String name = package?.appName ?? "";
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 15.r,
      leading: Container(),
      titleSpacing: 0,
      title: InkWell(
        onTap: () => ref.read(routerProvider).pop(),
        child: Text(name.toUpperCase(), maxLines: 1),
      ),
      actions: const [LottieHint(), Gap(1.5)],
      titleTextStyle: textTheme.displayMedium,
    );
  }
}

class LottieHint extends ConsumerStatefulWidget {
  const LottieHint({super.key});

  @override
  ConsumerState createState() => _LottieHintState();
}

class _LottieHintState extends ConsumerState<LottieHint> {
  late DateTime date;
  late QuestionNotifier notifier;

  @override
  void initState() {
    date = ref.read(dateSelectedProvider);
    notifier = ref.read(questionNotifierProvider(date));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          notifier.helpUser();

          ref.read(toastNotifierProvider.notifier).state =
              toastification.showCustom(
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 30),
            builder: (_, ToastificationItem item) => WordClueState(date),
          );
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: ref.watch(questionNotifierProvider(date)).done
              ? const SizedBox()
              : SizedBox.square(
                  dimension: 75.r,
                  //child: FadeIn(child: Lottie.asset("question".tr())),
                  child: FadeIn(child: Lottie.asset("lottie/question_2.json")),
                ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../function/date/date.dart';
import '../../function/riddle/notifier.dart';

class RiddleAppBar extends StatelessWidget {
  const RiddleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 90.r,
      title: const Text("WORDTAPE"),
      actions: const [LottieHint()],
      titleTextStyle: Theme.of(context).textTheme.displaySmall,
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
  late RiddleNotifier notifier;

  @override
  void initState() {
    date = ref.read(selectedDateProvider);
    notifier = ref.read(riddleNotifierProvider(date));
    /*ref.listenManual(
      riddleNotifierProvider(date).select((value) => value.tip),
      (_, next) {
        ref.read(riddleHintProvider(date).notifier).state = next.text;
      },
    );*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(riddleNotifierProvider(date));
    return SizedBox.square(
      dimension: 75.r,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: notifier.found.mistake == null
            ? const SizedBox()
            : InkWell(
                onTap: () => notifier.createTip(),
                child: Lottie.asset("lottie/bulb.json"),
              ),
      ),
    );
  }
}

/*
class LottieHint extends ConsumerWidget {
  const LottieHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(selectedDateProvider);



    final RiddleNotifier notifier = ref.watch(riddleNotifierProvider(date));
    return SizedBox.square(
      dimension: 75.r,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: notifier.found.mistake == null
            ? const SizedBox()
            : Lottie.asset("lottie/bulb.json"),
      ),
    );
  }
}
*/

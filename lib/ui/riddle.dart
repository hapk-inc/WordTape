import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../function/question/notifier.dart';

import '../function/question/word_notifier.dart';
import '../model/word.dart';
import '../panel/pod.dart';
import '../shared/shared.dart';
import 'common/instruction.dart';
import 'riddle/custom_keyboard.dart';
import 'common/editable_word.dart';
import 'common/gradient_box.dart';
import 'riddle/prompt.dart';
import 'riddle/app_bar.dart';
import 'summary.dart';

class RiddlePage extends ConsumerStatefulWidget {
  final DateTime date;
  const RiddlePage(this.date, {super.key});

  @override
  ConsumerState createState() => _RiddlePageState();
}

class _RiddlePageState extends ConsumerState<RiddlePage> {
  late final AppLifecycleListener _listener;
  late DateTime date;
  late QuestionNotifier notifier;

  //
  @override
  void initState() {
    date = widget.date;
    notifier = ref.read(questionNotifierProvider(date));

    Future.delayed(
      const Duration(milliseconds: 600),
      () async {
        if (notifier.done) {
          ref.read(panelNotifierProvider.notifier).state =
              SummaryPage(date: date);
        } else {
          final SharedPreferences pref =
              await ref.read(sharedPrefProvider.future);

          final bool howToPlay = pref.getBool('how_to_play') ?? false;
          if (!howToPlay) {
            ref.read(panelNotifierProvider.notifier).state =
                const InstructionDialog();
          }
        }
      },
    );

    ref.listenManual<bool>(
      questionNotifierProvider(date).select((value) => value.done),
      (previous, next) {
        if (next) {
          ref.read(panelNotifierProvider.notifier).state =
              SummaryPage(date: date);
        }
      },
    );

    _listener = AppLifecycleListener(onStateChange: _onStateChanged);
    super.initState();
  }

  _onStateChanged(AppLifecycleState state) {}

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(questionNotifierProvider(date));
    return GradientBox(
      child: SafeArea(bottom: false, child: RiddlePageState(date)),
    );
  }
}

/*child: KeyboardListener(
          focusNode: FocusNode(canRequestFocus: true),
          onKeyEvent: (KeyEvent? value) {
            if (value is KeyDownEvent || value is KeyRepeatEvent) {
              // ref.read(keyTapNotifierProvider.notifier).state = value;
            }
          },
          child: RiddlePageState(date),
        ),*/

class RiddlePageState extends ConsumerWidget {
  final DateTime date;
  const RiddlePageState(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    return LayoutBuilder(
      builder: (_, constraints) {
        final double maxHeight = constraints.maxHeight - 90.h;
        final double maxWidth = constraints.maxWidth;
        final double h_03 = maxHeight * 0.03;
        final double w_03 = maxWidth * 0.03;
        return SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Form(
            key: notifier.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RiddleAppBar(date),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: h_03 * 4.5,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: w_03 * 1.5),
                  child: PromptWidget(date),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    height: maxHeight * 0.6,
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (notifier.focusedWord != null) {
                          ref
                              .read(wordNotifierProvider(notifier.focusedWord!))
                              .node
                              .requestFocus();
                        }
                      },
                      child: Theme(
                        data: ThemeData(
                          scrollbarTheme:
                              ScrollbarThemeData(interactive: false),
                        ),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              for (Word word in notifier.question?.words ?? [])
                                EditableWord(word),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(h_03 * 0.12),
                const CustomKeyboard(),
              ],
            ),
          ),
        );
      },
    );
  }
}

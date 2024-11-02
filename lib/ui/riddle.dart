import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/function/question/word_notifier.dart';

import '../function/key_tap/pod.dart';
import '../function/local/found.dart';
import '../function/question/notifier.dart';

import '../model/found.dart';
import '../model/word.dart';
import '../panel/pod.dart';
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
      () {
        if (notifier.done) {
          ref.read(panelNotifierProvider.notifier).state =
              SummaryPage(date: date);
        }
      },
    );

    ref.listenManual(
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

  _onStateChanged(AppLifecycleState state) {
    log(state.name);
    // if (state == AppLifecycleState.inactive) notifier.insert();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(questionNotifierProvider(date));
    /*final FocusNode focusNode = notifier.focusedWord == null
        ? FocusNode()
        : ref.watch(wordNotifierProvider(notifier.focusedWord!)).node;*/

    return GradientBox(
      child: SafeArea(
        bottom: false,
        child: RiddlePageState(date),
        /*child: KeyboardListener(
          focusNode: FocusNode(canRequestFocus: true),
          onKeyEvent: (KeyEvent? value) {
            if (value is KeyDownEvent || value is KeyRepeatEvent) {
              // ref.read(keyTapNotifierProvider.notifier).state = value;
            }
          },
          child: RiddlePageState(date),
        ),*/
      ),
    );
  }
}

class RiddlePageState extends ConsumerWidget {
  final DateTime date;
  const RiddlePageState(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    return LayoutBuilder(
      builder: (_, constraints) {
        final double maxHeight = constraints.maxHeight - 90.h;
        final double maxWidth = constraints.maxWidth;
        final double h_03 = maxHeight * 0.03;
        final double w_03 = maxWidth * 0.03;
        return SingleChildScrollView(
          child: Form(
            key: notifier.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const RiddleAppBar(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: h_03 * 4.8,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: w_03 * 1.5),
                  child: const PromptWidget(),
                ),
                for (Word word in notifier.question?.words ?? [])
                  EditableWord(word),
                Gap(h_03 * 1.2),
                const CustomKeyboard(),
              ],
            ),
          ),
        );
      },
    );
  }
}

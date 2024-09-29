import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import '../../function/riddle/notifier.dart';
import '../../function/riddle/riddle_hint.dart';
import '../../function/riddle/word_notifier.dart';
import '../../function/underline_text/pod.dart';
import '../../model/date_ext.dart';

import '../../model/word.dart';
import '../../theme/pin_theme.dart';

class EditableWord extends ConsumerStatefulWidget {
  final Word word;
  final double? height;
  const EditableWord(this.word, {this.height, super.key});

  @override
  ConsumerState createState() => _EditableWordState();
}

class _EditableWordState extends ConsumerState<EditableWord> {
  late Word word;
  late WordNotifier wordNotifier;
  late int index;
  late DateTime date;

  @override
  void initState() {
    word = widget.word;
    final List<String> splitter = word.id?.split("|") ?? [];
    if (splitter.isNotEmpty) {
      index = int.parse(splitter[1]);
      date = DateFormat('yyyy-MM-dd').parse(splitter[0]);
    } else {
      index = 0;
      date = DateTime.now().convert();
    }

    wordNotifier = ref.read(wordNotifierProvider(word));
    ref.listenManual(
      riddleNotifierProvider(DateTime.now().convert())
          .select((value) => value.found),
      (prev, next) async {
        wordNotifier.initV();
        if (next.i == index) {
          log("Found Changing for ${word.value} at i = ${next.i}");
          final RiddleHint riddleHint =
              ref.read(riddleHintProvider(date).notifier);

          if (next.mistake != null) {
            riddleHint.helpUser();
          } else {
            final bool compare =
                const DeepCollectionEquality().equals(prev?.soFar, next.soFar);
            if (!compare) {
              riddleHint.state =
                  ref.read(riddleNotifierProvider(date)).tip.text;
            } else {
              riddleHint.rearrange();
            }
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wordNotifier = ref.watch(wordNotifierProvider(word));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      height: 60.h,
      margin: EdgeInsets.only(bottom: 7.5.r),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (_, constraints) {
          //
          final PinTheme pinTheme = ref.read(pinThemeProvider(
            constraints: constraints,
            color: wordNotifier.color,
          ));

          return Pinput(
            length: word.value.length,
            defaultPinTheme: pinTheme,
            controller: wordNotifier.controller,
            //focusNode: wordNotifier.node,
            //
            isCursorAnimationEnabled: false,
            animationDuration: const Duration(milliseconds: 150),
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            validator: !wordNotifier.isEnabled
                ? null
                : (value) {
                    final int l = value?.length ?? 0;
                    final bool filled = l == word.value.length;
                    if (filled) {
                      final RiddleNotifier notifier =
                          ref.read(riddleNotifierProvider(date));
                      if (notifier.compareHighlighter(value)) {
                        notifier.validate();
                      } else {
                        ref.read(riddleHintProvider(date).notifier).state =
                            ref.read(useHighlighterProvider);
                      }
                    } else {
                      // ref.read(hintNotifierProvider(date).notifier).state =
                      //     ref.read(fillTextProvider);
                    }
                    return null;
                  },
            //
            keyboardType: TextInputType.none,
            readOnly: true,
            showCursor: false,

            //
            enabled: wordNotifier.isEnabled,
            animationCurve: Curves.easeOut,
            // autofocus: autoFocus,

            textCapitalization: TextCapitalization.characters,
            separatorBuilder: (_) {
              final int len = word.value.length;
              return SizedBox(width: len > 8 ? 4.5.r : 9.r);
            },
          );
        },
      ),
    );
  }
}

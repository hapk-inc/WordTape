import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../function/riddle/notifier.dart';
import '../../function/riddle/word_notifier.dart';
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
  //late Color color;
  //late bool isEnabled;
  //late TextEditingController controller;
  //late
  late double height;
  late Word word;
  late WordNotifier wordNotifier;

  @override
  void initState() {
    word = widget.word;
    height = widget.height ?? 61.5.r;
    wordNotifier = ref.read(wordNotifierProvider(word));
    ref.listenManual(
      riddleNotifierProvider(DateTime.now().convert())
          .select((value) => value.found),
      (prev, next) {
        log("Found Changing for ${word.value} at i = ${next.i}");
        wordNotifier.initV();
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
            //
            isCursorAnimationEnabled: false,
            animationDuration: const Duration(milliseconds: 150),
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            validator: !wordNotifier.isEnabled
                ? null
                : (value) {
                    final int l = value?.length ?? 0;
                    final bool filled = l == word.value.length;
                    final DateTime date = DateTime.now().convert();
                    if (filled) {
                      ref.read(riddleNotifierProvider(date)).validate();
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

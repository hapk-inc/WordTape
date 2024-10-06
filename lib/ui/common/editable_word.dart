import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

//
import '../../function/riddle/word_notifier.dart';
import '../../extension/extension.dart';

import '../../model/word.dart';
import '../../theme/pod.dart';

class EditableWord extends ConsumerStatefulWidget {
  final Word word;

  const EditableWord(this.word, {super.key});

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
            validator: !wordNotifier.isEnabled ? null : wordNotifier.validator,

            //
            keyboardType: TextInputType.none, readOnly: true,
            showCursor: false, forceErrorState: wordNotifier.error,

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

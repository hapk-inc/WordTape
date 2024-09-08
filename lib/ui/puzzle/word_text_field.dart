import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../enum/pod.dart';
import '../../function/puzzle/notifier.dart';
import '../../function/puzzle/pod.dart';
import '../../model/word.dart';
import '../theme/color.dart';

class WordTextField extends ConsumerWidget {
  final int index;
  final Word word;
  final double? height;
  final NeedToDo needToDo;
  const WordTextField(this.index, this.word,
      {this.height, this.needToDo = NeedToDo.find, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late PuzzleNotifier notifier;
    late Color color;
    late bool isEnabled;
    late TextEditingController controller;

    if (needToDo != NeedToDo.find) {
      isEnabled = false;
      controller = TextEditingController(
        text: needToDo == NeedToDo.plain
            ? word.value
            : word.value.substring(0, 1),
      );
      color = needToDo == NeedToDo.onClick ? seaWhite : aquaMarine;
    } else {
      final DateTime date = ref.read(selectedDateProvider);
      notifier = ref.watch(puzzleNotifierProvider(date));

      isEnabled = notifier.textController(index) == notifier.activeController;
      controller = notifier.textController(index);
      color = isEnabled
          ? seaWhite
          : notifier.isPrevious(word)
              ? aquaMarine
              : Colors.white30;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      constraints: BoxConstraints(maxWidth: 450.r, minHeight: height ?? 75.h),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Pinput(
            /*onTap: needToDo == NeedToDo.onClick
                ? () => context.push(
                      '/puzzle',
                      extra: ref.read(selectedDateProvider),
                    )
                : null,*/
            length: word.value.length,
            defaultPinTheme: ref.read(
              pinThemeProvider(constraints: constraints, color: color),
            ),

            controller: controller,

            //
            isCursorAnimationEnabled: false,
            animationDuration: const Duration(milliseconds: 150),
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            //validator: (value) {},
            //
            keyboardType: TextInputType.none,
            readOnly: true,
            showCursor: false,
            enabled: isEnabled,
            animationCurve: Curves.easeOut,

            textCapitalization: TextCapitalization.characters,
            separatorBuilder: (_) {
              final int len = word.value.length;
              return SizedBox(width: len > 8 ? 4.5.r : 7.5.r);
            },
            //
          );
        },
      ),
    );
  }
}

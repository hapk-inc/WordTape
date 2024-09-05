import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../enum/pod.dart';
import '../../function/puzzle/notifier.dart';
import '../../function/puzzle/pod.dart';
import '../../model/word.dart';
import '../theme/colors.dart';

class WordTextField extends ConsumerWidget {
  final Word word;
  final double? height;
  final NeedToDo needToDo;
  const WordTextField(
    this.word, {
    this.height,
    this.needToDo = NeedToDo.find,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late PuzzleNotifier notifier;
    if (needToDo == NeedToDo.find) {
      final DateTime date = ref.watch(selectedDateProvider);
      notifier = ref.watch(puzzleNotifierProvider(date));
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      constraints: BoxConstraints(maxWidth: 450.r, minHeight: height ?? 75.h),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Pinput(
            onTap: needToDo == NeedToDo.onClick
                ? () => context.push(
                      '/puzzle',
                      extra: ref.read(selectedDateProvider),
                    )
                : null,
            length: word.value.length,
            defaultPinTheme: ref.read(
              pinThemeProvider(
                  constraints: constraints,
                  color: needToDo == NeedToDo.onClick ? aquaMarine : seaWhite),
            ),
            controller: needToDo == NeedToDo.find
                ? notifier.textController(word)
                : TextEditingController(
                    text: needToDo == NeedToDo.plain
                        ? word.value
                        : word.value.substring(0, 1),
                  ),

            //
            isCursorAnimationEnabled: false,
            animationDuration: const Duration(milliseconds: 150),
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            //validator: (value) {},
            //
            keyboardType: TextInputType.none,
            readOnly: true,
            showCursor: false,
            enabled: needToDo == NeedToDo.find
                ? notifier.textController(word) == notifier.activeController
                : false,
            animationCurve: Curves.easeOut,

            textCapitalization: TextCapitalization.characters,
            separatorBuilder: (_) => SizedBox(
              width: word.value.length > 8 ? 4.5.r : 7.5.r,
            ),
            //
          );
        },
      ),
    );
  }
}

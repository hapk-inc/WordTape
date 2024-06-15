import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../enum/enum.dart';
import '../../logic/puzzle/found_notifier.dart';
import '../../model/found.dart';
import '../../model/word.dart';
import '../../theme/colors.dart';
import '../../theme/text_theme.dart';

final MyTextTheme _textTheme = MyTextTheme();

//const Duration _m300 = Duration(milliseconds: 300);

PinTheme _defaultPinTheme(BoxConstraints box, {Color color = idleColor}) =>
    PinTheme(
      width: box.maxWidth * 0.105,
      height: box.maxHeight * 0.75,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: color, width: 0.9.r),
        ),
      ),
      textStyle: _textTheme.headlineMedium,
    );

class WordPinput extends ConsumerWidget {
  final int index;
  final Word word;

  const WordPinput(this.index, this.word, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late TextEditingController controller;
    String firstLetter = word.value.characters.first;

    onTextChanged() {
      final String txt = controller.text;
      controller.value = controller.value.copyWith(text: txt.toUpperCase());
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (!txt.startsWith(firstLetter) || txt.isEmpty) {
        controller.value = controller.value.copyWith(
          text: firstLetter,
          selection: TextSelection.fromPosition(
            const TextPosition(offset: 1),
          ),
        );
      }
    }

    final FoundNotifier notifier = ref.watch(foundNotifierProvider.notifier);
    final WordValidate wv = notifier.validate[index];
    final Found found = ref.watch(foundNotifierProvider).found;

    //
    String mistake = found.mistake ?? "";

    controller = TextEditingController()
      ..text = filledState(wv)
          ? word.value
          : wv == WordValidate.error
              ? mistake
              : wv == WordValidate.focused
                  ? firstLetter
                  : ""
      ..addListener(onTextChanged);

    return LayoutBuilder(
      builder: (_, constraint) => Pinput(
        controller: controller,
        length: word.value.length,

        //
        defaultPinTheme: _defaultPinTheme(constraint),
        disabledPinTheme: _defaultPinTheme(constraint).copyWith(
          textStyle: _defaultPinTheme(constraint).textStyle?.copyWith(
                color: found.isCompleted
                    ? index == 0
                        ? idleColor
                        : ((found.revealed ?? []).contains(word.value))
                            ? errorColor
                            : filledColor
                    : idleColor,
              ),
        ),
        errorPinTheme: _defaultPinTheme(constraint, color: errorColor).copyWith(
          textStyle: _defaultPinTheme(constraint)
              .textStyle
              ?.copyWith(color: errorColor),
        ),
        focusedPinTheme:
            _defaultPinTheme(constraint, color: textColor).copyWith(
          textStyle: _defaultPinTheme(constraint).textStyle?.copyWith(
                color: textColor,
              ),
        ),

        //
        //
        isCursorAnimationEnabled: true,
        pinAnimationType: PinAnimationType.fade,
        animationDuration: const Duration(milliseconds: 150),
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        //
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.characters,
        separatorBuilder: (_) => SizedBox(width: constraint.maxWidth * 0.015),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            //regex pattern for blank space and capital letters
            RegExp(r"^$|[a-zA-Z]+$"),
            replacementString: word.value.characters.first,
            //replacementString: controller.text.toUpperCase(),
          ),
        ],

        //
        autofocus: wv == WordValidate.focused,
        enabled: wv == WordValidate.focused || wv == WordValidate.error,
        forceErrorState: wv == WordValidate.error,
        showCursor: true,

        //
        errorBuilder: (errorText, pin) => Container(),

        onCompleted: (value) async {
          final FoundNotifier read = ref.read(foundNotifierProvider.notifier);
          debugPrint("120--");
          if (value == word.value) {
            await read.correctOne();
          } else {
            await read.wrongOne(value);
          }
        },
      ),
    );
  }
}

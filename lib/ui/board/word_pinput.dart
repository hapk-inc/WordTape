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

class WordPinput extends ConsumerStatefulWidget {
  final int index;
  final Word word;
  final bool demo;
  const WordPinput(this.index, this.word, {this.demo = false, super.key});

  @override
  ConsumerState createState() => _WordPinputState();
}

class _WordPinputState extends ConsumerState<WordPinput> {
  late TextEditingController controller;
  late Found? found;
  late WordValidate wv;
  late String str;

  static PinTheme _defaultPinTheme(BoxConstraints box,
          {Color color = idleColor}) =>
      PinTheme(
        width: box.maxWidth * 0.105,
        height: box.maxHeight * 0.75,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: 0.9.r)),
        ),
        textStyle: _textTheme.headlineMedium,
      );

  _onTextChanged() {
    String firstLetter = widget.word.value.characters.first;
    if (!controller.text.startsWith(firstLetter) || controller.text.isEmpty) {
      controller.value = controller.value.copyWith(
        text: firstLetter,
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
  }

  @override
  void initState() {
    str = widget.word.value;
    if (widget.demo) {
      if (widget.index == 0) {
        controller = TextEditingController(text: str);
      } else {
        controller = TextEditingController(text: str.characters.first);
        for (var e in str.substring(1).characters) {
          Future.delayed(
              const Duration(milliseconds: 1200), () => controller.text += e);
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.demo) {
      return LayoutBuilder(
        builder: (ctx, constraint) => Container(
          color: widget.index == 0 ? seaSalt : null,
          alignment: Alignment.centerLeft,
          child: Pinput(
            controller: controller,
            length: str.length,

            //
            defaultPinTheme: _defaultPinTheme(constraint),
            disabledPinTheme: _defaultPinTheme(constraint).copyWith(
              textStyle: _defaultPinTheme(constraint).textStyle?.copyWith(
                    color: widget.index == 1 ? filledColor : idleColor,
                  ),
            ),

            //
            isCursorAnimationEnabled: true,
            pinAnimationType: PinAnimationType.fade,
            animationDuration: const Duration(milliseconds: 150),
            pinputAutovalidateMode: PinputAutovalidateMode.disabled,
            //
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.characters,
            separatorBuilder: (_) =>
                SizedBox(width: constraint.maxWidth * 0.015),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                //regex pattern for blank space and capital letters
                RegExp(r"^$|[A-Z]+$"),
                replacementString: widget.word.value.characters.first,
              ),
            ],

            //
            autofocus: false,
            enabled: false,

            //
            errorBuilder: (errorText, pin) => Container(),
          ),
        ),
      );
    }
    found = ref.watch(foundNotifierProvider).value;
    if (found == null) return Container();

    wv = widget.word.validate;
    controller = TextEditingController()
      ..text = wv == WordValidate.alreadyFilled || wv == WordValidate.previous
          ? str
          : wv == WordValidate.error
              ? found?.mistake ?? "" //  mistake
              //? str //  mistake
              : wv == WordValidate.focused
                  ? str.characters.first
                  : ""
      ..addListener(_onTextChanged);
    return LayoutBuilder(
      builder: (ctx, constraint) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: widget.index == 0
            ? greenWhite
            : (found?.isCompleted ?? false)
                ? seaSalt
                : wv == WordValidate.previous ||
                        wv == WordValidate.focused ||
                        wv == WordValidate.error
                    ? seaSalt
                    : null,
        alignment: Alignment.centerLeft,
        child: Pinput(
          controller: controller,
          length: str.length,

          //
          defaultPinTheme: _defaultPinTheme(constraint),
          disabledPinTheme: _defaultPinTheme(constraint).copyWith(
            textStyle: _defaultPinTheme(constraint).textStyle?.copyWith(
                  color: wv == WordValidate.filled ? filledColor : idleColor,
                ),
          ),
          errorPinTheme:
              _defaultPinTheme(constraint, color: errorColor).copyWith(
            textStyle: _defaultPinTheme(constraint)
                .textStyle
                ?.copyWith(color: errorColor),
          ),
          focusedPinTheme:
              _defaultPinTheme(constraint, color: textColor).copyWith(
            textStyle: _defaultPinTheme(constraint)
                .textStyle
                ?.copyWith(color: textColor),
          ),

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
              RegExp(r"^$|[A-Z]+$"),
              replacementString: widget.word.value.characters.first,
            ),
          ],

          //
          autofocus: wv == WordValidate.focused,
          enabled: wv == WordValidate.focused || wv == WordValidate.error,
          forceErrorState: wv == WordValidate.error,
          showCursor: true,

          //
          errorBuilder: (errorText, pin) => Container(),
          onCompleted: (str) =>
              ref.read(foundNotifierProvider.notifier).onComplete(str),
          validator: (value) {
            bool isSame = value == str;

            final SnackBar snackBar = isSame
                ? const SnackBar(
                    content: Text("You got it right."),
                    backgroundColor: teal,
                  )
                : SnackBar(
                    //margin: EdgeInsets.symmetric(vertical: 7.5),
                    padding: EdgeInsets.symmetric(
                      vertical: 15.r,
                      horizontal: 30.r,
                    ),
                    content: const Text("Incorrect one"),
                    backgroundColor: engineeringOrange,
                  );
            if (!(widget.index + 1 > 5)) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            return isSame ? null : "Incorrect";
          },
        ),
      ),
    );
  }
}

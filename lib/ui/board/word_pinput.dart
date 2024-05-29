import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../enum/enum.dart';
import '../../model/word.dart';
import '../../theme/colors.dart';
import '../../theme/text_theme.dart';

final MyTextTheme _textTheme = MyTextTheme();

class WordPinput extends ConsumerStatefulWidget {
  final int index;
  final Word word;
  const WordPinput(this.index, this.word, {super.key});

  @override
  ConsumerState createState() => _WordPinputState();
}

class _WordPinputState extends ConsumerState<WordPinput> {
  //
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

  late TextEditingController controller;
  late WordValidate validate;

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
    final String str = widget.word.value.toUpperCase();
    validate = widget.word.validate;
    controller = TextEditingController()
      ..text = validate == WordValidate.alreadyFilled
          ? str
          : validate == WordValidate.error
              ? str //  mistake
              : validate == WordValidate.focused
                  ? str.characters.first
                  : ""
      ..addListener(_onTextChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) => Pinput(
        controller: controller, length: widget.word.value.length,

        //
        defaultPinTheme: _defaultPinTheme(constraint),
        disabledPinTheme: _defaultPinTheme(constraint).copyWith(
          textStyle: _defaultPinTheme(constraint).textStyle?.copyWith(
                color:
                    validate == WordValidate.filled ? filledColor : idleColor,
              ),
        ),
        errorPinTheme: _defaultPinTheme(constraint, color: errorColor).copyWith(
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
        //
        autofocus: validate == WordValidate.focused,
        enabled:
            validate == WordValidate.focused || validate == WordValidate.error,
        forceErrorState: validate == WordValidate.error,
        showCursor: true,

        //
        errorBuilder: (errorText, pin) => Container(),
      ),
    );
  }
}

/*
class WordPinput extends ConsumerWidget {
  final int index;
  final Word word;


  const WordPinput(this.index, this.word, {super.key});



  late TextEditingController controller;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}*/

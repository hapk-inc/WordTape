import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../function/date_selected/date_selected.dart';
import '../../function/question/notifier.dart';
import '../../function/question/word_notifier.dart';
import '../../model/word.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';

class CustomKeyboard extends ConsumerWidget {
  const CustomKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> highlightedChar = [];

    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: 1.5.r),
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(maxWidth: 450.r),
      child: LayoutBuilder(
        builder: (_, constraints) => Column(
          children: [
            for (int i = 1; i <= 3; i++)
              SingleChildScrollRow(
                children: [
                  ..."row_$i".tr().split(",").map(
                        (str) => _KeyboardTile(
                          str,
                          constraints.maxWidth,
                          isHighlighted: highlightedChar.contains(str),
                        ),
                      )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _KeyboardTile extends ConsumerWidget {
  final String str;
  final double width;
  final bool isHighlighted;

  const _KeyboardTile(this.str, this.width, {this.isHighlighted = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(dateSelectedProvider);
    final bool isChar = str.length == 1;
    final DefaultTextTheme textTheme = DefaultTextTheme();

    double w = 0;
    if (isChar) {
      w = 0.084;
    } else {
      w = str == "DEL" ? 0.12 : 0.165;
    }

    return InkWell(
      onTap: () {
        final QuestionNotifier notifier =
            ref.read(questionNotifierProvider(date));
        final Word? word = notifier.focusedWord;
        // Checking if focused is not null
        if (word != null) {
          final WordNotifier wNotifier = ref.read(wordNotifierProvider(word));
          switch (str) {
            case "ENTER":
              {
                if (notifier.formKey.currentState?.validate() ?? false) {
                  notifier.validate(wNotifier.controller.text);
                }
                break;
              }
            default:
              wNotifier.keyboardTap(str);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width * w,
        height: 54.h,
        margin: EdgeInsets.all(3.r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.5.r),
          border: Border.all(width: 0.27.r, color: seaWhite),
        ),
        padding: EdgeInsets.symmetric(horizontal: 7.5.r),
        child: AutoSizeText(
          str,
          style: textTheme.headlineMedium?.copyWith(color: azureGreen),
          presetFontSizes: [18.r, 15.r, 12.r],
          maxLines: 1,
        ),
      ),
    );
  }
}

class SingleChildScrollRow extends StatelessWidget {
  final List<Widget> children;
  const SingleChildScrollRow({required this.children, super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      );
}

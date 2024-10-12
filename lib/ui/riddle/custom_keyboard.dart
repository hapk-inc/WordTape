import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../function/date/date.dart';

import '../../enum/enum.dart';

import '../../function/question/notifier.dart';
import '../../function/question/word_notifier.dart';
import '../../theme/color.dart';

const String backspace = "🔙";
const String done = "✔️";

const List<dynamic> row1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"];
const List<dynamic> row2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"];
const List<dynamic> row3 = [done, "Z", "X", "C", "V", "B", "N", "M", backspace];

class CustomKeyboard extends ConsumerWidget {
  const CustomKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isMobile = size == ScreenSize.mobile;
    final DateTime date = ref.read(selectedDateProvider);
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final List<String> highlightedChar = notifier.highlightedChar;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(maxWidth: isMobile ? 360.r : 375.r),
      child: LayoutBuilder(
        builder: (_, constraints) => Column(
          children: [
            SingleChildScrollRow(
              children: row1.map(
                (str) {
                  final bool isChar = str.length == 1;
                  final double maxWidth = constraints.maxWidth;
                  final double width = maxWidth * (isChar ? 0.084 : 0.09);
                  return _KeyboardTile(
                    str,
                    width,
                    isHighlighted: highlightedChar.contains(str),
                  );
                },
              ).toList(),
            ),
            Gap(7.5.r),
            SingleChildScrollRow(
              children: row2.map(
                (str) {
                  final bool isChar = str.length == 1;
                  final double maxWidth = constraints.maxWidth;
                  final double width = maxWidth * (isChar ? 0.084 : 0.09);
                  return _KeyboardTile(
                    str,
                    width,
                    isHighlighted: highlightedChar.contains(str),
                  );
                },
              ).toList(),
            ),
            Gap(7.5.r),
            SingleChildScrollRow(
              children: row3.map(
                (str) {
                  final bool isChar = str.length == 1;
                  final double maxWidth = constraints.maxWidth;
                  final double width = maxWidth * (isChar ? 0.084 : 0.15);
                  return _KeyboardTile(
                    str,
                    width,
                    isHighlighted: highlightedChar.contains(str),
                  );
                },
              ).toList(),
            ),
            Gap(1.5.r),
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
    final DateTime date = ref.read(selectedDateProvider);
    final bool isChar = str.length == 1;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        final QuestionNotifier notifier =
            ref.read(questionNotifierProvider(date));
        if (notifier.focusedWord == null) return;
        final WordNotifier wordNotifier =
            ref.read(wordNotifierProvider(notifier.focusedWord!));
        wordNotifier.listenTap(str);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: 42.h,
        margin: EdgeInsets.symmetric(horizontal: 2.25.r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHighlighted
              ? aquaMarine
              : isChar
                  ? null
                  : Colors.amber,
          borderRadius: BorderRadius.circular(4.5.r),
          border: Border.all(width: 0.24.r, color: seaWhite),
        ),
        child: Text(
          str,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: isChar ? 15.r : 21.r,
            color: !isHighlighted && isChar ? Colors.white60 : Colors.black,
          ),
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

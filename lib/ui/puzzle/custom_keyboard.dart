import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/ui/theme/color.dart';

import '../../enum/pod.dart';
import '../../function/puzzle/notifier.dart';
import '../../function/puzzle/pod.dart';

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
                  return MyKeyboardTile(str, width);
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
                  return MyKeyboardTile(str, width);
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
                  return MyKeyboardTile(str, width);
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyKeyboardTile extends ConsumerWidget {
  const MyKeyboardTile(this.str, this.width, {super.key});

  final String str;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isChar = str.length == 1;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        final DateTime date = ref.read(selectedDateProvider);
        final PuzzleNotifier notifier = ref.read(puzzleNotifierProvider(date));
        switch (str) {
          case backspace:
            notifier.removeText();
            break;
          case done:
            {
              notifier.formKey.currentState!.validate();
              break;
            }
          default:
            notifier.addText(str);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: 43.5.h,
        margin: EdgeInsets.symmetric(horizontal: width * 0.06),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isChar ? null : Colors.amber,
          borderRadius: BorderRadius.circular(4.5.r),
          border: Border.all(width: 0.24.r, color: seaWhite),
        ),
        child: Text(
          str,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: isChar ? 15.r : 21.r,
            color: isChar ? Colors.white60 : Colors.black,
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

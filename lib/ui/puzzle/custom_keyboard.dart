import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../theme/colors.dart';

const String backspace = "🔙";
const String done = "✔️";

const List<dynamic> row1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"];
const List<dynamic> row2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"];
const List<dynamic> row3 = [done, "Z", "X", "C", "V", "B", "N", "M", backspace];

class CustomKeyboard extends ConsumerWidget {
  const CustomKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: BoxConstraints(maxWidth: 375.r),
      child: LayoutBuilder(
        builder: (_, constraints) => Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row1.map(
                  (str) {
                    final bool isChar = str.length == 1;
                    final double maxWidth = constraints.maxWidth;
                    final double width = maxWidth * (isChar ? 0.084 : 0.09);
                    return MyKeyboardTile(str, width);
                  },
                ).toList(),
              ),
            ),
            Gap(7.5.r),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row2.map(
                  (str) {
                    final bool isChar = str.length == 1;
                    final double maxWidth = constraints.maxWidth;
                    final double width = maxWidth * (isChar ? 0.084 : 0.09);
                    return MyKeyboardTile(str, width);
                  },
                ).toList(),
              ),
            ),
            Gap(7.5.r),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row3.map(
                  (str) {
                    final bool isChar = str.length == 1;
                    final double maxWidth = constraints.maxWidth;
                    final double width = maxWidth * (isChar ? 0.084 : 0.15);
                    return MyKeyboardTile(str, width);
                  },
                ).toList(),
              ),
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
    //final String id = ref.watch(puzzleKeyProvider);
    return InkWell(
      onTap: () async {
        /*  final PuzzleNotifier notifier = ref.read(puzzleNotifierProvider(id));
        switch (str) {
          case backspace:
            notifier.removeText();
            break;
          case done:
            {
              if (!notifier.enableDone) return;
              await notifier.validate();
              break;
            }
          default:
            notifier.addText(str);
        }*/
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: 43.2.h,
        margin: EdgeInsets.symmetric(horizontal: width * 0.06),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: /*str == done && ref.watch(puzzleNotifierProvider(id)).enableDone
              ? aquaMarine
              : */
              null,
          borderRadius: BorderRadius.circular(4.5.r),
          border: Border.all(width: 0.24.r),
        ),
        child: Text(
          str,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: isChar ? 15.r : 21.r,
            color: slateGray,
          ),
        ),
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../function/instruction_notifier.dart';
import '../../function/underline_text/pod.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../panel/widget.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';
import 'editable_word.dart';

class InstructionDialog extends PanelWidget {
  const InstructionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DefaultTextTheme textTheme = DefaultTextTheme();
    final InstructionNotifier notifier = ref.watch(instructionNotifierProvider);
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      child: Container(
        decoration: BoxDecoration(
          gradient: ref.read(gradientProvider(color: [seaWhite, azureGreen])),
        ),
        padding: EdgeInsets.fromLTRB(7.5.r, 15.r, 7.5.r, 45.r),
        constraints: BoxConstraints(maxWidth: 540.r),
        child: LayoutBuilder(
          builder: (_, constraints) => FadeIn(
            delay: const Duration(milliseconds: 300),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText("How to Play", style: textTheme.headlineLarge),
                  Gap(15.r),
                  for (UnderlineText underline in ref.read(howPlayProvider))
                    InstructionTile(underline.text, constraints.maxWidth * 0.9),
                  Gap(15.r),
                  ...notifier.displayed.map(
                    (e) => FadeIn(
                      key: ValueKey(e),
                      child: EditableWord(Word(value: e), initialised: false),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double height() => 720.r;

  @override
  SlideDirection direction() => SlideDirection.UP;

  @override
  bool backdropEnabled() => true;
}

/*Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 12.r),
                        child: Icon(
                          Icons.circle,
                          color: midnightGreen,
                          size: 9.r,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 7.5.r),
                        width: constraints.maxWidth * 0.9,
                        child: Text(
                          underline.text,
                          style: defaultTextTheme.bodySmall
                              ?.copyWith(color: raisinBlack),
                        ),
                      ),
                    ],
                  )*/
/*RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      for (UnderlineText underline in list)
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "⚫️ ",
                              style: defaultTextTheme.emojiSmall.copyWith(
                                fontSize: 4.5.r,
                              ),
                            ),
                            const TextSpan(text: "  "),
                            TextSpan(text: underline.text),
                            const TextSpan(text: "\n")
                          ],
                        ),
                    ],
                    style:
                        defaultTextTheme.bodySmall?.copyWith(color: cadetGray),
                  ),
                ),
                Text(
                  "Find the words without looking at hints.",
                  style: defaultTextTheme.headlineSmall?.copyWith(
                    height: 0,
                    color: raisinBlack,
                  ),
                ),
                Center(
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 750),
                    child: SizedBox.square(
                      dimension: 300.r,
                      child: Lottie.asset('lottie/share.json'),
                    ),
                  ),
                ),*/

class InstructionTile extends StatelessWidget {
  final String text;
  final double width;
  const InstructionTile(this.text, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();

    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12.r),
          child: Icon(Icons.circle, color: midnightGreen, size: 7.5.r),
        ),
        Container(
          padding: EdgeInsets.only(left: 7.5.r),
          width: width,
          child: Text(
            text,
            style: defaultTextTheme.bodySmall?.copyWith(color: raisinBlack),
          ),
        ),
      ],
    );
  }
}

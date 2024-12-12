import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../function/instruction_notifier.dart';
import '../../function/underline_text/pod.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../panel/widget.dart';
import '../../router/router.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';
import 'editable_word.dart';

class InstructionDialog extends PanelWidget {
  const InstructionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InstructionNotifier notifier = ref.watch(instructionNotifierProvider);
    final List<String> displayedText = notifier.displayed;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        gradient: ref.read(gradientProvider(color: [seaWhite, azureGreen])),
      ),
      padding: EdgeInsets.fromLTRB(7.5.r, 15.r, 7.5.r, 45.r),
      constraints: BoxConstraints(maxWidth: 600.r),
      child: LayoutBuilder(
        builder: (_, constraints) => FadeIn(
          delay: const Duration(milliseconds: 300),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*  AutoSizeText(
                        "How to play",
                        style: textTheme.headlineLarge,
                      ),*/
                      Spacer(),
                      InkWell(
                        onTap: () => ref.read(routerProvider).pop(),
                        child: Icon(Icons.close),
                      )
                      /*  InkWell(
                        onTap: () async {
                          final pref = await ref.read(sharedProvider.future);
                          pref.setBool('how_to_play', true).whenComplete(
                              () => ref.read(routerProvider).pop());
                        },
                        child: Text(
                          "I UNDERSTAND",
                          style: textTheme.headlineSmall?.copyWith(
                            color: midnightGreen,
                            letterSpacing: 0.36,
                          ),
                        ),
                      )*/
                    ],
                  ),
                ),
                Gap(15.r),
                // for (UnderlineText underline in ref.read(howPlayProvider))
                //   InstructionTile(underline.text, constraints.maxWidth * 0.9),
                // Gap(15.r),
                ...List.generate(
                  4,
                  (index) {
                    final int len = displayedText.length;
                    if (len <= index) return SizedBox(height: 72.h);
                    final String str = notifier.displayed[index];
                    final bool enabled = index == len - 1 || index == len - 2;
                    return InstructionWord(str: str, enabled: enabled);
                  },
                ),
                Gap(15.r),
                ...List.generate(
                  4,
                  (index) {
                    final UnderlineText underline =
                        ref.read(howPlayProvider)[index];
                    return FadeIn(
                      delay: const Duration(milliseconds: 6000),
                      child: InstructionTile(
                        underline.text,
                        constraints.maxWidth * 0.9,
                        hint: index == 3,
                      ),
                    );
                  },
                )
                // for (UnderlineText underline in ref.read(howPlayProvider))
                //   InstructionTile(underline.text, constraints.maxWidth * 0.9),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double height() => 750.r;

  @override
  SlideDirection direction() => SlideDirection.UP;

  @override
  bool backdropEnabled() => true;
}

class InstructionWord extends StatelessWidget {
  const InstructionWord({super.key, required this.str, required this.enabled});

  final String str;
  final bool enabled;

  @override
  Widget build(BuildContext context) => FadeIn(
        key: ValueKey(str),
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.15,
          duration: const Duration(milliseconds: 150),
          child: EditableWord(Word(value: str)),
        ),
      );
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
  final bool hint;
  const InstructionTile(this.text, this.width, {this.hint = false, super.key});

  @override
  Widget build(BuildContext context) {
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();

    return Container(
      margin: EdgeInsets.only(top: 7.5.r),
      child: Wrap(
        children: [
          SizedBox(
            width: width,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "*   "),
                  if (hint)
                    WidgetSpan(
                      child: SizedBox.square(
                        dimension: 45.r,
                        child: Lottie.asset("question_lottie".tr()),
                      ),
                    ),
                  TextSpan(text: text)
                ],
                style: defaultTextTheme.kanitSmall.copyWith(color: raisinBlack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

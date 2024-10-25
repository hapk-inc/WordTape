import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordtape/theme/font.dart';

import '../../function/date_selected/date_selected.dart';
import '../../function/question/notifier.dart';
import '../../model/prompt.dart';
import '../../theme/color.dart';

class PromptWidget extends ConsumerWidget {
  const PromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(dateSelectedProvider);
    final Prompt prompt = ref.watch(questionNotifierProvider(date)).prompt;

    List<String> words = prompt.text.text.split(' ');
    List<String> highlighter = (prompt.text.focused ?? "").split(' ');

    final DefaultTextTheme textTheme = DefaultTextTheme();

    final bool isEmoji = highlighter.any(
      (char) => RegExp("regex_emoji".tr()).hasMatch(char),
    );

    debugPrint("30==$highlighter");
    debugPrint("30==$isEmoji");

    return AnimatedSwitcher(
      duration: Duration.zero,
      transitionBuilder: (child, _) => child,
      child: FadeInUp(
        from: 15.h,
        delay: const Duration(milliseconds: 600),
        key: ValueKey(prompt),
        child: AutoSizeText.rich(
          TextSpan(
            children: [
              for (String word in words)
                TextSpan(
                  text: word + (word != words.last ? " " : ""),
                  style: highlighter.contains(word)
                      ? isEmoji
                          ? textTheme.emojiTheme
                          : const TextStyle(color: selectiveYellow)
                      : null,
                ),
            ],
          ),
          maxLines: 2,
          presetFontSizes: [21.r, 18.r, 15.r, 12.r],
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium!.copyWith(color: celadon),
        ),
      ),
    );
  }
}

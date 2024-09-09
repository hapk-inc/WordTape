import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/welcome.dart';
import '../theme/color.dart';

class SeeArchive extends ConsumerWidget {
  const SeeArchive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Welcome sentence = ref.read(archiveTextProvider);
    List<String> words = sentence.text.split(' ');
    List<String> highlighter = (sentence.highlight ?? "").split(' ');
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.r),
      child: FadeInUp(
        delay: const Duration(milliseconds: 600),
        from: 45.h,
        key: ValueKey(sentence),
        child: AutoSizeText.rich(
          TextSpan(
            children: [
              for (String word in words)
                TextSpan(
                  text: word + (word != words.last ? " " : ""),
                  style: highlighter.contains(word)
                      ? textTheme.titleLarge?.copyWith(color: slateGray)
                      : null,
                ),
            ],
          ),
          maxLines: 2,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
            height: 1.8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

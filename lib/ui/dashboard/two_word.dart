import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../enum/pod.dart';
import '../../model/word.dart';
import '../puzzle/word_text_field.dart';

class TwoWord extends StatelessWidget {
  final DateTime date;
  final List<Word> words;
  const TwoWord(this.date, this.words, {super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: const Duration(milliseconds: 1500),
      key: ValueKey(date),
      child: Wrap(
        spacing: 15.r,
        children: List.generate(
          words.length,
          (index) {
            final Word w = words[index];
            return WordTextField(
              index,
              words[index],
              needToDo: words.last == w ? NeedToDo.onClick : NeedToDo.plain,
            );
          },
        ),
      ),
    );
  }
}

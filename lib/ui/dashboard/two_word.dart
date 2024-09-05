import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../enum/pod.dart';
import '../../model/word.dart';
import '../puzzle/word_text_field.dart';

class TwoWord extends StatelessWidget {
  final DateTime date;
  final List<Word> twoWord;
  const TwoWord(this.date, this.twoWord, {super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: const Duration(milliseconds: 2400),
      key: ValueKey(date),
      child: Wrap(
        spacing: 15.r,
        children: List.from(twoWord.map(
          (w) => WordTextField(
            w,
            needToDo: twoWord.last == w ? NeedToDo.onClick : NeedToDo.plain,
          ),
        )),
      ),
    );
  }
}

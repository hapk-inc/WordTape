import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../extension/extension.dart';

import '../../function/auth/pod.dart';
import '../../function/date_selected/date_selected.dart';
import '../../function/firestore/pod.dart';
import '../../function/question/notifier.dart';
import '../../model/found.dart';
import '../../model/question.dart';
import '../../model/word.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import 'package:badges/badges.dart' as badge;

class PrevQuestion extends ConsumerWidget {
  const PrevQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
        height: 210.r,
        child: FirestoreListView.separated(
          scrollDirection: Axis.horizontal,
          pageSize: 2,
          query: ref.read(prevQuestionQueryProvider),
          padding: EdgeInsets.only(left: 30.r),
          itemBuilder: (_, doc) => PrevQuestionTile(doc.data()),
          separatorBuilder: (context, index) => Gap(15.r),
        ),
      );
}

class PrevQuestionTile extends ConsumerWidget {
  final Question question;
  const PrevQuestionTile(this.question, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DefaultTextTheme textTheme = DefaultTextTheme();
    final QuestionNotifier notifier =
        ref.watch(questionNotifierProvider(question.date));
    final List<Word> search = question.searchWord(notifier.found);
    final User? fUser = ref.watch(runningUserProvider).value;
    final bool isCompleted = question.win.contains(fUser?.uid);
    final Found found = notifier.found;

    return badge.Badge(
      showBadge: isCompleted,
      badgeStyle: badge.BadgeStyle(
        badgeColor: Colors.blue,
        padding: EdgeInsets.all(7.5.r),
        elevation: 7.5.r,
      ),
      badgeContent: SizedBox.square(dimension: 15.r),
      position: badge.BadgePosition.topEnd(top: 15.r, end: 15.r),
      child: Container(
        width: 180.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5.r),
          border:
              !isCompleted ? Border.all(color: silver, width: 0.75.r) : null,
          color: isCompleted ? Colors.lightBlue.shade50 : null,
        ),
        padding: EdgeInsets.all(15.r),
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            final DateTime date = question.date.convert();
            ref.read(dateSelectedProvider.notifier).state = date;
            context.push('/decode', extra: date);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(7.5.r),
                Text(
                  DateFormat('MMMM dd').format(question.date),
                  style: textTheme.headlineSmall?.copyWith(
                    color: cadetGray,
                    height: 2.1,
                    fontSize: 15.r,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                AutoSizeText.rich(
                  TextSpan(
                    children: [
                      if (search.isNotEmpty)
                        TextSpan(
                          text: search[0].value,
                          children: [
                            TextSpan(text: "❓", style: textTheme.emojiSmall),
                          ],
                        )
                      else
                        const TextSpan(text: "Completed")
                    ],
                  ),
                  style: textTheme.poppinsTheme.copyWith(
                    color: raisinBlack,
                    height: 1.5,
                  ),
                  maxLines: 1,
                  presetFontSizes: [21.r, 18.r, 15.r],
                ),
                Container(
                  height: 60.r,
                  margin: EdgeInsets.symmetric(vertical: 7.5.r),
                  alignment: Alignment.centerLeft,
                  child: found.i == 0
                      ? null
                      : AutoSizeText.rich(
                          TextSpan(
                            children: [
                              if (found.i != 1)
                                ...[
                                  for (int i = 0; i <= found.i - 1; i++)
                                    found.untilNow.containsKey(i) ? "🟧" : "🟩",
                                ].map(
                                  (e) => TextSpan(text: e),
                                )
                            ],
                            style: textTheme.emojiSmall,
                          ),
                          presetFontSizes: [21.r, 18.r, 15.r],
                          maxLines: 1,
                        ),
                  // color: cerise,
                ),
                AutoSizeText(
                  question.played == 0
                      ? "No one started yet"
                      : "${question.played} users played",
                  maxLines: 1,
                  style: textTheme.bodySmall,
                  presetFontSizes: [15.r, 12.r, 9.r],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

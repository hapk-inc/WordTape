import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../extension/extension.dart';

import '../../function/date_selected/date_selected.dart';
import '../../function/firestore/pod.dart';
import '../../function/question/notifier.dart';
import '../../model/found.dart';
import '../../model/question.dart';
import '../../model/word.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';
// import 'package:badges/badges.dart' as badge;

class PrevQuestion extends ConsumerWidget {
  const PrevQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
        height: 210.r,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            final DateTime now = DateTime.now();
            final DateTime date =
                now.subtract(Duration(days: index + 1)).convert();

            return PrevQuestionTile(date);
          },
        ),
        /*child: FirestoreListView(
          scrollDirection: Axis.horizontal,
          query: ref.watch(prevQuestionQueryProvider),
          padding: EdgeInsets.only(left: 30.r),
          itemBuilder: (_, doc) => PrevQuestionTile(doc.data()),
        ),*/
      );
}

class PrevQuestionTile extends ConsumerWidget {
  final DateTime date;
  const PrevQuestionTile(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DefaultTextTheme textTheme = DefaultTextTheme();
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final List<Word> search = notifier.searchWord;

    final bool isCompleted = notifier.done;
    final Found found = notifier.found;
    final Question? question = notifier.question;
    if (question == null) return SizedBox();

    return Container(
      width: 210.r,
      decoration: BoxDecoration(
          border: Border.all(
            color: isCompleted ? midnightGreen : silver,
            width: 0.45.r,
          ),
          borderRadius: BorderRadius.circular(7.5.r),
          gradient: isCompleted
              ? ref.read(
                  gradientProvider(
                    color: [...List.filled(9, celeste), aquaMarine],
                  ),
                )
              : null
          // color: isCompleted ? lightCyan : null,
          ),
      padding: EdgeInsets.all(15.r),
      margin: EdgeInsets.symmetric(horizontal: 7.5.r),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          ref.read(dateSelectedProvider.notifier).state = date;
          context.go('/decode', extra: date);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(7.5.r),
              Text(
                DateFormat('MMMM dd').format(date),
                style: textTheme.headlineSmall?.copyWith(color: raisinBlack),
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
                style: textTheme.headlineSmall
                    ?.copyWith(color: isCompleted ? raisinBlack : null),
                presetFontSizes: [15.r, 12.r, 9.r],
              ),
            ],
          ),
        ),
      ),
    );

    /*return badge.Badge(
      showBadge: isCompleted,
      badgeStyle: badge.BadgeStyle(
        badgeColor: midnightGreen,
        padding: EdgeInsets.all(7.5.r),
        elevation: 7.5.r,
      ),
      badgeContent: SizedBox.square(
        dimension: 30.r,
        child: Center(
          child: Lottie.asset('lottie/trophy.json'),
        ),
      ),
      position: badge.BadgePosition.topEnd(top: 15.r, end: 15.r),
      child: Container(
        width: 210.r,
        decoration: BoxDecoration(
            border:
                !isCompleted ? Border.all(color: silver, width: 0.45.r) : null,
            gradient: isCompleted
                ? ref.read(gradientProvider(color: [celeste, azureGreen]))
                : null
            // color: isCompleted ? lightCyan : null,
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
                  style: textTheme.headlineSmall,
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
                  style: textTheme.headlineSmall,
                  presetFontSizes: [15.r, 12.r, 9.r],
                ),
              ],
            ),
          ),
        ),
      ),
    );*/
  }
}

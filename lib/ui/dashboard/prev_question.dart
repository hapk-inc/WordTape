import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../extension/extension.dart';

import '../../function/question/notifier.dart';
import '../../model/found.dart';
import '../../model/question.dart';
import '../../model/word.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';

class PrevQuestion extends ConsumerWidget {
  const PrevQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Theme(
        data: ThemeData(scrollbarTheme: ScrollbarThemeData(interactive: false)),
        child: SizedBox(
          height: 210.r,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 15.r),
            children: [
              ...List.generate(
                7,
                (index) {
                  final DateTime now = DateTime.now();
                  final DateTime date =
                      now.subtract(Duration(days: index + 1)).onlyYYYYMMMDD;

                  return PrevQuestionTile(date);
                },
              ),
              /*Container(
                width: 420.r,
                decoration: BoxDecoration(
                  color: cerise,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.r),
              )*/
            ],
          ),
        ),
      );
}

/*  child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 40,
            padding: EdgeInsets.only(left: 15.r),
            itemBuilder: (context, index) {
              final DateTime now = DateTime.now();
              final DateTime date =
                  now.subtract(Duration(days: index + 1)).onlyYYYYMMMDD;

              return PrevQuestionTile(date);
            },
          ),*/

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
            color: isCompleted ? midnightGreen : azureGreen,
            width: 0.45.r,
          ),
          borderRadius: BorderRadius.circular(15.r),
          gradient: isCompleted
              ? ref.read(gradientProvider(color: [...List.filled(2, celeste)]))
              : LinearGradient(colors: [...List.filled(5, azureGreen)])
          // color: isCompleted ? lightCyan : null,
          ),
      padding: EdgeInsets.all(15.r),
      margin: EdgeInsets.symmetric(horizontal: 7.5.r),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          final String formatDate = DateFormat('dd-MMM-yyyy').format(date);
          context.go('/daily-challenge/$formatDate');
        },
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(7.5.r),
              Text(
                DateFormat('MMMM dd').format(date),
                style: textTheme.kanitSmall.copyWith(color: midnightGreen),
              ),
              AutoSizeText.rich(
                TextSpan(
                  children: [
                    if (search.isNotEmpty)
                      TextSpan(
                        text: search[0].value,
                        children: [
                          TextSpan(
                            text: "❓",
                            style:
                                textTheme.emojiSmall.copyWith(fontSize: 18.r),
                          ),
                        ],
                      )
                    else
                      const TextSpan(text: "Completed")
                  ],
                ),
                style: textTheme.headlineMedium?.copyWith(
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
                            ...List.of(
                              notifier.summary.map((e) => TextSpan(text: e)),
                            ),
                          ],
                          style: textTheme.emojiSmall,
                        ),
                        presetFontSizes: [21.r, 18.r, 15.r],
                        maxLines: 1,
                      ),
              ),
              Row(
                children: [
                  AutoSizeText(
                    question.played == 0
                        ? "No one started yet"
                        : "${question.played} users played",
                    maxLines: 1,
                    style: textTheme.kanitMedium.copyWith(
                      color: isCompleted ? englishViolet : null,
                    ),
                    presetFontSizes: [15.r, 12.r, 9.r],
                  ),
                  Spacer(),
                  SizedBox.square(
                    dimension: 30.r,
                    child: Lottie.asset("lottie/trophy.json"),
                  ),
                  Text(
                    "${question.win.length}",
                    style: textTheme.bodySmall
                        ?.copyWith(color: isCompleted ? raisinBlack : null),
                  )
                ],
              ),
              Gap(300.r),
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

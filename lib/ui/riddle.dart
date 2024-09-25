import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../theme/color.dart';

class RiddlePage extends ConsumerWidget {
  final DateTime date;
  const RiddlePage(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[midnightGreen, gunMetal],
        ),
      ),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 90.h,
            title: const Text("WORDTAPE"),
            actions: [
              SizedBox.square(
                dimension: 75.r,
                child: Lottie.asset("lottie/bulb.json"),
              ),
            ],
            titleTextStyle: textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}

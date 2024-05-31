import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../logic/auth/bloc.dart';
import '../../logic/app/dashboard_notifier.dart';
import '../../theme/colors.dart';
import '../../theme/text_theme.dart';

MyTextTheme _textTheme = MyTextTheme();

class PuzzleCalendar extends ConsumerWidget {
  const PuzzleCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // context.router.current.args
    //final DateTime now = DateTime.now();
    final DateTime now = ref.watch(appNotifierProvider).dateTime;
    return AppBar(
      leadingWidth: 150.r,
      leading: Center(
        child: InkWell(
          child: Text(
            //"MAY 11, 2024",
            DateFormat.yMMMd().format(now).toUpperCase(),
            style: _textTheme.headlineMedium?.copyWith(color: teal),
          ),
        ),
      ),
      //actionsIconTheme: const IconThemeData(color: slateGray, size: 24),
      actions: [
        if (kDebugMode) ...[
          IconButton(
            onPressed: () => ref.read(signOutProvider),
            icon: const Icon(Icons.settings),
          ),
          const Gap(7.5)
        ]
      ],
    );
  }
}

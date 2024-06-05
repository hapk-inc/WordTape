import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../logic/app/device_size.dart';
import '../../logic/app/panel.dart';
import '../../logic/auth/auth_notifier.dart';
import '../../model/panel_widget.dart';
import '../../theme/colors.dart';
import 're_login_dialog.dart';

class PuzzleCalendar extends ConsumerWidget {
  const PuzzleCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leadingWidth: 135.r,
      leading: const PuzzleDate(),
      actions: const [SubscribeButton(), Gap(15)],
    );
  }
}

class PuzzleDate extends ConsumerWidget {
  const PuzzleDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthNotifier authNotifier = ref.watch(authNotifierProvider);
    final String str = DateFormat.yMMMd().format(authNotifier.dateTime);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Text(
        str.toUpperCase(),
        style: textTheme.headlineMedium?.copyWith(color: teal),
      ),
    );
  }
}

class SubscribeButton extends ConsumerWidget {
  const SubscribeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(xantHous),
        ),
        onPressed: () {
          if (ref.read(deviceSizeProvider) >= 2.0) {
            ref.read(panelNotifierProvider.notifier).state = PanelWidget(
              height: 360.r,
              child: const ReLoginDialog(),
            );
            ref.read(dashboardPanelProvider).open();
          } else {}
        },
        child: const Text(
          "SUBSCRIBE",
          style: TextStyle(color: engineeringOrange),
        ),
      );
}

/* onPressed: () {
            final double ratio = 900.h / 360.w;
            if (ratio > 2) {
              ref.read(panelNotifierProvider.notifier).state = PanelWidget(
                height: 210.r,
                child: const LoginDialogState(),
              );
              final PanelController panel = ref.read(dashboardPanelProvider);
              if (panel.isPanelClosed) panel.open();
            } else {
              showDialog(
                context: context,
                builder: (_) => const LoginDialog(),
              );
            }
          },*/

/*
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wordtape/router/my_route.dart';

import '../../logic/auth/bloc.dart';
import '../../logic/app/app_notifier.dart';
import '../../theme/colors.dart';
import '../../theme/text_theme.dart';

MyTextTheme _textTheme = MyTextTheme();

class PuzzleCalendar extends ConsumerWidget {
  const PuzzleCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = ref.watch(appNotifierProvider).dateTime;
    return AppBar(
      leadingWidth: 120.r,
      leading: Center(
        child: InkWell(
          child: Text(
            DateFormat.yMMMd().format(now).toUpperCase(),
            style: _textTheme.headlineMedium?.copyWith(color: teal),
          ),
        ),
      ),
      actions: [
        if (kDebugMode) ...[
          IconButton(
            onPressed: () => context.router.push(const HowToPlayRoute()),
            icon: const Icon(Icons.info),
          ),
          const Gap(7.5)
        ],
        if (kDebugMode) ...[
          IconButton(
            onPressed: () => ref.read(signOutProvider),
            icon: const Icon(Icons.settings),
          ),
          const Gap(7.5),
        ]
      ],
    );
  }
}
*/

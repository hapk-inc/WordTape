import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/puzzle/found_notifier.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';

class BoardAppBar extends ConsumerWidget {
  const BoardAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leadingWidth: 60.r,
      //title: Text("No. ${mockInteger(1, 10)}"),
      actions: [
        TextButton(
          onPressed: () => context.router.push(HowToPlayRoute()),
          child: Text(
            "HOW TO PLAY",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: ashGray),
          ),
        ),
        if (kDebugMode)
          IconButton(
            onPressed: () => ref.read(foundNotifierProvider.notifier).delete(),
            icon: const Icon(Icons.delete, color: ashGray),
          ),
      ],
    );
  }
}

/* if (kDebugMode)
                              IconButton(
                                onPressed: () => ref
                                    .read(foundNotifierProvider.notifier)
                                    .delete(),
                                icon: const Icon(Icons.delete, color: ashGray),
                              ),
                            const Gap(7.5),
                            if (kDebugMode)
                              IconButton(
                                onPressed: () {
                                  final double ratio = 900.h / 360.w;
                                  if (ratio > 2) {
                                    ref
                                        .read(panelNotifierProvider.notifier)
                                        .state = PanelWidget(
                                      height: 360.r,
                                      child: const ReLoginDialog(),
                                    );
                                    boardPanel.open();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 4.5.r),
                                        contentPadding: EdgeInsets.all(15.r),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.5.r)),
                                        backgroundColor: greenWhite,
                                        content: const ReLoginDialog(),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.chair, color: ashGray),
                              ),*/

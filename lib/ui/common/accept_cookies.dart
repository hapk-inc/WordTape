import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mock_data/mock_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../enum/enum.dart';
import '../../panel/widget.dart';
import '../../shared/shared.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';

class AcceptCookie extends PanelWidget {
  const AcceptCookie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();
    final int number = mockInteger(0, 4);
    final ScreenSize size = ref.watch(sizeProvider);
    final isM = size == ScreenSize.mobile;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600.r,
          maxHeight: !isM ? 240.r : height(),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: ref.read(
              gradientProvider(color: [seaWhite, azureGreen]),
            ),
          ),
          padding: EdgeInsets.all(15.r),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${"cookie_$number".tr()} ",
                        style: const TextStyle(color: tyrianPurple),
                      ),
                      TextSpan(text: "🍪", style: defaultTextTheme.emojiTheme),
                    ],
                  ),
                  style: defaultTextTheme.montserratLarge,
                  maxLines: 1,
                ),
                Gap(7.5.r),
                Text(
                  "cookie_info_$number".tr(),
                  style: defaultTextTheme.bodySmall?.copyWith(color: slateGray),
                ),
                Gap(30.r),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final SharedPreferences pref =
                            await ref.read(sharedProvider.future);
                        pref.setBool('accept_cookies', true).whenComplete(
                          () {
                            NavigatorState? navigatorState =
                                Navigator.of(context);
                            navigatorState.pop();
                          },
                        );
                      },
                      child: const Text("Accept"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double height() => 300.r;

  @override
  SlideDirection direction() => SlideDirection.UP;
}

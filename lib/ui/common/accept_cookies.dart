import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../enum/enum.dart';
import '../../function/underline_text/pod.dart';
import '../../model/underline_text.dart';
import '../../panel/widget.dart';
import '../../router/router.dart';
import '../../shared/shared.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';

class AcceptCookie extends PanelWidget {
  const AcceptCookie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isPC = size == ScreenSize.pc;
    //final isM = size == ScreenSize.mobile;
    final UnderlineText cookieInfo = ref.read(cookieInfoProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600.r,
          maxHeight: isPC ? 240.r : height(),
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
                Gap(15.r),
                AutoSizeText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: cookieInfo.text,
                        style: const TextStyle(color: tyrianPurple),
                      ),
                      TextSpan(text: "🍪", style: defaultTextTheme.emojiTheme),
                    ],
                  ),
                  style: defaultTextTheme.montserratLarge,
                  maxLines: 1,
                ),
                Gap(15.r),
                Text(
                  cookieInfo.focused ?? "",
                  style: defaultTextTheme.bodySmall?.copyWith(color: slateGray),
                ),
                Gap(30.r),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final pref = await ref.read(sharedProvider.future);
                        pref.setBool('accept_cookies', true).whenComplete(
                              () => ref.read(routerProvider).pop(),
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

  @override
  bool backdropEnabled() => false;
}

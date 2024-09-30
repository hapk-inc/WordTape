import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mock_data/mock_data.dart';
import '../../function/auth/pod.dart';
import '../../panel/widget.dart';
import '../../theme/color.dart';

class LogoutPanel extends PanelWidget {
  const LogoutPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String str = "logout_${mockInteger(0, 9)}".tr();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height(),
      color: seaWhite,
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 30.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            str,
            style: textTheme.bodyMedium?.copyWith(
              color: slateGray,
              height: 1.8,
            ),
            maxLines: 1,
          ),
          Gap(4.5.r),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => ref.read(signingOffProvider),
                child: Text(
                  "LOGOUT",
                  style: textTheme.headlineLarge?.copyWith(color: blackBean),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  double height() => 150.r;
}

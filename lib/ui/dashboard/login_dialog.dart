import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../logic/auth/bloc.dart';
import '../../theme/colors.dart';

class LoginDialog extends ConsumerWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 4.5.r),
      contentPadding: EdgeInsets.all(15.r),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5.r)),
      backgroundColor: greenWhite,
      content: const LoginDialogState(),
    );
  }
}

class LoginDialogState extends ConsumerWidget {
  const LoginDialogState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double ratio = 900.h / 360.w;
    return Container(
      width: 540.r,
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      height: 180.r,
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: textTheme.titleMedium?.copyWith(color: raisinBlack),
            ),
            Gap(12.r),
            const Text(
              "Login with one of the following options.",
              style: TextStyle(color: slateGray),
            ),
            Gap(30.h),
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 9.r,
                alignment: WrapAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => ref.read(googleLoginProvider).when(
                          data: (data) {
                            debugPrint("Google Done");
                          },
                          error: (error, stackTrace) {
                            debugPrint(error.toString());
                          },
                          loading: () => debugPrint("Loading Google"),
                        ),
                    child: Text(
                      ratio > 2 ? "GOOGLE" : "GOOGLE ACCOUNT",
                      style: const TextStyle(color: filledColor),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => ref.read(appleLoginProvider).when(
                          data: (data) => debugPrint("Loading $data"),
                          error: (error, stackTrace) =>
                              debugPrint("Loading $error"),
                          loading: () => debugPrint("Loading"),
                        ),
                    child: const Text(
                      "APPLE ACCOUNT",
                      style: TextStyle(color: payneGray),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

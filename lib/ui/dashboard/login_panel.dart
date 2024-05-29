import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import 'login_dialog.dart';

final BorderRadius _topPanel =
    BorderRadius.vertical(top: Radius.circular(15.r));

class LoginPanel extends StatelessWidget {
  const LoginPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(color: seaSalt, borderRadius: _topPanel),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoginDialog(),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: "By signing up, you agree to the "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: const TextStyle(color: teal),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
                style: textTheme.bodyMedium?.copyWith(color: ashGray),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

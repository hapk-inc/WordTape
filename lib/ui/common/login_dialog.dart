import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

/*
class LoginDialog extends ConsumerWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Login with below options",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: teal),
        ),
        Gap(15.h),
        Wrap(
          spacing: 15.r,
          children: [
            LoginButton(
              onClick: () {},
              child: Icon(Icons.apple),
            ),
            LoginButton(
              onClick: () {},
              child: Padding(
                padding: EdgeInsets.all(3.6.r),
                child: Image.asset('images/gLogo.png'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
*/

class LoginButton extends StatelessWidget {
  final VoidCallback? onClick;
  final Widget child;
  final Color borderColor;

  const LoginButton({
    required this.onClick,
    required this.child,
    this.borderColor = filledColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onClick,
        iconSize: 30.r,
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size.square(30.r)),
          backgroundColor: const WidgetStatePropertyAll(seaSalt),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 0.075.r),
              borderRadius: BorderRadius.circular(7.5.r),
            ),
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.all(7.5.r)),
        ),
        color: payneGray,
        icon: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.square(30.r)),
          child: child,
        ),
      );
}

/*
class LoginDialog extends ConsumerWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(15.h),
        Container(
          height: 60.h,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            initialValue: mockName(),
            enabled: true,
            //expands: true,
            minLines: 1,
            maxLines: 1,
            maxLength: 30,
            scrollPadding: EdgeInsets.zero,
            decoration: const InputDecoration(
              counter: SizedBox.square(dimension: 0.15),
              contentPadding: EdgeInsets.zero,
            ),
            cursorColor: raisinBlack,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: raisinBlack),
            //cursorWidth: 0.9.r,
          ),
        ),
        Gap(15.r),
        Wrap(
          children: [
            */
/* LoginButton(
              onClick: () {},
              child: Icon(Icons.mail_sharp, color: payneGray),
            ),*/ /*

            OutlinedButton(
              onPressed: () {},
              child: const Text(
                "GOOGLE SIGN-IN",
                style: TextStyle(color: filledColor),
              ),
            )
          ],
        ),
        */
/* Gap(15.r),
        Container(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(teal),
                foregroundColor: WidgetStatePropertyAll(greenWhite)),
            onPressed: () {},
            child: const Text("CREATE YOUR ACCOUNT"),
          ),
        )*/ /*

      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback? onClick;
  final Widget child;
  final Color borderColor;

  const LoginButton({
    required this.onClick,
    required this.child,
    this.borderColor = filledColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onClick,
        iconSize: 33.r,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 0.45.r),
              borderRadius: BorderRadius.circular(7.5.r),
            ),
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.all(7.5.r)),
        ),
        icon: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.square(36.r)),
          child: child,
        ),
      );
}
*/

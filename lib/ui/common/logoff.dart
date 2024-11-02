import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../function/auth/pod.dart';
import '../../panel/pod.dart';
import '../../panel/widget.dart';
import '../../theme/color.dart';

class LogoffAlert extends PanelWidget {
  const LogoffAlert({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height(),
      color: seaWhite,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.r),
      constraints: BoxConstraints(maxWidth: 450.r),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OverflowBar(
              children: List.from(
                ["LOGOUT", "STAY LOGGED IN"].map(
                  (e) {
                    final bool logout = e == "LOGOUT";
                    return TextButton(
                      onPressed: () {
                        if (logout) ref.read(signingOffProvider);
                        final PanelController controller =
                            ref.read(panelControllerProvider);
                        if (controller.isAttached) controller.close();
                      },
                      child: Text(
                        e,
                        style: textTheme.headlineMedium?.copyWith(
                          color: logout ? gunMetal : Colors.black26,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  double height() => 105.r;

  @override
  SlideDirection direction() => SlideDirection.DOWN;

  @override
  bool backdropEnabled() => true;
}

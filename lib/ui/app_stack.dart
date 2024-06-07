import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../logic/app/bloc.dart';
import '../theme/colors.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

@RoutePage()
class AppStackPage extends ConsumerWidget {
  const AppStackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool onlyPrivacyPolicy =
        kIsWeb && (context.router.currentPath == "/privacy-policy-route");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: prussianBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                color: greenWhite,
                constraints: BoxConstraints(maxWidth: 450.r),
                child: const AutoRouter(),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: onlyPrivacyPolicy ? 480.r : 450.r),
                child: SlidingUpPanel(
                  controller: ref.read(panelControllerProvider),
                  backdropColor: raisinBlack,
                  //padding: EdgeInsets.all(24.r),
                  backdropEnabled: true,
                  isDraggable: false,
                  backdropOpacity: 0.75,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.r),
                  ),
                  //panel: const SubscribeDialog(),
                  panel: ref.watch(panelNotifierProvider),
                  onPanelClosed: () {
                    ref.read(panelNotifierProvider.notifier).state =
                        const SizedBox();
                    /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Text(
                              "Create account with",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: greenWhite),
                            ),
                            Gap(15.r),
                            LoginButton(
                              onClick: () => ref.read(googleLoginProvider),
                              child: Padding(
                                padding: EdgeInsets.all(3.6.r),
                                child: Image.asset('images/gLogo.png'),
                              ),
                            ),
                            Gap(1.5.r),
                            LoginButton(
                              onClick: () {},
                              child: const Icon(Icons.apple),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(
                          bottom: 30.h,
                          top: 15.h,
                          left: 15.r,
                        ),
                      ),
                    );*/
                  },
                  body: const SizedBox(),
                  minHeight: 0,
                  maxHeight: 330.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

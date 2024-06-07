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
      resizeToAvoidBottomInset: false,
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
                constraints: BoxConstraints(
                    maxWidth: onlyPrivacyPolicy ? double.maxFinite : 450.r),
                child: SlidingUpPanel(
                  controller: ref.read(panelControllerProvider),
                  backdropColor: raisinBlack,
                  padding: EdgeInsets.all(15.r),
                  backdropEnabled: true,
                  backdropOpacity: 0.75,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.r),
                  ),
                  //panel: const SubscribeDialog(),
                  panel: ref.watch(panelNotifierProvider),
                  onPanelClosed: () {
                    ref.read(panelNotifierProvider.notifier).state =
                        const SizedBox();
                  },
                  body: const SizedBox(),
                  minHeight: 0,
                  maxHeight: 360.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

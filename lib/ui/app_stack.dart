import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../logic/app/bloc.dart';
import '../theme/colors.dart';

@RoutePage()
class AppStackPage extends ConsumerWidget {
  const AppStackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final bool onlyPrivacyPolicy =
    //    kIsWeb && (context.router.currentPath == "/privacy-policy-route");
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: greenWhite,
      body: SafeArea(
        child: ref.watch(deviceSizeProvider) > 2.0
            ? SlidingUpPanel(
                controller: ref.read(panelControllerProvider),
                backdropColor: raisinBlack,
                color: greenWhite,
                //padding: EdgeInsets.all(24.r),
                backdropEnabled: true,
                isDraggable: false,
                backdropOpacity: 0.75,
                padding: EdgeInsets.symmetric(horizontal: 24.r),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.r),
                ),

                //panel: const SubscribeDialog(),
                panel: ref.watch(panelNotifierProvider),
                /*panel: Stack(
            children: [
              Container(
                constraints:
                BoxConstraints.expand(width: 450.r),
                padding: EdgeInsets.symmetric(horizontal: 24.r),
                child: ref.watch(panelNotifierProvider),
              )
            ],
          ),*/
                onPanelClosed: () {
                  ref.read(panelNotifierProvider.notifier).state =
                      const SizedBox();
                },
                body: const AutoRouter(),
                minHeight: 0,
                maxHeight: 300.r,
              )
            //  ? const AutoRouter()
            : ColoredBox(
                color: prussianBlue,
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
                        constraints: BoxConstraints(maxWidth: 450.r),
                        child: SlidingUpPanel(
                          controller: ref.read(panelControllerProvider),
                          backdropColor: raisinBlack,
                          color: greenWhite,
                          //padding: EdgeInsets.all(24.r),
                          backdropEnabled: true,
                          isDraggable: false,
                          backdropOpacity: 0.75,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.r),
                          ),
                          //panel: const SubscribeDialog(),
                          //panel: ref.watch(panelNotifierProvider),
                          panel: Stack(
                            children: [
                              Container(
                                constraints:
                                    BoxConstraints.expand(width: 450.r),
                                padding: EdgeInsets.symmetric(horizontal: 24.r),
                                child: ref.watch(panelNotifierProvider),
                              )
                            ],
                          ),
                          onPanelClosed: () {
                            ref.read(panelNotifierProvider.notifier).state =
                                const SizedBox();
                          },
                          body: const SizedBox(),
                          minHeight: 0,
                          maxHeight: 300.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

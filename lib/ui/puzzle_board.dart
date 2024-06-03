import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../logic/app/panel.dart';
import '../logic/puzzle/found_notifier.dart';
import '../model/found.dart';
import '../model/panel_widget.dart';
import '../model/puzzle.dart';
import '../theme/colors.dart';
import 'board/fixed_board.dart';
import 'board/puzzle_note.dart';
import 'board/puzzle_completed.dart';
import 'dashboard/re_login_dialog.dart';

const Duration m750 = Duration(milliseconds: 750);

@RoutePage()
class PuzzleBoardPage extends ConsumerWidget {
  final Puzzle puzzle;
  const PuzzleBoardPage(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PanelController boardPanel = ref.read(boardPanelProvider);
    final PanelWidget panelWidget = ref.watch(panelNotifierProvider);
    final Found? found = ref.watch(foundNotifierProvider).valueOrNull;

    ref.listen(
      foundNotifierProvider.select((value) => value.value),
      (previous, next) {
        final double ratio = 900.h / 360.w;
        if ((next?.isCompleted ?? false) &&
            boardPanel.isPanelClosed &&
            ratio > 2) {
          ref.read(panelNotifierProvider.notifier).state = PanelWidget(
            height: 360.r,
            child: const ReLoginDialog(),
          );

          Future.delayed(m750 * 2, () => boardPanel.open());
        }
      },
      onError: (error, stackTrace) {},
    );

    return TooltipVisibility(
        visible: false,
        child: SafeArea(
          child: ColoredBox(
            color: greenWhite,
            child: LayoutBuilder(
              builder: (_, constraint) {
                final double mW = constraint.maxWidth;
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          leadingWidth: 60.r,
                          actions: [
                            if (kDebugMode)
                              IconButton(
                                onPressed: () => ref
                                    .read(foundNotifierProvider.notifier)
                                    .delete(),
                                icon: const Icon(Icons.delete, color: ashGray),
                              ),
                            const Gap(7.5),
                            if (kDebugMode)
                              IconButton(
                                onPressed: () {
                                  final double ratio = 900.h / 360.w;
                                  if (ratio > 2) {
                                    ref
                                        .read(panelNotifierProvider.notifier)
                                        .state = PanelWidget(
                                      height: 360.r,
                                      child: const ReLoginDialog(),
                                    );
                                    boardPanel.open();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 4.5.r),
                                        contentPadding: EdgeInsets.all(15.r),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.5.r)),
                                        backgroundColor: greenWhite,
                                        content: const ReLoginDialog(),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.chair, color: ashGray),
                              ),
                          ],
                        ),
                        Gap(15.h),
                        Container(
                          height: 60.h * puzzle.words.length,
                          margin: EdgeInsets.only(
                              left: mW * 0.06, right: mW * 0.045),
                          alignment: Alignment.center,
                          //color: ashGray,
                          padding: EdgeInsets.symmetric(horizontal: mW * 0.012),
                          child: const FixedBoard(),
                        ),
                        if ((found?.isCompleted ?? false)) ...[
                          Gap(30.h),
                          PuzzleCompleted(found!)
                        ] else ...[
                          const PuzzleNote()
                        ]
                      ],
                    ),
                    SlidingUpPanel(
                      backdropColor: raisinBlack,
                      padding: EdgeInsets.symmetric(horizontal: 4.5.r),
                      backdropEnabled: true,
                      backdropOpacity: 0.75,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                      minHeight: 0,
                      maxHeight: panelWidget.height,
                      controller: boardPanel,
                      panel: panelWidget.child,
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}

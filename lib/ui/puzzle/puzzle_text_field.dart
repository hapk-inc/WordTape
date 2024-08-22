import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../logic/puzzle/key.dart';
import '../../logic/puzzle/puzzle_notifier.dart';
import '../../logic/size.dart';
import '../theme/colors.dart';
import '../theme/font_function.dart';

DefaultTextTheme textTheme = DefaultTextTheme();

PinTheme _defaultPinTheme(BoxConstraints box,
    {required bool isMobile, Color color = raisinBlack}) {
  final double maxWidth = box.maxWidth;

  final double boxWidth = maxWidth * 0.0975;

  final isConstraintMeasurement = isMobile;

  return PinTheme(
    constraints: BoxConstraints(
      minWidth: isConstraintMeasurement ? boxWidth : 40.r,
      maxHeight: 45.h,
    ),
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: color, width: 0.54.r)),
    ),
    textStyle: textTheme.headlineMedium.copyWith(color: color),
  );
}

class PuzzleTextField extends ConsumerWidget {
  final int i;
  final String name;
  const PuzzleTextField(this.i, {required this.name, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    final String id = ref.read(puzzleKeyProvider);
    final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(id));
    final TextEditingController controller = notifier.textController(i);
    return LayoutBuilder(
      builder: (_, constraints) {
        return Pinput(
          length: name.length,
          key: ValueKey(name),

          //errorTextStyle: TextStyle(color: Colors.black),
          defaultPinTheme: _defaultPinTheme(
            constraints,
            isMobile: size == 'mobile',
            color: midnightGreen,
          ),

          //
          forceErrorState: true,
          errorPinTheme: _defaultPinTheme(
            constraints,
            isMobile: size == 'mobile',
            color: chestnut,
          ),

          //
          isCursorAnimationEnabled: false,
          animationDuration: const Duration(milliseconds: 150),
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          //validator: (value) {},
          //
          keyboardType: TextInputType.none,
          readOnly: true,
          showCursor: false,
          enabled: controller == notifier.activeController,

          textCapitalization: TextCapitalization.characters,
          separatorBuilder: (_) =>
              SizedBox(width: name.length > 8 ? 4.5.r : 7.5.r),
          //
          controller: controller,
        );
      },
    );
  }
}

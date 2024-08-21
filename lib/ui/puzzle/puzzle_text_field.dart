import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../logic/puzzle/found_notifier.dart';
import '../../logic/size.dart';
import '../../model/found.dart';
import '../theme/colors.dart';

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
    textStyle: GoogleFonts.play(
      fontSize: 15.r,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 0,
      color: midnightGreen,
    ),
  );
}

class PuzzleTextField extends ConsumerWidget {
  final String name;
  const PuzzleTextField(this.name, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    final Found found =
        ref.watch(foundNotifierProvider("")).value ?? const Found();
    return LayoutBuilder(
      builder: (_, constraints) {
        return Pinput(
          length: name.length,
          key: ValueKey(name),
          controller: TextEditingController(text: name),
          defaultPinTheme: _defaultPinTheme(
            constraints,
            isMobile: size == 'mobile',
            color: midnightGreen,
          ),

          //
          isCursorAnimationEnabled: true,
          pinAnimationType: PinAnimationType.fade,
          animationDuration: const Duration(milliseconds: 150),
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          //
          keyboardType: TextInputType.none,
          readOnly: true,

          textCapitalization: TextCapitalization.characters,
          separatorBuilder: (_) =>
              SizedBox(width: name.length > 8 ? 4.5.r : 7.5.r),
        );
      },
    );
  }
}

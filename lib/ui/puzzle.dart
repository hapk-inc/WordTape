import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mock_data/mock_data.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:pinput/pinput.dart';
import 'package:wordtape/logic/panel_controller.dart';

import '../logic/size.dart';
import 'theme/colors.dart';
import 'theme/font_function.dart';

final DefaultTextTheme textTheme = DefaultTextTheme();

/*
textStyle: GoogleFonts.play(
      //textStyle: GoogleFonts.permanentMarker(
      //textStyle: GoogleFonts.rowdies(
      //textStyle: GoogleFonts.cinzel(
      //textStyle: GoogleFonts.arsenal(
      //textStyle: GoogleFonts.rubikMonoOne(
      //textStyle: GoogleFonts.orbitron(
      fontSize: 18.r,
      fontWeight: FontWeight.w600,
      //fontWeight: FontWeight.normal,
      //fontWeight: FontWeight.normal,
      //fontWeight: FontWeight.w600,
      //fontWeight: FontWeight.w600,
      //fontWeight: FontWeight.normal,
      //fontWeight: FontWeight.w900,
      letterSpacing: 0,
      height: 0,
      color: midnightGreen,
    ),
* */

PinTheme _defaultPinTheme(BoxConstraints box, {Color color = raisinBlack}) {
  final double maxWidth = box.maxWidth;

  final double boxWidth = maxWidth * 0.0975;

  final isConstraintMeasurement = size == 'mobile';

  return PinTheme(
    constraints: BoxConstraints(
      minWidth: isConstraintMeasurement ? boxWidth : 40.5.r,
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

EdgeInsets _commonPuzzlePadding(BoxConstraints constraint) {
  final double maxWidth = constraint.maxWidth;
  return EdgeInsets.only(left: maxWidth * 0.03, right: maxWidth * 0.018);
}

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraint) {
          final double maxHeight = constraint.maxHeight;
          return Stack(
            children: [
              Container(
                color: seaWhite,
                height: maxHeight,
                padding: _commonPuzzlePadding(constraint),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: maxHeight * 0.06,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            if (panelController.isPanelOpen) {
                              panelController.close();
                            }
                          },
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                      Container(
                        padding: _commonPuzzlePadding(constraint),
                        height: maxHeight * 0.135,
                        alignment: Alignment.topLeft,
                        child: const PuzzleHint(),
                      ),
                      Gap(maxHeight * 0.015),
                      AnimatedContainer(
                        height: 400.h,
                        duration: const Duration(milliseconds: 600),
                        child: const PuzzleBoard(),
                      ),
                      Gap(maxHeight * 0.06),
                      const MyKeyboard(),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      );
}

class PuzzleHint extends StatelessWidget {
  const PuzzleHint({super.key});

  @override
  Widget build(BuildContext context) {
    final String randomText = mockString(mockInteger(60, 90), 'A');
    return AutoSizeText(
      randomText,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: slateGray),
      maxLines: 3,
      minFontSize: 15,
      maxFontSize: size != "mobile" ? 18 : 21,
    );
  }
}

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> names =
        List.generate(6, (_) => mockName().toUpperCase());

    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxHeight = constraint.maxHeight;

        return ListView.builder(
          itemCount: names.length,
          padding: _commonPuzzlePadding(constraint),
          itemBuilder: (_, index) => Container(
            height: maxHeight / 6,
            alignment: Alignment.centerLeft,
            child: PuzzleInput(names[index]),
          ),
        );
      },
    );
  }
}

class PuzzleInput extends StatelessWidget {
  final String name;
  const PuzzleInput(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Pinput(
          length: name.length,
          key: ValueKey(name),
          controller: TextEditingController(text: name),
          defaultPinTheme: _defaultPinTheme(
            constraints,
            color: midnightGreen,
          ),

          //
          isCursorAnimationEnabled: true,
          pinAnimationType: PinAnimationType.fade,
          animationDuration: const Duration(milliseconds: 150),
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          //
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.characters,
          separatorBuilder: (_) =>
              SizedBox(width: name.length > 8 ? 4.5.r : 7.5.r),
        );
      },
    );
  }
}

const String backspace = "🔙";
const String done = "✔️";

const List<dynamic> row1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"];
const List<dynamic> row2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"];
const List<dynamic> row3 = [done, "Z", "X", "C", "V", "B", "N", "M", backspace];

class MyKeyboard extends StatelessWidget {
  const MyKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 375.r),
      child: LayoutBuilder(
        builder: (_, constraints) => Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row1.map(
                  (str) {
                    final bool isChar = str.length == 1;
                    final double maxWidth = constraints.maxWidth;
                    final double width = maxWidth * (isChar ? 0.084 : 0.09);
                    return MyKeyboardTile(str, width);
                  },
                ).toList(),
              ),
            ),
            Gap(7.5.r),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row2.map(
                  (str) {
                    final bool isChar = str.length == 1;
                    final double maxWidth = constraints.maxWidth;
                    final double width = maxWidth * (isChar ? 0.084 : 0.09);
                    return MyKeyboardTile(str, width);
                  },
                ).toList(),
              ),
            ),
            Gap(7.5.r),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row3.map(
                  (str) {
                    final bool isChar = str.length == 1;
                    final double maxWidth = constraints.maxWidth;
                    final double width = maxWidth * (isChar ? 0.084 : 0.15);
                    return MyKeyboardTile(str, width);
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyKeyboardTile extends StatelessWidget {
  const MyKeyboardTile(this.str, this.width, {super.key});

  final String str;
  final double width;

  @override
  Widget build(BuildContext context) {
    final bool isChar = str.length == 1;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: 43.2.h,
      margin: EdgeInsets.symmetric(horizontal: width * 0.06),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: seaWhite,
        borderRadius: BorderRadius.circular(4.5.r),
        border: Border.all(width: 0.24.r),
      ),
      child: Text(
        str,
        style: GoogleFonts.play(
          fontSize: isChar ? 15.r : 21.r,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 0,
          color: slateGray,
        ),
      ),
    );
  }
}

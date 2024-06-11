import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../model/word.dart';
import '../../theme/colors.dart';
import '../../theme/text_theme.dart';

final MyTextTheme _textTheme = MyTextTheme();

//const Duration _m300 = Duration(milliseconds: 300);

PinTheme _defaultPinTheme(BoxConstraints box, {Color color = idleColor}) =>
    PinTheme(
      width: box.maxWidth * 0.105,
      height: box.maxHeight * 0.75,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: color, width: 0.9.r),
        ),
      ),
      textStyle: _textTheme.headlineMedium,
    );

class PinputDemo extends StatefulWidget {
  final int index;
  final Word word;
  const PinputDemo(this.index, this.word, {super.key});

  @override
  State<PinputDemo> createState() => _PinputDemoState();
}

class _PinputDemoState extends State<PinputDemo> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController()
      ..text = widget.index == 0
          ? widget.word.value
          : widget.word.value.characters.first;
    if (widget.index == 1) {
      /*for (String str in widget.word.value.substring(1).characters) {
        Future.delayed(const Duration(seconds: 3), () async {
          setState(() => controller.text += str);
        });
      }*/
      Future.wait(
        widget.word.value.substring(1).characters.map(
              (e) => Future.delayed(const Duration(seconds: 3), () async {
                if (mounted) setState(() => controller.text += e);
              }),
            ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: LayoutBuilder(
        builder: (_, constraint) => Padding(
          padding: EdgeInsets.only(left: constraint.maxWidth * 0.03),
          child: Pinput(
            length: widget.word.value.length,
            controller: controller,
            enabled: false,

            //
            defaultPinTheme: _defaultPinTheme(constraint),
            disabledPinTheme: _defaultPinTheme(constraint).copyWith(
              textStyle: _defaultPinTheme(constraint).textStyle?.copyWith(
                    color: widget.index == 0 ? idleColor : teal,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:wordtape/theme/color.dart';

import '../../model/word.dart';
import '../../theme/pin_theme.dart';

class EditableWord extends ConsumerStatefulWidget {
  final int? index;
  final Word word;
  final double? height;
  const EditableWord(this.word, {this.index, this.height, super.key});

  @override
  ConsumerState createState() => _EditableWordState();
}

class _EditableWordState extends ConsumerState<EditableWord> {
  late Color color;
  late bool isEnabled;
  late TextEditingController controller;
  late double height;
  late String word;

  @override
  void initState() {
    height = widget.height ?? 75.r;
    word = widget.word.value;
    color = seaWhite;
    controller = TextEditingController(text: word);
    isEnabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      height: 75.r,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final PinTheme pinTheme = ref
              .read(pinThemeProvider(constraints: constraints, color: color));
          return Pinput(
            length: word.length,
            defaultPinTheme: pinTheme,
            controller: controller,
            //
            isCursorAnimationEnabled: false,
            animationDuration: const Duration(milliseconds: 150),
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            //validator: !isEnabled ? null : (value) {},
            //
            keyboardType: TextInputType.none,
            readOnly: true,
            showCursor: false,

            //
            enabled: isEnabled,
            animationCurve: Curves.easeOut,
            // autofocus: autoFocus,

            textCapitalization: TextCapitalization.characters,
            separatorBuilder: (_) {
              final int len = word.length;
              return SizedBox(width: len > 8 ? 4.5.r : 9.r);
            },
          );
        },
      ),
    );
  }
}

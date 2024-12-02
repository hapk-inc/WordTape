import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/color.dart';
import '../../theme/font.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration duration;
  final void Function() onEnd;

  const TypewriterText(
    this.text, {
    super.key,
    this.duration = const Duration(milliseconds: 75),
    required this.onEnd,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  late Duration _typingDuration;
  late List<String> _displayedText;
  late String _incomingText;

  @override
  void initState() {
    _incomingText = widget.text;
    _typingDuration = widget.duration;
    _displayedText = List.filled(_incomingText.length, " ");
    animateText();
    super.initState();
  }

  animateText() async {
    final int forwardLength = _incomingText.length;
    if (forwardLength > 0) {
      _displayedText = List.filled(_incomingText.length, " ");
      for (var i = 0; i < forwardLength; i++) {
        await Future.delayed(_typingDuration);
        _displayedText[i] = _incomingText.split('')[i];
        if (mounted) setState(() {});
      }
      widget.onEnd();
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant TypewriterText old) {
    if (old.text != widget.text) {
      _incomingText = widget.text;
      animateText();
    }
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) => AutoSizeText(
        _displayedText.join(),
        key: ValueKey(_displayedText),
        maxLines: 3,
        presetFontSizes: [21.r, 18.r],
        style: DefaultTextTheme().robotoMonoFont.copyWith(
              fontWeight: FontWeight.bold,
              color: midnightGreen,
              letterSpacing: 0,
              wordSpacing: 0,
            ),
      );
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final forwardLength = _incomingText.length;
    if (forwardLength > 0) {
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
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    if (oldWidget.text != widget.text) {
      _incomingText = widget.text;
      animateText();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextTheme textTheme = DefaultTextTheme();
    return AutoSizeText(
      _displayedText.join(),
      key: ValueKey(_displayedText),
      maxLines: 2,
      presetFontSizes: [21.r, 18.r, 15.r, 12.r],
      style: textTheme.kanitLarge,
    );
  }
}

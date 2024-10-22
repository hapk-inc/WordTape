import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'package:toastification/toastification.dart';

import '../../function/question/notifier.dart';
import '../../theme/color.dart';

class WordClueState extends ConsumerWidget {
  final DateTime date;
  final ToastificationItem item;
  const WordClueState(this.date, this.item, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    print(notifier.clue);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.r),
      decoration: BoxDecoration(
        color: seaWhite,
        borderRadius: BorderRadius.circular(7.5.r),
      ),
      height: 135.r,
      child: Stack(
        children: [
          Positioned(
            top: 1.5.r,
            right: 1.5.r,
            child: IconButton(
              onPressed: () => toastification.dismiss(item),
              icon: const Icon(Icons.close),
            ),
          ),
          Positioned.fill(
            top: 30.r,
            right: 30.r,
            left: 15.r,
            bottom: 15.r,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: notifier.clue.isEmpty
                  ? Center(
                      child: FadeIn(
                        child: Lottie.asset("lottie/bulb.json"),
                      ),
                    )
                  : Container(
                      alignment: Alignment.topLeft,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 600),
                        child: TypewriterText(
                          text: notifier.clue,
                          key: ValueKey(notifier.clue),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration duration;
  final Duration reverseDuration;

  const TypewriterText({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 90),
    this.reverseDuration = const Duration(milliseconds: 90),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  late Duration _typingDuration;
  late Duration _deletingDuration;
  late String _displayedText;
  late String _incomingText;
  late String _outgoingText;

  @override
  void initState() {
    _incomingText = widget.text;
    _typingDuration = widget.duration;
    _deletingDuration = widget.reverseDuration;

    _outgoingText = _displayedText = '';
    //
    animateText();
    super.initState();
  }

  animateText() async {
    final backwardLength = _outgoingText.length;
    if (backwardLength > 0) {
      for (var i = backwardLength; i >= 0; i--) {
        await Future.delayed(_deletingDuration);
        _displayedText = _outgoingText.substring(0, i);
        if (mounted) setState(() {});
      }
    }
    final forwardLength = _incomingText.length;
    if (forwardLength > 0) {
      for (var i = 0; i <= forwardLength; i++) {
        await Future.delayed(_typingDuration);
        _displayedText = _incomingText.substring(0, i).trim();
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    if (oldWidget.text != widget.text) {
      _outgoingText = oldWidget.text;
      _incomingText = widget.text;
      animateText();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      _displayedText,
      maxLines: 2,
      presetFontSizes: [19.5.r, 18.r, 15.r, 12.r],
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.8),
    );
  }
}

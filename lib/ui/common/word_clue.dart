import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:toastification/toastification.dart';

import '../../function/question/notifier.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';

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
                  ? const SizedBox.expand()
                  : Container(
                      alignment: Alignment.topLeft,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 600),
                        key: ValueKey(notifier.clue),
                        child: TypewriterText(
                          text: notifier.clue,
                          onEnd: () {
                            print("onEnd");
                            Future.delayed(
                              const Duration(milliseconds: 4500),
                              () {},
                            );
                          },
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
  final void Function() onEnd;

  const TypewriterText({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 75),
    required this.onEnd,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  late Duration _typingDuration;
  late String _displayedText;
  late String _incomingText;

  @override
  void initState() {
    _incomingText = widget.text;
    _typingDuration = widget.duration;
    _displayedText = "";
    animateText();
    super.initState();
  }

  animateText() async {
    final forwardLength = _incomingText.length;
    if (forwardLength > 0) {
      for (var i = 0; i <= forwardLength; i++) {
        await Future.delayed(_typingDuration);
        _displayedText = _incomingText.substring(0, i).trim();

        if (mounted) setState(() {});
      }
      widget.onEnd();
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
      _displayedText,
      key: ValueKey(_displayedText),
      maxLines: 2,
      presetFontSizes: [21.r, 18.r, 15.r, 12.r],
      style: textTheme.latoTheme,
    );
  }
}

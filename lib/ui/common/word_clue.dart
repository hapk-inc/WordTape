// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:toastification/toastification.dart';
import 'package:typewritertext/typewritertext.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 15.r),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.r),
            alignment: Alignment.centerLeft,
            // color: cerise,
            child: TypewriterText(text: notifier.clue),
          ),
        ],
      ),
    );
  }

  /*@override
  bool backdropEnabled() => false;

  @override
  SlideDirection direction() => SlideDirection.DOWN;

  @override
  double height() => 135.r;*/
}

class TypewriterText extends StatefulWidget {
  final String text;
  const TypewriterText({super.key, required this.text});

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  final _typingDuration = const Duration(milliseconds: 30);
  final _deletingDuration = const Duration(milliseconds: 10);
  late String _displayedText;
  late String _incomingText;
  late String _outgoingText;

  @override
  void initState() {
    _incomingText = widget.text;
    _outgoingText = '';
    _displayedText = '';
    animateText();
    super.initState();
  }

  void animateText() async {
    final backwardLength = _outgoingText.length;
    if (backwardLength > 0) {
      for (var i = backwardLength; i >= 0; i--) {
        await Future.delayed(_deletingDuration);
        _displayedText = _outgoingText.substring(0, i);
        debugPrint("114=$_displayedText");
        setState(() {});
      }
    }
    final forwardLength = _incomingText.length;
    if (forwardLength > 0) {
      for (var i = 0; i <= forwardLength; i++) {
        await Future.delayed(_typingDuration);
        _displayedText = _incomingText.substring(0, i).trim();
        debugPrint("123=$_displayedText");
        setState(() {});
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
      maxLines: 1,
      style: const TextStyle(color: Colors.red),
    );
  }
}

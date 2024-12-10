import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../function/question/notifier.dart';
import '../../function/underline_text/pod.dart';
import '../../model/prompt.dart';

import '../../extension/extension.dart';

import '../../function/question/word_notifier.dart';
import '../../model/word.dart';

import '../../theme/color.dart';
import '../../theme/pod.dart';

class EditableWord extends ConsumerStatefulWidget {
  final Word word;
  final bool inDailyChallenge;
  const EditableWord(this.word, {this.inDailyChallenge = true, super.key});

  @override
  ConsumerState createState() => _EditableWordState();
}

class _EditableWordState extends ConsumerState<EditableWord> {
  late Word word;
  late WordNotifier wordNotifier;
  late int index;
  late DateTime date;
  late bool isDummy;
  bool enabled = false;

  @override
  void initState() {
    word = widget.word;
    isDummy = word.id == null;
    if (!isDummy) {
      final List<String> splitter = word.id?.split("|") ?? [];
      if (splitter.isNotEmpty) {
        index = int.parse(splitter[1]);
        date = DateFormat('yyyy-MM-dd').parse(splitter[0]);
      } else {
        index = 0;
        date = DateTime.now().onlyYYYYMMMDD;
      }
      wordNotifier = ref.read(wordNotifierProvider(word));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDummy) {
      wordNotifier = ref.watch(wordNotifierProvider(word));
      enabled = wordNotifier.enabled;
    }
    return Hero(
      tag: "$word",
      child: MissingWord(
        word.value,
        controller: isDummy
            ? TextEditingController(text: word.value)
            : wordNotifier.controller,
        color: isDummy ? midnightGreen : wordNotifier.color,
        onChanged: isDummy
            ? null
            : (String s) {
                ref.read(wordNotifierProvider(word)).onTextChanged(s);
                if (!widget.inDailyChallenge) {
                  final String formatDate =
                      DateFormat('dd-MMM-yyyy').format(date);
                  context.go('/daily-challenge/$formatDate');
                }
              },
        validator:
            !enabled ? null : ref.read(wordNotifierProvider(word)).validator,
        onSubmitted: (value) async {
          final QuestionNotifier notifier =
              ref.read(questionNotifierProvider(date));
          final bool? validate = notifier.formKey.currentState?.validate();
          if (validate ?? false) {
            final bool v = await notifier.validate(value);
            if (!v) ref.read(wordNotifierProvider(word)).node.requestFocus();
          } else {
            ref.read(wordNotifierProvider(word)).node.requestFocus();
          }
        },
        enabled: enabled,
        focusNode: isDummy ? null : wordNotifier.node,
        onTap: () {
          if (widget.inDailyChallenge) {
            final QuestionNotifier notifier =
                ref.read(questionNotifierProvider(date));
            if (notifier.focusedWord != word) {
              FocusScope.of(context).unfocus();
              return;
            }
            notifier.prompt = Prompt(text: ref.read(figureOutProvider));
          } else {
            final String formatDate = DateFormat('dd-MMM-yyyy').format(date);
            context.go('/daily-challenge/$formatDate');
          }
        },
      ),
    );
  }
}

class MissingWord extends StatelessWidget {
  final String word;
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final Color color;

  const MissingWord(
    this.word, {
    required this.controller,
    required this.color,
    required this.onChanged,
    required this.onTap,
    required this.onSubmitted,
    required this.validator,
    this.focusNode,
    this.enabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedSize(
        duration: const Duration(milliseconds: 90),
        child: SizedBox(
          height: 70.h,
          child: Consumer(
            builder: (_, ref, __) => LayoutBuilder(
              builder: (_, constraints) {
                final PinTheme pinTheme = ref.read(
                  pinThemeProvider(constraints: constraints, color: color),
                );

                return Pinput(
                  length: word.length,
                  autofocus: true,
                  defaultPinTheme: pinTheme,
                  showCursor: enabled,
                  onTap: onTap,
                  focusNode: focusNode,
                  keyboardType: TextInputType.none,
                  textInputAction: TextInputAction.next,
                  controller: controller,
                  animationCurve: Curves.easeOut,
                  textCapitalization: TextCapitalization.characters,
                  separatorBuilder: (_) {
                    final int len = word.length;
                    return SizedBox(width: len > 8 ? 4.5.r : 9.r);
                  },
                  errorBuilder: (e, _) => const SizedBox(),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  validator: validator,
                  pinAnimationType: PinAnimationType.fade,
                  animationDuration: const Duration(milliseconds: 150),
                  pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                  closeKeyboardWhenCompleted: false,
                );
              },
            ),
          ),
        ),
      );
}

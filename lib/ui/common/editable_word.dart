import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../enum/enum.dart';
import '../../function/question/notifier.dart';
import '../../function/underline_text/pod.dart';
import '../../model/prompt.dart';
import '../../model/route_path.dart';
import '../../router/path.dart';

import '../../extension/extension.dart';

import '../../function/question/word_notifier.dart';
import '../../model/word.dart';

import '../../theme/color.dart';
import '../../theme/pod.dart';

/*
class EditableWord extends ConsumerStatefulWidget {
  final Word word;
  final bool initialised;

  const EditableWord(this.word, {this.initialised = true, super.key});

  @override
  ConsumerState createState() => _EditableWordState();
}

class _EditableWordState extends ConsumerState<EditableWord> {
  late Word word;
  late WordNotifier wordNotifier;
  late int index;
  late DateTime date;
  late QuestionNotifier notifier;

  @override
  void initState() {
    word = widget.word;
    if (widget.initialised) {
      final List<String> splitter = word.id?.split("|") ?? [];
      if (splitter.isNotEmpty) {
        index = int.parse(splitter[1]);
        date = DateFormat('yyyy-MM-dd').parse(splitter[0]);
      } else {
        index = 0;
        date = DateTime.now().convert();
      }
      wordNotifier = ref.read(wordNotifierProvider(word));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.initialised) {
      return SizedBox(
        height: 72.h,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final PinTheme pinTheme = ref.read(
              pinThemeProvider(constraints: constraints, color: raisinBlack),
            );

            return Pinput(
              length: word.value.length,
              defaultPinTheme: pinTheme,
              controller: TextEditingController(text: word.value),
              //

              keyboardType: TextInputType.none, // readOnly: true,

              //
              enabled: false,
              animationCurve: Curves.easeOut,

              readOnly: true,

              textCapitalization: TextCapitalization.characters,
              separatorBuilder: (_) {
                final int len = word.value.length;
                return SizedBox(width: len > 8 ? 4.5.r : 9.r);
              },

              errorBuilder: (e, _) => const SizedBox(),
              textInputAction: TextInputAction.none,
            );
          },
        ),
      );
    }
    final RoutePath path = ref.read(pathNotifierProvider);

    wordNotifier = ref.watch(wordNotifierProvider(word));

    final bool isDecode = path.path == "/decode";

    notifier = ref.watch(questionNotifierProvider(date));
    final bool enabled = notifier.focusedWord == word && isDecode;

    return Hero(
      tag: word.id ?? "",
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        height: 72.h,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final PinTheme pinTheme = ref.read(
              pinThemeProvider(
                  constraints: constraints, color: wordNotifier.color),
            );

            return Pinput(
              length: word.value.length,
              defaultPinTheme: pinTheme,
              controller: wordNotifier.controller,
              focusNode: wordNotifier.node,
              //

              pinAnimationType: PinAnimationType.fade,
              animationDuration: const Duration(milliseconds: 150),
              pinputAutovalidateMode: PinputAutovalidateMode.disabled,
              validator: !enabled ? null : wordNotifier.validator,
              onSubmitted: (value) {
                final bool? validate =
                    notifier.formKey.currentState?.validate();
                if (validate ?? false) notifier.validate(value);
              },
              onCompleted: (value) {},

              onTap: () {
                if (notifier.focusedWord != word) return;
                notifier.prompt = Prompt(
                  text: ref.read(figureOutProvider),
                  state: PromptState.search,
                );

                if (!isDecode && notifier.focusedWord == word) {
                  context.push('/decode', extra: date);
                }
              },

              keyboardType: TextInputType.name, // readOnly: true,
              forceErrorState: wordNotifier.error,

              //
              enabled: notifier.focusedWord == word,
              animationCurve: Curves.easeOut,
              autofocus: enabled,

              readOnly: !enabled,

              onChanged: ref.read(wordNotifierProvider(word)).onTextChanged,

              textCapitalization: TextCapitalization.characters,
              separatorBuilder: (_) {
                final int len = word.value.length;
                return SizedBox(width: len > 8 ? 4.5.r : 9.r);
              },

              errorBuilder: (e, _) => const SizedBox(),
              textInputAction: TextInputAction.none,
            );
          },
        ),
      ),
    );
  }
}
*/

class EditableWord extends ConsumerStatefulWidget {
  final Word word;
  final bool initialised;

  const EditableWord(this.word, {this.initialised = true, super.key});

  @override
  ConsumerState createState() => _EditableWordState();
}

class _EditableWordState extends ConsumerState<EditableWord> {
  late Word word;
  late WordNotifier wordNotifier;
  late int index;
  late DateTime date;
  //late QuestionNotifier notifier;
  late bool initialised;

  @override
  void initState() {
    word = widget.word;
    initialised = widget.initialised;
    if (initialised) {
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
    bool enabled = false;

    if (initialised) {
      wordNotifier = ref.watch(wordNotifierProvider(word));
      enabled = wordNotifier.enabled;
    }
    return MissingWord(
      widget.word.value,
      controller: !initialised
          ? TextEditingController(text: word.value)
          : wordNotifier.controller,
      color: initialised ? wordNotifier.color : raisinBlack,
      onChanged: !initialised
          ? null
          : ref.read(wordNotifierProvider(word)).onTextChanged,
      validator:
          !enabled ? null : ref.read(wordNotifierProvider(word)).validator,
      onTap: () {
        final QuestionNotifier notifier =
            ref.read(questionNotifierProvider(date));
        //final RoutePath path = ref.read(pathNotifierProvider);
        //print("235-Route Path");
        //print(path.path);
        //final bool inDailyChallenge = path.path.contains("/daily-challenge/");
        if (notifier.focusedWord != word) return;
        notifier.prompt = Prompt(
          text: ref.read(figureOutProvider),
          state: PromptState.search,
        );

        if (!initialised && notifier.focusedWord == word) {
          context.push('/daily-challenge', extra: date);
        }
      },
      onSubmitted: (value) {
        final QuestionNotifier notifier =
            ref.read(questionNotifierProvider(date));
        final bool? validate = notifier.formKey.currentState?.validate();
        if (validate ?? false) notifier.validate(value);
      },
      enabled: initialised ? enabled : false,
      focusNode: initialised ? wordNotifier.node : null,
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
          height: 72.h,
          child: Consumer(
            builder: (_, ref, __) => LayoutBuilder(
              builder: (_, constraints) {
                final PinTheme pinTheme = ref.read(
                  pinThemeProvider(constraints: constraints, color: color),
                );

                return Pinput(
                  length: word.length,
                  autofocus: enabled,
                  enabled: enabled,
                  defaultPinTheme: pinTheme,
                  onTap: onTap,
                  focusNode: focusNode,

                  controller: controller,
                  //keyboardType: TextInputType.none,
                  animationCurve: Curves.easeOut,
                  readOnly: !enabled,
                  textCapitalization: TextCapitalization.characters,
                  separatorBuilder: (_) {
                    final int len = word.length;
                    return SizedBox(width: len > 8 ? 4.5.r : 9.r);
                  },
                  errorBuilder: (e, _) => const SizedBox(),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  validator: validator,
                  //onChanged: ref.read(wordNotifierProvider(word)).onTextChanged,
                  //textInputAction: TextInputAction.none,

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

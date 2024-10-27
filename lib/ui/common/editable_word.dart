import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:wordtape/enum/enum.dart';
import 'package:wordtape/function/question/notifier.dart';
import 'package:wordtape/function/underline_text/pod.dart';
import 'package:wordtape/model/prompt.dart';
import 'package:wordtape/model/underline_text.dart';
import '../../model/route_path.dart';
import '../../router/path.dart';

import '../../extension/extension.dart';

import '../../function/question/word_notifier.dart';
import '../../model/word.dart';

import '../../theme/pod.dart';

class EditableWord extends ConsumerStatefulWidget {
  final Word word;

  const EditableWord(this.word, {super.key});

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
    final List<String> splitter = word.id?.split("|") ?? [];
    if (splitter.isNotEmpty) {
      index = int.parse(splitter[1]);
      date = DateFormat('yyyy-MM-dd').parse(splitter[0]);
    } else {
      index = 0;
      date = DateTime.now().convert();
    }
    wordNotifier = ref.read(wordNotifierProvider(word));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RoutePath path = ref.read(pathNotifierProvider);

    wordNotifier = ref.watch(wordNotifierProvider(word));

    final bool isDecode = path.path == "/decode";

    notifier = ref.watch(questionNotifierProvider(date));
    final bool enabled = notifier.focusedWord == word && isDecode;

    return Hero(
      tag: word.id ?? "",
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        height: 70.5.h,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final PinTheme pinTheme = ref.read(
              pinThemeProvider(
                  constraints: constraints, color: wordNotifier.color),
            );

            return Pinput(
              length: word.value.length,
              defaultPinTheme: pinTheme,
              controller: wordNotifier.controller, focusNode: wordNotifier.node,
              //

              pinAnimationType: PinAnimationType.fade,
              animationDuration: const Duration(milliseconds: 150),
              pinputAutovalidateMode: PinputAutovalidateMode.disabled,
              validator: !enabled ? null : wordNotifier.validator,
              onTap: notifier.focusedWord != word
                  ? null
                  : () {
                      notifier.prompt = Prompt(
                        text: UnderlineText(ref.read(figureOutProvider)),
                        state: PromptState.search,
                      );

                      if (!isDecode && notifier.focusedWord == word) {
                        context.push('/decode', extra: date);
                      }
                    },

              // showCursor: false,
              // isCursorAnimationEnabled: false,
              //
              keyboardType: TextInputType.none, // readOnly: true,
              forceErrorState: wordNotifier.error,

              onSubmitted: (value) {
                debugPrint("120==");
              },

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

              useNativeKeyboard: kDebugMode,
              textInputAction: TextInputAction.none,
            );
          },
        ),
      ),
    );
  }
}

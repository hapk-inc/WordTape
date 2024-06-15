import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../logic/puzzle/found_notifier.dart';
import '../../theme/colors.dart';

class RevealButton extends ConsumerWidget {
  const RevealButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return TextButton(
      onPressed: () {
        Get.closeCurrentSnackbar();
        ref.read(foundNotifierProvider).revealWord();
      },
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(textTheme.headlineMedium),
        foregroundColor: const WidgetStatePropertyAll(xantHous),
      ),
      child: const Text("REVEAL NOW"),
    );
  }
}

/*
class RevealButton extends ConsumerWidget {
  final String word;
  const RevealButton(this.word, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Answer: $word")),
        ),
      child: const Text(
        "REVEAL NOW",
        style: TextStyle(color: elbow, fontWeight: FontWeight.normal),
      ),
    );
  }
}
*/

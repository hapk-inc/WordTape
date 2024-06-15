import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../logic/puzzle/found_notifier.dart';
import '../../theme/colors.dart';

class HintButton extends ConsumerWidget {
  const HintButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return TextButton(
      onPressed: () {
        Get.closeCurrentSnackbar();

        ref.read(foundNotifierProvider).updateHintFlag();
      },
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(textTheme.headlineMedium),
        foregroundColor: const WidgetStatePropertyAll(xantHous),
      ),
      child: const Text("NEED HINT"),
    );
  }
}

/*
class HintButton extends ConsumerWidget {
  final String hint;
  const HintButton(this.hint, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Hint: $hint")),
        ),
      child: const Text(
        "NEED HINT",
        style: TextStyle(color: elbow, fontWeight: FontWeight.normal),
      ),
    );
  }
}
*/

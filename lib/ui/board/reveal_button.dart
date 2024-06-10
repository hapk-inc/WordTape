import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/colors.dart';

class RevealButton extends ConsumerWidget {
  final String word;
  const RevealButton(this.word, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Answer is $word")),
        ),
      child: const Text(
        "REVEAL NOW",
        style: TextStyle(color: elbow, fontWeight: FontWeight.normal),
      ),
    );
  }
}

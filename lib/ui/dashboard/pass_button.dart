import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/welcome.dart';

class PassButton extends ConsumerWidget {
  const PassButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String str = ref.read(passTextProvider);
    return OutlinedButton(onPressed: () {}, child: Text(str));
  }
}

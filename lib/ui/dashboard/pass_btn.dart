import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/welcome.dart';

class PassBtn extends ConsumerWidget {
  const PassBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String str = ref.read(passTextProvider);
    return OutlinedButton(onPressed: () {}, child: Text(str));
  }
}

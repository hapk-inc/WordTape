import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../enum/pod.dart';
import '../../function/controller/pod.dart';
import '../../model/welcome.dart';
import 'share_dialog.dart';

class PassBtn extends ConsumerWidget {
  const PassBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String str = ref.read(passTextProvider);
    return OutlinedButton(
      onPressed: () {
        ref.read(widgetPanelProvider.notifier).state = const ShareDialog();
      },
      child: Text(str),
    );
  }
}

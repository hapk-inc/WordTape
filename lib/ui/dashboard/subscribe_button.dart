import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/app/bloc.dart';
import '../../theme/colors.dart';
import '../common/subscribe_dialog.dart';

class SubscribeButton extends ConsumerWidget {
  const SubscribeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(xantHous),
        ),
        onPressed: () {
          ref.read(panelNotifierProvider.notifier).state =
              const SubscribeDialog();
          ref.read(panelControllerProvider).open();
        },
        child: const Text(
          "SUBSCRIBE",
          style: TextStyle(color: engineeringOrange),
        ),
      );
}

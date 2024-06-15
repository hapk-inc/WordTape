import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/colors.dart';

class SubscribeButton extends ConsumerWidget {
  const SubscribeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(xantHous),
        ),
        onPressed: () {
          //ref.read(panelNotifierProvider.notifier).state = const ShareDialog();
          //ref.read(panelControllerProvider).open();
          /*Get.showSnackbar(
            const GetSnackBar(
              title: "Title",
              message: "Message",
              duration: Duration(seconds: 3),
            ),
          );*/
          //Get.snackbar("Hi", "Message");
        },
        child: const Text(
          "SUBSCRIBE WORDTAPE",
          style: TextStyle(color: engineeringOrange),
        ),
      );
}

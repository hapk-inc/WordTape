import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/puzzle/bloc.dart';
import '../../model/found.dart';
import '../../theme/colors.dart';

const String _congratulation = "Congratulations on completing today's game! ";

class SubscribeDialog extends ConsumerWidget {
  const SubscribeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("16--");
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Found? found = ref.read(selectedFoundProvider).valueOrNull;
    //debugPrint(found.toString());
    return DefaultTabController(
      length: 2,
      child: Container(
        color: ashGray,
        child: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText.rich(
                    TextSpan(
                      children: [
                        if (found?.isCompleted ?? false)
                          const TextSpan(text: _congratulation),
                        const TextSpan(text: "Create your profile now to:"),
                      ],
                    ),
                    style: textTheme.titleMedium?.copyWith(
                      color: payneGray,
                      height: 1.8,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}

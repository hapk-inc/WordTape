import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PanelWidget extends ConsumerWidget {
  const PanelWidget({super.key});

  double height();
}

class EmptyPanel extends PanelWidget {
  const EmptyPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const SizedBox();

  @override
  double height() => 0;
}

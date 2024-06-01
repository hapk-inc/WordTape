import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/puzzle/bloc.dart';
import '../../model/found.dart';
import '../../theme/colors.dart';

class SelectedFound extends ConsumerWidget {
  const SelectedFound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Found? found = ref.watch(selectedFoundProvider).value;
    final String excellent = ref.read(excellentProvider);
    return Container(
      height: 180.r,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: found == null
            ? null
            : AutoSizeText(
                found.isCompleted ? excellent : "",
                style: textTheme.titleMedium?.copyWith(
                    fontFamily: 'Nunito',
                    color: payneGray,
                    fontWeight: FontWeight.w300,
                    height: 1.8),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
      ),
    );
  }
}

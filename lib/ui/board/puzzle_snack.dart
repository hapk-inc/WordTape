import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

class PuzzleSnack extends StatelessWidget {
  const PuzzleSnack({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 30.h,
      alignment: Alignment.centerLeft,
      child: Text(
        "Incorrect answer",
        style: textTheme.bodyLarge?.copyWith(color: seaSalt, fontSize: 15),
      ),
    );
  }
}

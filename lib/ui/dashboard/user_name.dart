import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';

import '../../log/pod.dart';
import '../../logic/auth/pod.dart';

class UserName extends ConsumerWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? fUser = ref.watch(fUserProvider).value;
    final Logger logger = ref.read(logProvider);
    logger.i(fUser);

    //
    final TextTheme textTheme = Theme.of(context).textTheme;

    //
    return LayoutBuilder(
      builder: (_, constraints) {
        final double maxW = constraints.maxWidth;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 36.r),
            Gap(maxW * 0.045),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW * 0.45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fUser?.displayName ?? "",
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    maxLines: 1,
                  ),
                  Gap(10.r),
                  Text("Hello", style: textTheme.headlineMedium)
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => ref.read(logOffProvider),
              child: Text(
                "EDIT",
                style: textTheme.headlineSmall?.copyWith(color: Colors.grey),
              ),
            )
          ],
        );
      },
    );
  }
}

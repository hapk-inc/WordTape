import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../function/underline_text/pod.dart';

class StoreBtn extends ConsumerWidget {
  const StoreBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FadeIn(
      delay: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 300),
      child: Wrap(
        spacing: 15.r,
        runSpacing: 15.r,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Lottie.asset('lottie/app_store.json'),
          Image.asset('images/play-store.png')
        ]
            .map(
              (e) => InkWell(
                onTap: () {
                  final String progress = ref.read(inProgressProvider);
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(
                      content: Text(progress),
                      padding: EdgeInsets.all(15.r),
                    ),
                  );
                },
                child: SizedBox(width: 150.r, child: e),
              ),
            )
            .toList(),
      ),
    );
  }
}

/* SizedBox(
          width: 180.r,
          child: Lottie.asset('lottie/app_store.json', fit: BoxFit.fitWidth),
        ),
        SizedBox(
          width: 180.r,
          child: Image.asset('images/play-store.png', fit: BoxFit.fitWidth),
        ),*/

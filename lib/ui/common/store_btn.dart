import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class StoreBtn extends StatelessWidget {
  const StoreBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.r,
      runSpacing: 15.r,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        Lottie.asset('lottie/app_store.json'),
        Image.asset('images/play-store.png')
      ]
          .map(
            (e) => AnimatedSize(
              duration: const Duration(milliseconds: 450),
              child: InkWell(child: SizedBox(width: 180.r, child: e)),
            ),
          )
          .toList(),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class StoreBtn extends StatelessWidget {
  const StoreBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30.r,
      runSpacing: 15.r,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        SizedBox(
          width: 210.r,
          child: Lottie.asset('lottie/app_store.json', fit: BoxFit.fitWidth),
        ),
        SizedBox(
          width: 210.r,
          child: Image.asset('images/play-store.png', fit: BoxFit.fitWidth),
        ),
      ],
    );
  }
}

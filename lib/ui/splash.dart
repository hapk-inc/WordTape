import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'theme/colors.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _lottie = false;
  bool _logo = false;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1800),
      () {
        setState(() => _lottie = true);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: midnightGreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 540.r,
              child: Stack(
                children: [
                  if (_logo)
                    Center(
                      child: FadeIn(
                        duration: const Duration(milliseconds: 300),
                        delay: const Duration(milliseconds: 750),
                        onFinish: (direction) {
                          log("OnFinish");
                        },
                        child: Text(
                          "WORD\nTAPE",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                  if (_lottie)
                    Positioned(
                      left: -90.r,
                      right: -90.r,
                      top: -90.r,
                      bottom: -90.r,
                      child: Lottie.asset(
                        'lottie/stamp.json',
                        fit: BoxFit.fill,
                        repeat: false,
                        onLoaded: (p0) {
                          log("onLoaded");
                          setState(() => _logo = true);
                        },
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );
}

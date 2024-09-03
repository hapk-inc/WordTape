import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../enum/pod.dart';
import '../function/auth/pod.dart';
import 'theme/colors.dart';

const Duration _m1500 = Duration(milliseconds: 1500);

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
    Future.delayed(_m1500, () => setState(() => _lottie = true));
    super.initState();
  }

  void onLoaded(LottieComposition p0) {
    log("onLoaded");
    setState(() => _logo = true);
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
                  if (_logo) const Logo(),
                  if (_lottie) StampLottie(onLoaded: onLoaded)
                ],
              ),
            ),
          ],
        ),
      );
}

class StampLottie extends StatelessWidget {
  final void Function(LottieComposition)? onLoaded;
  const StampLottie({required this.onLoaded, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -90.r,
      right: -90.r,
      top: -90.r,
      bottom: -90.r,
      child: Lottie.asset('lottie/stamp.json',
          fit: BoxFit.fill, repeat: false, onLoaded: onLoaded),
    );
  }
}

class Logo extends ConsumerWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScreenSize size = ref.watch(sizeProvider);
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 300),
        delay: const Duration(milliseconds: 750),
        onFinish: (direction) {
          log("OnFinish");
          Future.delayed(_m1500, () => ref.read(listenAuthProvider));
        },
        child: Text(
          size == ScreenSize.mobile ? "WORD\nTAPE" : "WORDTAPE",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}

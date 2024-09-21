import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../enum/pod.dart';
import '../function/auth/pod.dart';
import 'theme/color.dart';

const Duration _m1500 = Duration(milliseconds: 1500);

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _lottie = false;
  bool _logo = false;
  bool _loader = false;

  @override
  void initState() {
    Future.delayed(_m1500, () => setState(() => _lottie = true));
    super.initState();
  }

  onLoaded(LottieComposition p0) async {
    log("onLoaded");
    setState(() => _logo = true);
  }

  onFinish(AnimateDoDirection direction) async {
    log("onFinish");
    Future.delayed(_m1500, () {
      if (mounted) setState(() => _loader = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      color: midnightGreen,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 540.r,
            child: Stack(
              children: [
                if (_logo) Logo(onFinish: onFinish),
                if (_lottie) StampLottie(onLoaded: onLoaded)
              ],
            ),
          ),
          SizedBox(
            height: 45.h,
            child: _loader ? const Loader() : null,
          )
        ],
      ),
    );
  }
}

class Loader extends ConsumerWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return FadeIn(
      child: TextButton(
        onPressed: () => ref.read(userLoginProvider),
        child: Text("PRESS TO START", style: textTheme.labelSmall),
      ),
    );
  }
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
      child: Lottie.asset(
        'lottie/stamp.json',
        fit: BoxFit.fill,
        repeat: false,
        onLoaded: onLoaded,
      ),
    );
  }
}

class Logo extends ConsumerWidget {
  final void Function(AnimateDoDirection)? onFinish;
  const Logo({this.onFinish, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScreenSize size = ref.watch(sizeProvider);
    return Center(
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(maxWidth: 450.r),
        child: FadeIn(
          duration: const Duration(milliseconds: 300),
          delay: const Duration(milliseconds: 750),
          onFinish: onFinish,
          child: Text(
            size != ScreenSize.pc ? "WORD\nTAPE" : "WORDTAPE",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}

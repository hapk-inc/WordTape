import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';

import 'package:lottie/lottie.dart';
import '../firebase/pod.dart';
import '../function/auth/pod.dart';
import '../function/auth/running_user.dart';
import '../function/underline_text/pod.dart';
import '../router/router.dart';
import 'common/gradient_box.dart';
import 'common/logo.dart';

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
    ref.read(listenAuthProvider);
    Future.delayed(
      _m1500,
      () {
        if (mounted) setState(() => _loader = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) => GradientBox(
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
            SizedBox(height: 45.h, child: _loader ? const Loader() : null)
          ],
        ),
      );
}

class Loader extends ConsumerWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return FadeIn(
      child: TextButton(
        onPressed: () async {
          final String str = await FlutterTimezone.getLocalTimezone();
          ref.read(firebaseAnalyticsProvider).logAppOpen(
            parameters: {"timezone": str},
          );
          final User? user = ref.read(runningUserProvider).value;
          if (user == null) ref.read(userLoginProvider);
          final GoRouter router = ref.read(routerProvider);

          router.go("/dashboard");
        },
        child: Text(ref.read(pressStartProvider), style: textTheme.labelSmall),
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
      child: Lottie.asset('lottie/stamp.json',
          fit: BoxFit.fill, repeat: false, onLoaded: onLoaded),
    );
  }
}

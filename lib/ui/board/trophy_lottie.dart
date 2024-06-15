import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class TrophyLottie extends StatefulWidget {
  final bool isTrophy;
  const TrophyLottie(this.isTrophy, {super.key});

  @override
  State<TrophyLottie> createState() => _TrophyLottieState();
}

class _TrophyLottieState extends State<TrophyLottie> {
  bool repeat = true;
  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints.tight(Size.square(75.r)),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Lottie.asset(
            widget.isTrophy ? 'lottie/trophy.json' : 'lottie/sad_face.json',
            errorBuilder: (_, __, ___) => const Text("🏆"),
            repeat: repeat,
            onLoaded: (composition) {
              Future.delayed(
                composition.duration * 6,
                () => mounted ? setState(() => repeat = false) : null,
              );
            },
          ),
        ),
      );
}

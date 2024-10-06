import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mock_data/mock_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../panel/widget.dart';
import '../theme/color.dart';

class SummaryPage extends PanelWidget {
  const SummaryPage({super.key});

  @override
  Widget build(context, ref) => SizedBox(
        height: height(),
        child: const Summary(),
      );

  @override
  SlideDirection direction() => SlideDirection.DOWN;

  @override
  double height() => 405.r;
}

class Summary extends ConsumerStatefulWidget {
  const Summary({super.key});

  @override
  ConsumerState createState() => _SummaryState();
}

class _SummaryState extends ConsumerState<Summary> {
  bool show = false;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(maxWidth: 300.r, maxHeight: 405.r),
        color: seaWhite,
        child: Stack(
          children: [
            Lottie.asset(
              'lottie/confetti.json',
              repeat: false,
              onLoaded: (p0) => Future.delayed(
                p0.duration * 0.75,
                () => setState(() => show = true),
              ),
            ),
            if (show)
              FadeIn(
                duration: const Duration(milliseconds: 750),
                child: const Center(child: SummaryContent()),
              ),
          ],
        ),
      );
}

class SummaryContent extends ConsumerWidget {
  const SummaryContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final UnderlineText hashTag = ref.read(hashTagProvider);
    return Column(
      children: [
        SizedBox.square(
          dimension: 270.r,
          child: Lottie.asset('lottie/trophy_1.json', fit: BoxFit.fitHeight),
        ),
        const Spacer(),
        Container(
          color: azureGreen,
          height: 90.r,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 15.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mockString(30),
                style: GoogleFonts.montserrat(
                  color: gunMetal,
                  fontWeight: FontWeight.w300,
                  fontSize: 15.r,
                  height: 0,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
              ),
              Gap(12.r),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "http://${mockString(60)}",
                      style: GoogleFonts.robotoMono(
                        fontSize: 15.r,
                        letterSpacing: 0,
                        height: 0,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gap(7.5.r),
                  const Icon(Icons.copy)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

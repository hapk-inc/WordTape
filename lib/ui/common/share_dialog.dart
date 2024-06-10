import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../theme/colors.dart';
import '../dashboard/button_bar.dart';

const String _text1 = "Share & Challenge your friends!";

const String _text2 = "Post a Story.";

const String _text5 = "Invite your friends to join the puzzle fun "
    "and see if they can beat your time!";

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            _text1,
            style: textTheme.titleSmall?.copyWith(color: teal, height: 2.1),
            maxLines: 1,
          ),
          Gap(12.r),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _text2,
                  children: [
                    const TextSpan(text: " "),
                    const TextSpan(text: "Share your achievement on"),
                    const TextSpan(text: "  "),
                    WidgetSpan(
                      child: SizedBox.square(
                        dimension: 24.r,
                        child: Image.asset('images/wa-logo.png'),
                      ),
                    ),
                    const TextSpan(text: "  "),
                    const TextSpan(text: "or"),
                    const TextSpan(text: "  "),
                    WidgetSpan(
                      child: SizedBox.square(
                        dimension: 24.r,
                        child: Image.asset('images/insta-logo.png'),
                      ),
                    ),
                  ],
                  style: textTheme.bodyMedium?.copyWith(
                    color: slateGray,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
          Gap(15.r),
          RichText(
            text: TextSpan(
              text: _text5,
              style: textTheme.bodyMedium?.copyWith(
                color: slateGray,
                height: 1.8,
              ),
            ),
          ),
          const ButtonBar(children: [ShareButton(tealColor: true)])
        ],
      ),
    );
  }
}

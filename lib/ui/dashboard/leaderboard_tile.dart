import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mock_data/mock_data.dart';

import '../theme/color.dart';

BorderRadius _borderRadius(double radius) => BorderRadius.circular(radius);

class LeaderBoardTile extends StatelessWidget {
  const LeaderBoardTile({super.key});

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(borderRadius: _borderRadius(7.5.r)),
        color: azureGreen,
        elevation: 4.5.r,
        margin: EdgeInsets.symmetric(horizontal: 15.r),
        child: ClipRRect(
          borderRadius: _borderRadius(7.5.r),
          child: SizedBox(
            height: 480.h,
            width: 510.r,
            child: Column(
              children: [
                Gap(15.r),
                Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 12.r),
                    children: List.generate(
                      6,
                      (index) => PlayerTile(border: index != 5),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}

class PlayerTile extends StatelessWidget {
  final bool border;
  const PlayerTile({this.border = false, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 75.h,
      alignment: Alignment.center,
      width: double.maxFinite,
      child: LayoutBuilder(builder: (_, constraint) {
        final double mW = constraint.maxWidth;
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(radius: 27.r, backgroundColor: aquaMarine),
                  Gap(18.r),
                  Expanded(
                    child: Text(
                      mockString(mockInteger(6, 18)),
                      style: textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    "${mockInteger(1, 5000)}",
                    style: textTheme.headlineLarge?.copyWith(
                      fontSize: 21.r,
                      height: 0,
                    ),
                  ),
                  Gap(15.r),
                ],
              ),
            ),
            if (border)
              Align(
                alignment: Alignment.bottomCenter,
                child: Divider(thickness: 0.3.r, color: slateGray),
              )
          ],
        );
      }),
    );
  }
}

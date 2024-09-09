import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mock_data/mock_data.dart';
import 'package:random_avatar/random_avatar.dart';

import '../theme/color.dart';

BorderRadius _borderRadius(double radius) => BorderRadius.circular(radius);

class LeaderBoardTile extends StatelessWidget {
  const LeaderBoardTile({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: _borderRadius(7.5.r)),
      color: azureGreen,
      elevation: 4.5.r,
      margin: EdgeInsets.symmetric(horizontal: 15.r),
      child: ClipRRect(
        borderRadius: _borderRadius(7.5.r),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            height: 480.h,
            width: 480.r,
            child: LayoutBuilder(
              builder: (_, constraint) {
                final double mW = constraint.maxWidth;
                final double mH = constraint.maxHeight;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 180.h,
                      child: Stack(
                        children: [
                          Positioned(
                            top: -mH * 0.0075,
                            right: -mW * 0.015,
                            child: SizedBox.square(
                              dimension: 120.r,
                              child: Image.asset('images/worldwide.gif'),
                            ),
                          ),
                          Positioned(
                              left: 15.r,
                              top: mH * 0.045,
                              child: SizedBox.square(
                                  dimension: 75.r,
                                  child: RandomAvatar(mockString()))),
                          Positioned(
                            bottom: mH * 0.03,
                            left: 15.r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rank #${mockInteger(1, 500)}",
                                  style: textTheme.headlineLarge?.copyWith(
                                    color: slateGray,
                                  ),
                                ),
                                Text(
                                  "${mockInteger(1, 500)} points",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: slateGray,
                                    fontSize: 14.r,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: mH * 0.045,
                            right: mW * 0.06,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Top ${mockInteger(1, 100)}%",
                                  style: textTheme.headlineLarge?.copyWith(
                                    color: blackBean,
                                    letterSpacing: 0,
                                    fontSize: 27.r,
                                  ),
                                ),
                                Text(
                                  "Out of ${mockInteger(1, 5000)} users played",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: slateGray,
                                    fontSize: 14.r,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Gap(15.r),
                    Expanded(
                        child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 15.r),
                      children: List.generate(
                        4,
                        (index) => Container(
                          height: 70.h,
                          alignment: Alignment.centerLeft,
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(radius: 24.r),
                                    Gap(18.r),
                                    Text(
                                      mockString(mockInteger(6, 18)),
                                      style: textTheme.bodySmall
                                          ?.copyWith(fontSize: 16.r),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${mockInteger(1, 5000)}",
                                      style: textTheme.headlineLarge
                                          ?.copyWith(fontSize: 21.r, height: 0),
                                    ),
                                    Gap(15.r),
                                  ],
                                ),
                              ),
                              if (index != 3)
                                Divider(
                                    thickness: 0.45.r,
                                    color: slateGray,
                                    height: 0)
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

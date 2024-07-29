import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'theme/colors.dart';
import 'theme/font_function.dart';

class HomePage extends ConsumerStatefulWidget {
  final String size;
  const HomePage(this.size, {super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PanelController panelController;

  @override
  void initState() {
    panelController = PanelController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: teal,
      body: SlidingUpPanel(
        maxHeight: 600.h,
        minHeight: 180.h,
        controller: panelController,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
        padding: EdgeInsets.symmetric(horizontal: 15.r),
        color: greenWhite,
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(15.r),
            Text(
              "Daily Challenge",
              style: righteous24.copyWith(color: raisinBlack),
            ),
            Gap(15.r),
            const MyCalendar(),
            Gap(15.r),
            ...List.generate(5, (_) => const DailyChallengeTile())
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Gap(15.r),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeIn(
                      delay: const Duration(milliseconds: 600),
                      child: Text(
                        mockString(16),
                        style: righteous24.copyWith(color: seaSalt),
                      ),
                    ),
                    Gap(7.5.r),
                    FadeIn(
                      delay: const Duration(milliseconds: 900),
                      child: Text(
                        mockString(90),
                        style: cabin13_5.copyWith(color: greenWhite),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(15.r),
              Gap(15.r),
              /*Card(
                margin: EdgeInsets.symmetric(horizontal: 15.r),
                color: greenWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: aquaMarine,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              )*/
              /*Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.r),
                child: CardActions(
                  width: double.maxFinite,
                  height: 360.h,
                  backgroundColor: greenWhite,
                  borderRadius: 15.r,
                  actions: const <CardActionButton>[
                    */ /*CardActionButton(
                    icon: const Icon(Icons.edit, color: Colors.white), // Icon
                    label: 'Edit',
                    onPress: () {},
                  ), */ /*
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      color: aquaMarine,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                    ),
                    height: 150.h,
                  ),
                ),
              ),*/
              Card(
                elevation: 7.5.r,
                margin: EdgeInsets.symmetric(horizontal: 15.r),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                color: aquaMarine,
                child: Container(height: 270.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyChallengeTile extends StatelessWidget {
  const DailyChallengeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63.75.h,
      padding: EdgeInsets.symmetric(horizontal: 24.r),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: teal, width: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${mockName()} ${mockName()}",
            style: questrial18.copyWith(color: raisinBlack),
          ),
        ],
      ),
    );
  }
}

class MyCalendar extends StatelessWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime randomDate =
        mockDate(now.subtract(Duration(days: mockInteger(0, 1))), now);
    return SizedBox(
      height: 75.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          9,
          (index) {
            final DateTime now = DateTime.now();
            final DateTime date = now.copyWith(day: now.day - index);
            final bool isSelected = date.day == randomDate.day;
            final String week = DateFormat('EEE').format(date);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 21.r),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? aquaMarine : null,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    week.toUpperCase(),
                    style: cabin12.copyWith(
                      color: isSelected ? prussianBlue : ecru,
                    ),
                  ),
                  Gap(1.5.r),
                  Text(
                    date.day.toString().padLeft(2, '0'),
                    style: righteous30.copyWith(
                      color: isSelected ? prussianBlue : ecru,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

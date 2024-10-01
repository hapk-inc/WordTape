import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'common/store_btn.dart';
import 'dashboard/riddle_now.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: <Widget>[
        RiddleNow(),
        SliverToBoxAdapter(child: Gap(15)),
        if (kIsWeb) SliverToBoxAdapter(child: StoreBtn())
        /* SliverToBoxAdapter(
          child: SizedBox(
            height: 900.h,
            child: Center(
              child: Text('Scroll to see the SliverAppBar in effect.'),
            ),
          ),
        ),*/
      ],
    );
  }
}

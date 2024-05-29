import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';

@RoutePage()
class AppStackPage extends StatelessWidget {
  const AppStackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // color: prussianBlue,
      backgroundColor: prussianBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 450.r),
                child: const AutoRouter(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

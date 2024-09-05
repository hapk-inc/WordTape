import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enum/pod.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../router/pod.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/font.dart';
import '../firestore/found.dart';
import '../firestore/puzzle.dart';
import '../local/found.dart';
import '../local/puzzle.dart';
part 'pod.g.dart';

@riverpod
DateTime jun10(Jun10Ref ref) => DateTime(2024, 6, 9);

@Riverpod(keepAlive: true, dependencies: [])
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  @override
  set state(DateTime value) {
    if (super.state == value) return;

    super.state = value;
  }
}

@Riverpod(keepAlive: true, dependencies: [size])
PinTheme pinTheme(PinThemeRef ref,
    {required BoxConstraints constraints, Color color = raisinBlack}) {
  final double maxWidth = constraints.maxWidth;

  final double boxWidth = maxWidth * 0.0975;
  final DefaultTextTheme textTheme = DefaultTextTheme();
  final isConstraintMeasurement = ref.watch(sizeProvider) == ScreenSize.mobile;
  return PinTheme(
    constraints: BoxConstraints(
      minWidth: isConstraintMeasurement ? boxWidth : 40.r,
      maxHeight: 54.h,
    ),
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      //color: cerise,
      border: Border(
        bottom: BorderSide(color: color, width: 0.54.r),
      ),
    ),
    textStyle: textTheme.headlineMedium?.copyWith(color: color),
  );
}

@Riverpod(keepAlive: true, dependencies: [router])
Future<Puzzle?> puzzleFromDate(PuzzleFromDateRef ref, DateTime date) async {
  log("Running selectedPuzzle for ${date.day} - ${date.month}");
  final LocalPuzzle localPuzzle = LocalPuzzle();
  Puzzle? lPuzzle = await localPuzzle.fromDate(date);
  log("From LocalPuzzle $lPuzzle");
  if (lPuzzle == null) {
    final RemotePuzzle cloud = RemotePuzzle(ref);
    Puzzle? cPuzzle = await cloud.puzzle(date);

    if (cPuzzle != null) {
      await localPuzzle.insert(cPuzzle);
      return cPuzzle;
    }
    ref.read(routerProvider).replace('/renovation');
    return cPuzzle;
  }
  return lPuzzle;
}

@Riverpod(dependencies: [])
Future<Found?> foundFromPuzzle(FoundFromPuzzleRef ref, Puzzle p) async {
  final DateTime date = p.date;
  log("Running selectedFound for ${date.day}-${date.month}--${p.id}");
  if (kIsWeb) {
    RemoteFound remoteFound = RemoteFound(ref);
    return remoteFound.found(p.id);
  }

  final LocalFound localFound = LocalFound();
  return localFound.found(p.id);
}

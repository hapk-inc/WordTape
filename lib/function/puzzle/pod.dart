import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enum/pod.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../model/date_ext.dart';
import '../../ui/theme/color.dart';
import '../../ui/theme/font.dart';
import '../firestore/found.dart';
import '../firestore/pod.dart';
import '../firestore/puzzle.dart';
import '../local/found.dart';
import '../local/pod.dart';
import '../local/puzzle.dart';

part 'pod.g.dart';

@riverpod
DateTime jun10(Jun10Ref ref) => DateTime(2024, 6, 9);

@Riverpod(keepAlive: true, dependencies: [])
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() {
    final DateTime now = DateTime.now();
    return now.convert();
  }

  @override
  set state(DateTime value) {
    if (super.state == value) return;
    super.state = value.convert();
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

@Riverpod(keepAlive: true, dependencies: [sqPuzzle, remotePuzzle])
class PuzzleDateArg extends _$PuzzleDateArg {
  @override
  FutureOr<Puzzle?> build({required DateTime date}) async {
    final LocalPuzzle pLocal = ref.read(sqPuzzleProvider);
    Puzzle? puzzle = await pLocal.fromDate(date);
    if (puzzle == null) {
      final RemotePuzzle cloud = ref.read(remotePuzzleProvider);
      Puzzle? cPuzzle = await cloud.puzzle(date);
      if (cPuzzle != null) {
        await pLocal.insert(cPuzzle);
        return cPuzzle;
      }
      final Puzzle puzzle = await pLocal.latest;
      return puzzle;
    }
    return puzzle;
  }
}

@Riverpod(
  keepAlive: true,
  dependencies: [PuzzleDateArg, remoteFound, sqFound],
)
class FoundDateArg extends _$FoundDateArg {
  @override
  Future<Found?> build({required DateTime date}) async {
    final Puzzle? puzzle = ref.watch(puzzleDateArgProvider(date: date)).value;
    if (puzzle == null) return null;

    if (kIsWeb) {
      RemoteFound remoteFound = ref.read(remoteFoundProvider);
      final Found? f = await remoteFound.found(puzzle.id);
      return f ?? Found(date: date, id: puzzle.id);
    }

    final LocalFound localFound = ref.read(sqFoundProvider);
    final Found? f = await localFound.found(puzzle.id);

    return f ?? Found(date: date, id: puzzle.id);
  }

  @override
  set state(AsyncValue<Found?> newState) {
    log("Setting Found", name: "FoundDateArg");
    if (newState.value == null || super.state.value == newState.value) return;
    final Found f = newState.value!;
    if (f.mistake == null) ref.read(sqFoundProvider).insert(newState.value!);
    ref.read(remoteFoundProvider).update(f);
    super.state = newState;
  }
}

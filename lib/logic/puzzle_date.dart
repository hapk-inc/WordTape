import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'puzzle_date.g.dart';

@Riverpod(keepAlive: true)
int puzzleCount(PuzzleCountRef ref) {
  final DateTime now = DateTime.now();
  final DateTime june10 = DateTime(2024, 6, 10);
  final int inDays = now.difference(june10).inDays;
  return inDays;
}

@Riverpod(keepAlive: true)
DateTime puzzleDate(PuzzleDateRef ref, int index) {
  final DateTime now = DateTime.now();
  final DateTime onlyDate = DateTime(now.year, now.month, now.day);
  final DateTime chosenDate = onlyDate.subtract(Duration(days: index));
  return chosenDate;
}

@Riverpod(keepAlive: true)
class ChosenDate extends _$ChosenDate {
  @override
  DateTime build() => DateTime.now();

  @override
  set state(DateTime value) => super.state = value;
}

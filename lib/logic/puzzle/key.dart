import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'key.g.dart';

@Riverpod(keepAlive: true)
class PuzzleKey extends _$PuzzleKey {
  @override
  String build() => mockString();

  @override
  set state(String value) => super.state = value;
}

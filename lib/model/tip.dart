import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mock_data/mock_data.dart';

part 'tip.freezed.dart';

@freezed
class Tip with _$Tip {
  const Tip._();
  const factory Tip({@Default("") String text, @Default("") String t}) = _Tip;

  factory Tip.fromWord(String str, {List<String> soFar = const []}) {
    final List<String> splitter = str.split("");
    splitter.removeAt(0);
    final List<String> remaining = List.from(splitter.where(
      (char) => !soFar.contains(char),
    ));

    final bool isLastOne = remaining.length == 1;

    final String randomChar = isLastOne
        ? remaining[0]
        : remaining[mockInteger(0, remaining.length - 1)];

    //
    final String text = _replaceHash(
      isLastOne
          ? "last_chance_${mockInteger(0, 9)}".tr()
          : "tip_${mockInteger(0, 8)}".tr(),
      [randomChar],
    );

    return Tip(text: text, t: randomChar);
  }

  List<String> remaining(List<String> list1, List<String> list2) => list1
      .where(
        (char) => !list2.contains(char),
      )
      .toList();

  static String _replaceHash(String input, List<String> replace) {
    List<String> parts = input.split('#');
    List<String> r = [];

    for (int i = 0; i < parts.length; i++) {
      r.add(parts[i]);
      if (i < replace.length) r.add(replace[i]);
    }
    return r.join('');
  }
}

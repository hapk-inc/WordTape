import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordtape/enum/enum.dart';

import '../model/found.dart';
import '../model/riddle.dart';
import '../model/underline_text.dart';
import '../underline_text/pod.dart';

final ChangeNotifierProviderFamily<RiddleNotifier, DateTime>
    riddleNotifierProvider =
    ChangeNotifierProvider.family<RiddleNotifier, DateTime>(
  (ref, date) => RiddleNotifier(ref, date: date),
);

class RiddleNotifier extends ChangeNotifier {
  final Ref<RiddleNotifier> ref;
  final DateTime date;
  //
  late final Riddle _riddle = Riddle.fromRandom();
  late Found _found = Found(date: date);
  List<TextEditingController> _pinController = [];
  late List<FocusNode> _nodes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RiddleState _riddleState = RiddleState.launch;
  late UnderlineText _title;

  RiddleNotifier(this.ref, {required this.date}) {
    _title = ref.read(titleProvider).copyWith(end: "?");
  }

  UnderlineText get title => _title;
}

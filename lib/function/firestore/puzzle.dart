import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../firebase/pod.dart';
import '../../model/puzzle.dart';

class RemotePuzzle {
  final Ref ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference puzzleColl;

  User? fUser;

  RemotePuzzle(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firestoreProvider);
    puzzleColl = firebaseFirestore.collection('puzzle');
  }

  Future<Puzzle?> puzzle(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    return puzzleColl.where('date', isEqualTo: dateStr).get().then(
      (QuerySnapshot snapshot) {
        if (snapshot.size == 0) return null;
        if (!snapshot.docs[0].exists) return null;
        Map map = snapshot.docs[0].data() as Map;
        final String id = snapshot.docs[0].id;

        final Puzzle puzzle =
            Puzzle.fromJson(Map<String, dynamic>.from(map)).copyWith(id: id);
        return puzzle;
      },
    );
  }
}

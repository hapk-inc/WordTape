import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';

import '../../firebase/firebase.dart';
import '../../model/found.dart';
import '../../model/player.dart';
import '../../model/puzzle.dart';

class Datastore {
  final Ref<Datastore> ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference puzzleColl;
  late CollectionReference userColl;

  User? fUser;

  Datastore(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firebaseFirestoreProvider);
    userColl = firebaseFirestore.collection('user');
    puzzleColl = firebaseFirestore.collection('puzzle');
  }

  Future<Puzzle?> puzzle(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    return puzzleColl.where('date', isEqualTo: dateStr).get().then(
      (QuerySnapshot snapshot) {
        if (snapshot.size == 0) return null;
        if (!snapshot.docs[0].exists) return null;
        Map map = snapshot.docs[0].data() as Map;
        return Puzzle.fromJson(Map<String, dynamic>.from(map))
            .copyWith(id: snapshot.docs[0].id);
      },
    );
  }

  Future updateFound(Found found) async {
    if (fUser?.uid == null) return null;

    final CollectionReference foundColl =
        puzzleColl.doc(found.id).collection('found');
    if (found.i == 2) {
      return foundColl.doc(fUser?.uid).set(found.toFirestore);
    }
    WriteBatch batch = firebaseFirestore.batch();
    batch.update(foundColl.doc(fUser?.uid), found.toFirestore);
    if (found.i == 6) {
      batch.update(
        puzzleColl.doc(found.id),
        {
          "users": FieldValue.arrayUnion([fUser?.uid])
        },
      );
    }

    return batch.commit();
  }

  Future<Found?> found(String? id) async {
    if (id == null || fUser?.uid == null) return null;
    final CollectionReference foundColl =
        puzzleColl.doc(id).collection('found');
    //
    return foundColl.doc(fUser?.uid).get().then(
      (DocumentSnapshot snapshot) {
        debugPrint("49--Found");
        return !snapshot.exists
            ? null
            : Found.fromJson(snapshot.data() as Map<String, dynamic>)
                .copyWith(id: id);
      },
    );
  }

  Future<Player?> get player async {
    if (fUser?.uid == null) return null;

    return userColl.doc(fUser?.uid).get().then(
      (DocumentSnapshot snapshot) {
        if (!snapshot.exists) return null;
        final Map map = snapshot.data() as Map;
        Player player = Player.fromJson(Map<String, dynamic>.from(map))
            .copyWith(id: snapshot.id);
        return player;
      },
    );
  }

  Future get createUser async {
    if (fUser?.uid == null) return;
    Player player = Player(
      source: kIsWeb ? "web" : "app",
      nowTime: DateTime.now(),
      userId: mockInteger(100000, 999999),
    );
    return userColl.doc(fUser?.uid).set(player.toJson());
  }

  Future updateReveal(Found f, String word) =>
      puzzleColl.doc(f.id).collection('found').doc(fUser?.uid ?? "").update(
        {
          "revealed": FieldValue.arrayUnion([word])
        },
      );
}

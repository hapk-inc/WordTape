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
import '../puzzle/found_notifier.dart';

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

  Future<Found?> found(String? id) async {
    if (id == null || fUser?.uid == null) return null;
    final CollectionReference foundColl =
        puzzleColl.doc(id).collection('found');
    //
    return foundColl.doc(fUser?.uid).get().then(
          (DocumentSnapshot snapshot) => !snapshot.exists
              ? null
              : Found.fromJson(snapshot.data() as Map<String, dynamic>)
                  .copyWith(id: id),
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
    Player player = Player(
      source: kIsWeb ? "web" : "app",
      nowTime: DateTime.now(),
      userId: mockInteger(100000, 999999),
    );

    WriteBatch batch = firebaseFirestore.batch();
    batch.set(userColl.doc(fUser?.uid), player.toJson());

    final Found found = ref.read(foundNotifierProvider).found;

    CollectionReference foundColl =
        puzzleColl.doc(found.id).collection('found');

    batch.set(foundColl.doc(fUser?.uid), found.toJson());

    return batch.commit();
  }

  Future updateFound(Found found) async {
    CollectionReference foundColl =
        puzzleColl.doc(found.id).collection('found');
    DocumentReference docRef = foundColl.doc(fUser?.uid ?? "unknown");
    return firebaseFirestore.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          transaction.set(docRef, found.toJson());
        } else {
          transaction.update(docRef, found.toJson());
        }
      },
    );
  }
}

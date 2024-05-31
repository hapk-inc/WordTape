import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../firebase/firebase.dart';
import '../../model/found.dart';
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

  Future updateFound(Found found) {
    final String a = fUser?.uid ?? "NoUser";
    debugPrint("Running UpdateFound User -> $a");
    return puzzleColl
        .doc(found.id)
        .collection('found')
        .doc(a)
        .set(found.toFirestore);
  }

  Future<Found?> found(String id) {
    final String a = fUser?.uid ?? "NoUser";
    debugPrint("50--Datastore Found UserID-> $a FoundID -> $id");
    return puzzleColl.doc(id).collection('found').doc(a).get().then(
      (DocumentSnapshot snapshot) {
        debugPrint("49--Found");
        return !snapshot.exists
            ? null
            : Found.fromJson(snapshot.data() as Map<String, dynamic>);
      },
      onError: (e, s) {
        debugPrint("55--$e");
      },
    );
  }

  Future get createUser {
    final String a = fUser?.uid ?? "NoUser";
    debugPrint("Creating User ==$a");
    return userColl.doc(a).set(
      {
        'source': kIsWeb ? "web" : "app",
        'nowTime': DateTime.now().toIso8601String(),
      },
    );
  }
}

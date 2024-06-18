import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordtape/logic/puzzle/bloc.dart';

import '../../firebase/firebase.dart';
import '../../model/player.dart';

class UserDatastore {
  final Ref<UserDatastore> ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference userColl;

  User? fUser;

  UserDatastore(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firebaseFirestoreProvider);
    userColl = firebaseFirestore.collection('user');
    if (fUser != null) updateUser;
  }

  Future get updateUser async {
    final String id = fUser?.uid ?? "unknown";
    if (id == "unknown") {
      return ref.read(wordAnalyticsProvider).userError("first_user");
    }
    DocumentReference docRef = userColl.doc(id);
    return firebaseFirestore.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          transaction.set(docRef, Player.newUser().toJson());
        } else {
          Map map = snapshot.data() as Map;
          final DateTime now = DateTime.now();
          Map<String, dynamic> json = Map<String, dynamic>.from(map);
          Player player = Player.fromJson(json);
          if (player.createdAt != null) {
            player = player.copyWith(createdAt: fUser?.metadata.creationTime);
          }
          if (player.nowTime != null) {
            bool sameDay = (player.nowTime?.day ?? 0) != now.day;
            if (!sameDay) player = player.copyWith(nowTime: now);
          }
          transaction.update(docRef, player.toJson());
        }
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
}
/*CollectionReference foundColl =
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
    );*/

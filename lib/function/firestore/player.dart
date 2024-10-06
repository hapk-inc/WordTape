import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/pod.dart';
import '../../model/player.dart';

class FirestoreUser {
  final Ref<FirestoreUser> ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference userColl;
  User? fUser;

  FirestoreUser(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firestoreProvider);
    userColl = firebaseFirestore.collection('user');
  }

  Future<void> updateMe() async {
    final String id = fUser?.uid ?? "unknown";
    log(id, name: "updateMe");
    if (id == "unknown") return;
    DocumentReference docRef = userColl.doc(id);
    return firebaseFirestore.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          Player player = Player.newUser(fUser!);
          transaction.set(docRef, player.toJson());
        } else {
          Map map = snapshot.data() as Map;
          final DateTime now = DateTime.now();
          Map<String, dynamic> json = Map<String, dynamic>.from(map);
          Player player = Player.fromFirestore(json, id: snapshot.id);

          if (player.nowTime != null) {
            final bool sameDay = DateUtils.isSameDay(player.nowTime, now);
            if (!sameDay) player = player.copyWith(nowTime: now);
          }
          transaction.update(docRef, player.toJson());
        }
      },
    ).catchError(
      (e, s) {
        log("updateMe Error", error: e, stackTrace: s);
      },
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase/pod.dart';
import '../../model/found.dart';
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
      maxAttempts: 100,
    ).catchError(
      (e, s) {
        log("updateMe Error", error: e, stackTrace: s);
      },
    );
  }

  Stream<Player?> get player {
    late BehaviorSubject<Player?> subject;
    subject = BehaviorSubject(
      onListen: () => userColl
          .doc(fUser?.uid)
          .withConverter<Player>(
            fromFirestore: (snapshot, _) => Player.fromFirestore(
              snapshot.data() ?? {},
              id: snapshot.id,
            ),
            toFirestore: (value, _) => value.toJson(),
          )
          .snapshots()
          .listen(
        (DocumentSnapshot<Player> documentSnapshot) {
          Player? player = documentSnapshot.data();
          if (!subject.hasValue) {
            if (player != null) subject.add(player);
          } else {
            Player? p = subject.value;
            if (p == player) return;
            subject.add(p);
          }
        },
      ),
    );
    return subject.stream;
  }

  Future<void> userFound(Found found) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(found.date!);
    return userColl.doc(fUser?.uid).update(
      <String, dynamic>{
        'done': FieldValue.arrayUnion([dateStr])
      },
    );
  }
}

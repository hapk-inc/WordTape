import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/pod.dart';

class RemotePlayer {
  final Ref<RemotePlayer> ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference userColl;
  User? fUser;

  RemotePlayer(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firestoreProvider);
    userColl = firebaseFirestore.collection('user');
    //if (fUser != null) updateUser();
  }

  Future<void> updatePlayer() async {
    final String id = fUser?.uid ?? "unknown";
    if (id == "unknown") return;

    DocumentReference docRef = userColl.doc(id);
  }
}

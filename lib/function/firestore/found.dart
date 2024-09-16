import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/pod.dart';
import '../../model/found.dart';

class RemoteFound {
  final Ref ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference pColl;

  User? fUser;

  RemoteFound(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firestoreProvider);
    pColl = firebaseFirestore.collection('puzzle');
  }

  Future<Found?> found(String? id) async {
    if (id == null) return null;
    final CollectionReference foundColl = pColl.doc(id).collection('found');
    //
    return foundColl.doc(fUser?.uid).get().then(
          (DocumentSnapshot snapshot) => !snapshot.exists
              ? null
              : Found.fromJson(snapshot.data() as Map<String, dynamic>)
                  .copyWith(id: id),
        );
  }

  Future update(Found found) async {
    final CollectionReference coll = pColl.doc(found.id).collection('found');
    final DocumentReference doc = coll.doc(fUser?.uid);
    return firebaseFirestore.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(doc);
        if (!snapshot.exists) {
          transaction.set(doc, found.toFirestore());
        } else {
          transaction.update(doc, found.toFirestore());
        }
      },
    );
  }
}

/*if (found.isCompleted && found.fullScore && found.id != null) {
            updatePuzzle(found.id!);
          }*/

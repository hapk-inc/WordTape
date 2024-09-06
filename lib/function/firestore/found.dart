import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/pod.dart';
import '../../model/found.dart';

class RemoteFound {
  final Ref ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference puzzleColl;

  User? fUser;

  RemoteFound(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firestoreProvider);
    puzzleColl = firebaseFirestore.collection('puzzle');
  }

  Future<Found?> found(String? id) async {
    if (id == null) return null;
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
}

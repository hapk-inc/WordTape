import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../firebase/firebase.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../auth/bloc.dart';

class PuzzleDatastore {
  final Ref<PuzzleDatastore> ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference puzzleColl;

  User? fUser;

  PuzzleDatastore(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firebaseFirestoreProvider);
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

  Future<int> foundCount(String? id) async {
    if (id == null) return 0;
    //late BehaviorSubject<int> subject;
    final CollectionReference fColl = puzzleColl.doc(id).collection('found');
    final AggregateQuery countQuery = fColl.count();
    final AggregateQuerySnapshot snapshot = await countQuery.get();
    return snapshot.count ?? 0;
  }

  Future<Found?> found(String? id) async {
    if (id == null || fUser == null) return null;
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

  Future updateFound(Found found) async {
    final String id =
        fUser?.uid ?? ref.read(authUserProvider).value?.uid ?? "unknown";
    if (id == "unknown") return;
    CollectionReference foundColl =
        puzzleColl.doc(found.id).collection('found');
    DocumentReference docRef = foundColl.doc(id);
    return firebaseFirestore.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          transaction.set(docRef, found.toJson());
        } else {
          if (found.isCompleted && found.fullScore && found.id != null) {
            updatePuzzle(found.id!);
          }
          transaction.update(docRef, found.toJson());
        }
      },
    );
  }

  Future updatePuzzle(String found) async {
    final String id =
        fUser?.uid ?? ref.read(authUserProvider).value?.uid ?? "unknown";

    return puzzleColl.doc(found).update(
      {
        'users': FieldValue.arrayUnion([id])
      },
    );
  }
}

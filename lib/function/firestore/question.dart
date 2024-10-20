import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase/pod.dart';
import '../../model/found.dart';
import '../../model/question.dart';
import '../connectivity/pod.dart';

class FirestoreQuestion {
  final Ref ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference collection;

  User? fUser;

  FirestoreQuestion(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firestoreProvider);
    collection = firebaseFirestore.collection('question');
  }

  Future<Question?> question(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    return collection.where('date', isEqualTo: dateStr).get().then(
      (QuerySnapshot snapshot) {
        if (snapshot.size == 0) return null;
        if (!snapshot.docs[0].exists) return null;
        final QueryDocumentSnapshot doc = snapshot.docs[0];
        return Question.fromSnapshot(doc);
      },
    );
  }

  Stream<Question> onQuestionModified(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);
    late BehaviorSubject<Question> subject;
    subject = BehaviorSubject(
      onListen: () =>
          collection.where('date', isEqualTo: dateStr).snapshots().listen(
        (QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final QueryDocumentSnapshot doc = snapshot.docs.first;
            if (doc.exists) {
              final Question r = Question.fromSnapshot(doc);
              subject.add(r);
            }
          }
        },
      ),
    );

    return subject.stream;
  }

  Future firstFound(String id) => collection.doc(id).update(
        <String, dynamic>{
          "played": FieldValue.arrayUnion([fUser?.uid]),
        },
      );

  Future setFound(Found found) => collection
      .doc(found.id)
      .collection("found")
      .doc(fUser?.uid)
      .set(found.toFirestore());

  Future<Found?> found(String id) async => fUser == null
      ? null
      : collection.doc(id).collection("found").doc(fUser?.uid).get().then(
          (DocumentSnapshot<Map<String, dynamic>> snapshot) {
            if (!snapshot.exists) return null;
            final Found found =
                Found.fromJson(snapshot.data() ?? {}).copyWith(id: snapshot.id);
            return found;
          },
          onError: (e, s) {
            // print("81==$e");
            if (e is FirebaseException) {
              switch (e.code) {
                case "unavailable":
                  {
                    ref.read(validateConnectionProvider().notifier).state = -1;
                    break;
                  }
                default:
                  {}
              }
            }
          },
        );

  //DO NOT REMOVE
  /*Stream<Riddle> get onRiddleChanged {
    late BehaviorSubject<Riddle> subject;
    subject = BehaviorSubject(
      onListen: () => collectionReference.snapshots().listen(
        (QuerySnapshot snapshot) {
          for (DocumentChange change in snapshot.docChanges) {
            if (change.type != DocumentChangeType.removed) {
              final Map map = change.doc.data() as Map;
              final String id = change.doc.id;
              final Map<String, dynamic> m = Map<String, dynamic>.from(map);
              final Riddle r = Riddle.fromFirestore(m).copyWith(id: id);
              subject.add(r);
            }
          }
        },
      ).onError((e, s) {
        log("60==onRiddle", error: e);
      }),
    );
    return subject.stream;
  }*/
}

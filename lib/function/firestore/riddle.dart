import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase/pod.dart';
import '../../model/riddle.dart';

class FirestoreRiddle {
  final Ref ref;

  late FirebaseFirestore firebaseFirestore;
  late CollectionReference collectionReference;

  User? fUser;

  FirestoreRiddle(this.ref, {this.fUser}) {
    firebaseFirestore = ref.read(firestoreProvider);
    collectionReference = firebaseFirestore.collection('puzzle');
  }

  Future<Riddle?> riddle(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    return collectionReference.where('date', isEqualTo: dateStr).get().then(
      (QuerySnapshot snapshot) {
        if (snapshot.size == 0) return null;
        if (!snapshot.docs[0].exists) return null;
        final Map map = snapshot.docs[0].data() as Map;
        final String id = snapshot.docs[0].id;
        final Map<String, dynamic> m = Map<String, dynamic>.from(map);
        final Riddle r = Riddle.fromFirestore(m).copyWith(id: id);
        return r;
      },
    );
  }

  Stream<Riddle> onRiddleModified(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);
    late BehaviorSubject<Riddle> subject;
    subject = BehaviorSubject(
      onListen: () => collectionReference
          .where('date', isEqualTo: dateStr)
          .snapshots()
          .listen(
        (QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final QueryDocumentSnapshot doc = snapshot.docs.first;
            final Map map = doc.data() as Map;
            final String id = doc.id;
            final Map<String, dynamic> m = Map<String, dynamic>.from(map);
            final Riddle r = Riddle.fromFirestore(m).copyWith(id: id);
            subject.add(r);
          }
        },
      ),
    );

    return subject.stream;
  }

  Future firstFound(String id) => collectionReference.doc(id).update(
        <String, dynamic>{
          "played": FieldValue.increment(1),
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

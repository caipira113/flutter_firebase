import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessage() {
    return _db
        .collection("message")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String text, String userId) {
    return _db.collection("message").add({
      "text": text,
      "userId": userId,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}

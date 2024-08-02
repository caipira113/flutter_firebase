import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatRooms() {
    return _db.collection('chatrooms').orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _db.collection('chatrooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> sendMessage(String text, String userId, String email, String chatRoomId) {
    final newMessage = {
      'text': text,
      'userId': userId,
      'email': email,
      'timestamp': FieldValue.serverTimestamp(),
    };

    return _db.collection('chatrooms').doc(chatRoomId).collection('messages').add(newMessage).then((_) {
      _db.collection('chatrooms').doc(chatRoomId).update({
        'lastMessage': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> createChatRoom(String name) {
    return _db.collection('chatrooms').add({
      'name': name,
      'lastMessage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

}
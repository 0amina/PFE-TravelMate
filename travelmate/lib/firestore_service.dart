import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Model/conversation_model.dart';
import 'package:travelmate/Model/message_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Conversation>> getTravelerConversations(String travelerId) {
    return _db.collection('conversations')
      .where('senderId', isEqualTo: travelerId)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => Conversation.fromDocument(doc))
        .toList());
  }

  Stream<List<Conversation>> getHostConversations(String hostId) {
    return _db.collection('conversations')
      .where('receiverId', isEqualTo: hostId)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => Conversation.fromDocument(doc))
        .toList());
  }

  Stream<List<Message>> getMessages(String conversationId) {
    return _db.collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromDocument(doc))
        .toList());
  }

  Future<void> sendMessage(String conversationId, Message message) async {
    final messageDocRef = _db.collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .doc();

    await messageDocRef.set(message.toMap());

    // Update the last message in the conversation
    await _db.collection('conversations')
      .doc(conversationId)
      .update({
        'lastMessage': message.text,
        'lastMessageTimestamp': message.timestamp,
      });
  }

  Future<String> createOrGetConversation(String senderId, String receiverId) async {
    final query = await _db.collection('conversations')
      .where('senderId', isEqualTo: senderId)
      .where('receiverId', isEqualTo: receiverId)
      .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    final conversation = Conversation(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      createdAt: Timestamp.now(),
      lastMessage: '',
    );

    final docRef = await _db.collection('conversations').add(conversation.toMap());
    return docRef.id;
  }
}

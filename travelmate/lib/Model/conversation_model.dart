import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String id;
  String senderId;
  String receiverId;
  Timestamp createdAt;
  String lastMessage;

  Conversation({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.lastMessage,
  });

  factory Conversation.fromDocument(DocumentSnapshot doc) {
    return Conversation(
      id: doc.id,
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      createdAt: doc['createdAt'],
      lastMessage: doc['lastMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
    };
  }
}

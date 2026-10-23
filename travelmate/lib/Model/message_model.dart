import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String senderId;
  String text;
  Timestamp timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      id: doc.id,
      senderId: doc['senderId'],
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}

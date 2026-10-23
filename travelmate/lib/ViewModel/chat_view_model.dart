import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/conversation_model.dart';
import 'package:travelmate/Model/message_model.dart';

class ChatViewModel with ChangeNotifier {
  List<Message> _messages = [];
  List<Conversation> _conversations = [];

  List<Message> get messages => _messages;
  List<Conversation> get conversations => _conversations;

  Future<void> fetchMessages(String conversationId) async {
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    _messages = messagesSnapshot.docs.map((doc) {
      return Message(
        id: doc.id,
        senderId: doc['senderId'],
        text: doc['text'],
        timestamp: doc['timestamp'],
      );
    }).toList();
    notifyListeners();
  }

  Future<void> sendMessage(String conversationId, Message message, {bool isImage = false}) async {
  final conversationRef = FirebaseFirestore.instance.collection('conversations').doc(conversationId);

  await conversationRef.collection('messages').add({
    'senderId': message.senderId,
    'text': message.text,
    'timestamp': message.timestamp,
  });

  await conversationRef.set({
    'lastMessage': isImage ? 'Sent a photo' : message.text,
    'lastMessageTimestamp': message.timestamp,
  }, SetOptions(merge: true));

  fetchMessages(conversationId);
}


  Future<String> createOrGetConversation(String senderId, String receiverId) async {
    final conversationsRef = FirebaseFirestore.instance.collection('conversations');

    final querySnapshot = await conversationsRef
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }

    final reverseQuerySnapshot = await conversationsRef
        .where('senderId', isEqualTo: receiverId)
        .where('receiverId', isEqualTo: senderId)
        .get();

    if (reverseQuerySnapshot.docs.isNotEmpty) {
      return reverseQuerySnapshot.docs.first.id;
    }

    final newConversationRef = conversationsRef.doc();
    await newConversationRef.set({
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': Timestamp.now(),
      'lastMessage': '',
    });

    return newConversationRef.id;
  }

  Stream<List<Conversation>> travelerConversationsStream(String travelerId) {
    return FirebaseFirestore.instance
        .collection('conversations')
        .where('senderId', isEqualTo: travelerId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Conversation.fromDocument(doc)).toList());
  }

  Stream<List<Conversation>> hostConversationsStream(String hostId) {
    return FirebaseFirestore.instance
        .collection('conversations')
        .where('receiverId', isEqualTo: hostId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Conversation.fromDocument(doc)).toList());
  }

  Future<void> fetchConversationsAsTraveler(String currentUserId) async {
    final senderConversationsSnapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .where('senderId', isEqualTo: currentUserId)
        .get();

    _conversations = senderConversationsSnapshot.docs.map((doc) {
      return Conversation.fromDocument(doc);
    }).toList();

    notifyListeners();
  }

  Future<void> fetchConversationsAsHost(String currentUserId) async {
    final receiverConversationsSnapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .where('receiverId', isEqualTo: currentUserId)
        .get();

    _conversations = receiverConversationsSnapshot.docs.map((doc) {
      return Conversation.fromDocument(doc);
    }).toList();

    notifyListeners();
  }
}

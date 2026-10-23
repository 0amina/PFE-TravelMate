import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Model/message_model.dart';
import 'package:travelmate/ViewModel/chat_view_model.dart';

class ConversationPage extends StatelessWidget {
  final String userName;
  final String receiverId;
  final String senderId;
  final String conversationId;
  final TextEditingController messageController = TextEditingController();

  ConversationPage({
    Key? key,
    required this.userName,
    required this.receiverId,
    required this.senderId,
    required this.conversationId,
  }) : super(key: key);

  Future<void> sendMessage(BuildContext context) async {
    if (messageController.text.isEmpty) return;

    final viewModel = Provider.of<ChatViewModel>(context, listen: false);
    final newMessage = Message(
      id: '',
      senderId: senderId,
      text: messageController.text,
      timestamp: Timestamp.now(),
    );

    await viewModel.sendMessage(conversationId, newMessage, isImage: false);
    messageController.clear();
  }

  Future<void> sendImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');

      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();

      final viewModel = Provider.of<ChatViewModel>(context, listen: false);
      final newMessage = Message(
        id: '',
        senderId: senderId,
        text: imageUrl,
        timestamp: Timestamp.now(),
      );

      await viewModel.sendMessage(conversationId, newMessage, isImage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    viewModel.fetchMessages(conversationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final message = viewModel.messages[index];
                final isMe = message.senderId == senderId;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMe ? Color.fromARGB(151, 255, 146, 99) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: message.text.startsWith('https://')
                          ? GestureDetector(
                              onTap: () {
                                // Implement image viewer if necessary
                              },
                              child: Image.network(
                                message.text,
                                width: 200,
                                height: 200,
                              ),
                            )
                          : Text(
                              message.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () => sendImage(context, ImageSource.gallery),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => sendImage(context, ImageSource.camera),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/conversation_model.dart';
import 'package:travelmate/View/Traveler/conversation_page.dart';
import 'package:travelmate/ViewModel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostInbox extends StatefulWidget {
  const HostInbox({Key? key}) : super(key: key);

  @override
  State<HostInbox> createState() => _HostInboxState();
}

class _HostInboxState extends State<HostInbox> {
  late String currentUserId;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    currentUserId = AppConstants.currentUser.id!;
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return {
      'name': userDoc['name'],
      'photoUrl': userDoc['photoUrl'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Host Inbox'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Conversation>>(
              stream: Provider.of<ChatViewModel>(context).hostConversationsStream(currentUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final conversations = snapshot.data!;
                if (conversations.isEmpty) {
                  return const Center(child: Text('No conversations yet.'));
                }

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    final senderId = conversation.senderId; // Show the traveler
                    final lastMessage = conversation.lastMessage;

                    return FutureBuilder<Map<String, dynamic>>(
                      future: getUserDetails(senderId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const ListTile(
                            title: Text('Loading...'),
                          );
                        }

                        final userDetails = snapshot.data!;
                        final senderName = userDetails['name'].toLowerCase();
                        if (!senderName.contains(searchQuery)) {
                          return Container(); // Hide non-matching items
                        }

                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: userDetails['photoUrl'] != null
                                    ? NetworkImage(userDetails['photoUrl'])
                                    : const NetworkImage('https://via.placeholder.com/150'),
                              ),
                              title: Text(userDetails['name']),
                              subtitle: lastMessage.startsWith('https://')
                                  ? const Text('Sent a photo')
                                  : Text(lastMessage),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConversationPage(
                                      userName: userDetails['name'],
                                      receiverId: senderId,
                                      senderId: currentUserId,
                                      conversationId: conversation.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

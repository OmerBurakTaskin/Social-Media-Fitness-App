import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/services/chat_sevice.dart';
import 'package:gym_application/models/user.dart';

class ChattingScreen extends StatefulWidget {
  final User receiver;
  const ChattingScreen({super.key, required this.receiver});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final _chatService = ChatService();
  final _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackGroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.receiver.name,
          style: TextStyle(color: lightGreyHeaderColor),
        ),
        backgroundColor: darkBackGroundColor,
      ),
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
          stream: _chatService.getMessages(
              _auth.currentUser!.uid, widget.receiver.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Text("Error");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListView(
                children: snapshot.data!.docs
                    .map((document) => _buildChatBubble(document))
                    .toList());
          },
        )),
        Container(
            decoration: BoxDecoration(color: darkBackGroundColor),
            child: chatTextBar())
      ]),
    );
  }

  Widget chatTextBar() {
    return Container(
        decoration: BoxDecoration(color: darkBackGroundColor),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: lightGreyTextColor,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    fillColor: Colors.black,
                    border: null,
                    hintText: "Message...",
                    hintStyle: TextStyle(color: Colors.grey)),
                controller: _messageController,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.blue),
              child: Center(
                child: IconButton(
                    onPressed: () {
                      _sendMessage();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ));
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiver.userId, _messageController.text);
      _messageController.clear();
    }
  }

  Widget _buildChatBubble(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isSender = data["senderId"] == _auth.currentUser!.uid;
    var alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    var bubbleColor =
        isSender ? senderMessageBubbleColor : receiverMessageBubbleColor;
    return Align(
      alignment: alignment,
      child: Container(
        decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isSender ? const Radius.circular(15) : Radius.zero,
                bottomRight:
                    isSender ? Radius.zero : const Radius.circular(15))),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(data["message"], style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/models/message.dart';
import 'package:gym_application/services/chat_sevice.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/utils.dart';

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
  bool _attachMedia = true;
  bool _showMediaOptions = false;
  bool _isMedia = false;
  File _selectedImage = File("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor1,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.receiver.name,
          style: TextStyle(color: lightGreyHeaderColor),
        ),
        backgroundColor: themeColor1,
      ),
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
          stream: _chatService.getMessages(
              _auth.currentUser!.uid, widget.receiver.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Text("Error");
            if (snapshot.hasData) {
              return ListView(
                  children: snapshot.data!.docs
                      .map((document) => _buildChatBubble(document))
                      .toList());
            }
            return const Center(child: CircularProgressIndicator());
          },
        )),
        Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: chatTextBar())
      ]),
    );
  }

  Widget chatTextBar() {
    return Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            _isMedia
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                            maxWidth: MediaQuery.sizeOf(context).width - 60),
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: Image.file(
                              _selectedImage,
                              fit: BoxFit.contain,
                            ))),
                  )
                : Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(60)),
                          color: themeColor2),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        cursorColor: lightGreyTextColor,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            fillColor: Colors.black,
                            border: null,
                            hintText: "Message...",
                            hintStyle: TextStyle(color: Colors.grey)),
                        controller: _messageController,
                        onChanged: (value) {
                          if (_messageController.text.trim().isNotEmpty) {
                            setState(() {
                              _attachMedia = false;
                              _showMediaOptions = false;
                            });
                          } else {
                            setState(() {
                              _attachMedia = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
            _attachMedia
                ? AnimatedContainer(
                    width: _showMediaOptions ? 100 : 50,
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: themeColor6),
                    child: Center(
                        child: _showMediaOptions
                            ? Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        File? selectedImage =
                                            await getImageFromGallery(context);
                                        if (selectedImage != null) {
                                          _isMedia = true;
                                          _selectedImage = selectedImage;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        File? selectedImage =
                                            await getImageFromGallery(context);
                                        if (selectedImage != null) {
                                          setState(() {
                                            _isMedia = true;
                                            _selectedImage = selectedImage;
                                            _attachMedia = false;
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.photo,
                                        color: Colors.white,
                                      ))
                                ],
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showMediaOptions = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: Colors.white,
                                ))))
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: themeColor6),
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
                  ),
          ],
        ));
  }

  void _sendMessage() async {
    if (_isMedia) {
      await _chatService.sendImageMessage(_selectedImage, widget.receiver);
      setState(() {
        _isMedia = false;
        _selectedImage = File("");
        _attachMedia = true;
        _showMediaOptions = false;
      });
    } else {
      if (_messageController.text.trim().isNotEmpty) {
        await _chatService.sendMessage(
            widget.receiver.userId, _messageController.text);
        _messageController.clear();
        setState(() {
          _attachMedia = true;
          _showMediaOptions = false;
        });
      }
    }
  }

  Widget _buildChatBubble(DocumentSnapshot document) {
    Message message = Message.fromJson(document.data() as Map<String, dynamic>);
    bool isSender = message.senderId == _auth.currentUser!.uid;
    bool isMedia = message.isMedia;
    var alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    var bubbleColor =
        isSender ? senderMessageBubbleColor : receiverMessageBubbleColor;
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
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
              isMedia
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                          // height: 250,
                          // width: 250,
                          child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: CachedNetworkImage(
                          imageUrl: message.data,
                          fit: BoxFit.cover,
                        ),
                      )),
                    )
                  : Text(message.data,
                      style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}

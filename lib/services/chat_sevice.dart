import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_application/models/message.dart';
import 'package:gym_application/models/user.dart';

class ChatService {
  final _firebaseAuth = auth.FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> sendMessage(String receiverId, String message,
      {bool isMedia = false}) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String userMail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp messageTime = Timestamp.now();

    final newMessage = Message(
        senderId: currentUserId,
        senderMail: userMail,
        receiverId: receiverId,
        data: message,
        timestamp: messageTime,
        isMedia: isMedia);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toJson());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  Future<void> sendImageMessage(File file, User receiver) async {
    final ids = [_firebaseAuth.currentUser!.uid, receiver.userId];
    ids.sort();
    final chatRoomId = ids.join("_");
    final mediaMessagesRef = _storage
        .ref()
        .child(receiver.userId)
        .child("chat_media")
        .child(chatRoomId);

    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = file.path.split("/").last;
    final uploadRef = mediaMessagesRef.child("$timeStamp-$fileName");
    await uploadRef.putFile(file);
    final imageURL = await uploadRef.getDownloadURL();
    final message = Message(
        senderId: _firebaseAuth.currentUser!.uid,
        senderMail: _firebaseAuth.currentUser!.email!,
        receiverId: receiver.userId,
        data: imageURL,
        timestamp: Timestamp.now(),
        isMedia: true);

    _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(message.toJson());
  }
}

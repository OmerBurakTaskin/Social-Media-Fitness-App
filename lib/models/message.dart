import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderMail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  Message(
      {required this.senderId,
      required this.senderMail,
      required this.receiverId,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderMail": senderMail,
      "receiverId": receiverId,
      "message": message,
      "timeStamp": timestamp
    };
  }
}

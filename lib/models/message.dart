import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderMail;
  final String receiverId;
  final String data;
  final Timestamp timestamp;
  final bool isMedia;

  Message(
      {required this.senderId,
      required this.senderMail,
      required this.receiverId,
      required this.data,
      required this.timestamp,
      this.isMedia = false});

  Message.fromJson(Map<String, dynamic> json)
      : this(
            senderId: json["senderId"] as String,
            senderMail: json["senderMail"] as String,
            receiverId: json["receiverId"] as String,
            data: json["message"] as String,
            timestamp: json["timeStamp"] as Timestamp,
            isMedia: json["isMedia"] as bool);

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "senderMail": senderMail,
      "receiverId": receiverId,
      "message": data,
      "timeStamp": timestamp,
      "isMedia": isMedia
    };
  }
}

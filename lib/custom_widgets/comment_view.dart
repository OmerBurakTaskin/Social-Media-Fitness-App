// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/models/user.dart';

class CommentView extends StatelessWidget {
  final String commentText;
  final User author;
  const CommentView({
    required this.commentText,
    required this.author,
    super.key,
  });

//TODO: CİRCLE AVATAR KISMINDA USER CLASSINDAN FOTOĞRAF ÇEKİLECEK
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            /* user düzeltildiğinde buraya photo url gelecek*/ CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://i.pinimg.com/564x/bd/cc/de/bdccde33dea7c9e549b325635d2c432e.jpg"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "burak" /*author.userName*/,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: lightGreyHeaderColor),
                  ),
                  Text(
                    "deneme text",
                    style: TextStyle(color: lightGreyTextColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

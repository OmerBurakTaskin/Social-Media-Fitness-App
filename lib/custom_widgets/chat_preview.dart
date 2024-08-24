import 'package:firebase_auth/firebase_auth.dart' as auth;
import "package:gym_application/models/user.dart";
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/screens/chatting_screen.dart';
import 'package:gym_application/utils.dart';

class ChatPreview extends StatelessWidget {
  final User receiver;
  const ChatPreview({super.key, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      child: GestureDetector(
        onTap: () {
          //chat ekranına götür
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChattingScreen(receiver: receiver)));
        },
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    FutureBuilder(
                        future: getProfilePictureURL(receiver.userId),
                        builder: (context, snapshot) {
                          return CircleAvatar(
                              radius: 24,
                              foregroundImage: NetworkImage(snapshot.data ??
                                  "https://i.pinimg.com/564x/bd/cc/de/bdccde33dea7c9e549b325635d2c432e.jpg"));
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(receiver.name,
                          style: TextStyle(
                              color: lightGreyTextColor, fontSize: 17)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/fire_icon.svg'),
                    const Text(
                      "15",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/screens/chatting_screen.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:gym_application/utils.dart';

class StartChatScreen extends StatelessWidget {
  StartChatScreen({super.key});
  final _userDbService = UserDbService();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "tag-1",
      child: FutureBuilder(
        future: _userDbService.getUserFriends(currentUser.uid),
        builder: (context, snapshot) {
          return buildAccordingSnapshot(snapshot) ??
              Expanded(
                  child: ListView(
                      children: snapshot.data!
                          .map((e) => createChatListTile(e))
                          .toList()));
        },
      ),
    );
  }

  Widget createChatListTile(String userId) {
    Future<List<dynamic>> getFutures() {
      return Future.wait([
        getProfilePictureURL(userId),
        _userDbService.getSpecificUser(userId)
      ]);
    }

    return FutureBuilder(
        future: getFutures(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("An Error Occured"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          }
          if (snapshot.hasData) {
            final profilePictureURL = snapshot.data?[0] ??
                "https://i.pinimg.com/564x/bd/cc/de/bdccde33dea7c9e549b325635d2c432e.jpg";
            final receiver = snapshot.data![1];
            return Material(
              color: Colors.transparent,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(profilePictureURL),
                ),
                title: Text(receiver.userName,
                    style: TextStyle(color: lightGreyHeaderColor)),
                subtitle: Text(receiver.name,
                    style: TextStyle(color: lightGreyTextColor)),
                onTap: () async {
                  await _userDbService.addChattingFriendToUser(
                      currentUser.uid, receiver.userId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChattingScreen(receiver: receiver),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text("An Error Occured"));
        });
  }
}

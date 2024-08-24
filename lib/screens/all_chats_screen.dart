import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/chat_preview.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/services/user_db_service.dart';

class AllChatsScreen extends StatelessWidget {
  AllChatsScreen({super.key});

  final _userDbService = UserDbService();
  final _userId = auth.FirebaseAuth.instance.currentUser!.uid;

  /*final user = User(
      email: "taskinburak2014@gmail.com",
      name: "Ömer Burak",
      surName: "Taşkın",
      userId: "",
      userName: "omerr_burakk");*/

  Future<List<User?>> getReceivers() async {
    List<String> receiverIds =
        await _userDbService.getChattingFriendsOfUser(_userId);
    List<User?> receivers = [];
    for (var i in receiverIds) {
      final receiver = await _userDbService.getSpecificUser(i);
      if (receiver != null) {
        receivers.add(receiver);
      }
    }
    return receivers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getReceivers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        List receivers = snapshot.data!;
        if (receivers.isEmpty) {
          return Text("No conversations yet",
              style: TextStyle(fontSize: 20, color: lightGreyHeaderColor));
        }
        return ListView(
            children: receivers
                .map((user) => ChatPreview(receiver: user as User))
                .toList());
      },
    );
  }
}

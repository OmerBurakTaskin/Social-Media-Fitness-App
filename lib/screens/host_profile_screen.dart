import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/profile_picture.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/screens/login_screen.dart';
import 'package:gym_application/screens/view_posts_screen.dart';
import 'package:gym_application/services/authentication_service.dart';
import 'package:gym_application/services/post_db_service.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:gym_application/utils.dart';

class HostProfileScreen extends StatelessWidget {
  final _userDbService = UserDbService();
  final _postsDbService = PostDbService();
  final _user = auth.FirebaseAuth.instance.currentUser!;
  late final User? host;
  HostProfileScreen({super.key}) {
    initializeHost();
  }

  void initializeHost() async {
    User? fetchedUser = await _userDbService.getSpecificUser(_user.uid);
    if (fetchedUser != null) {
      host = fetchedUser;
    } else {
      host =
          User(userId: "1", userName: "User", email: "", name: "", surName: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildUpperProfile(context),
          const SizedBox(height: 20),
          Expanded(child: _buildPostsGrid(context))
        ],
      ),
    );
  }

  Widget _buildUpperProfile(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ProfilePicture(userId: host!.userId, radius: 50),
      const SizedBox(width: 30),
      Text(
        host!.userName,
        style: TextStyle(color: lightGreyTextColor, fontSize: 18),
      ),
    ]);
  }

  Widget _buildPostsGrid(BuildContext context) {
    final postsdbservice = PostDbService();
    return StreamBuilder(
      stream: postsdbservice.getSpecificUsersPosts(host!.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.blue));
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List postsSnapshot = snapshot.data!.docs;
          //final width = MediaQuery.of(context).size.width;
          return GridView.builder(
            itemCount: postsSnapshot.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              final post = Post.fromJson(postsSnapshot[index].data());
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  child: SizedBox(
                    //width: width,
                    child: Image.network(
                      post.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewPostsScreen(
                                  postsOwner: host!,
                                )));
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "No posts yet",
              style: TextStyle(color: lightGreyTextColor, fontSize: 16),
            ),
          );
        }
      },
    );
  }

  Widget sendFriendRequestButton(
      BuildContext context, String senderuserId, String receiverUserId) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () async {
          await _userDbService.sendFriendRequest(_user.uid, host!.userId);
        },
        child:
            Text("Send request", style: TextStyle(color: lightGreyTextColor)));
  }
}

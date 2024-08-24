import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/screens/view_posts_screen.dart';
import 'package:gym_application/services/authentication_service.dart';
import 'package:gym_application/services/posts_db_service.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:gym_application/utils.dart';

class ProfileScreen extends StatelessWidget {
  bool ishost = false;
  late final User? user;
  final _userDbService = UserDbService();
  final _user = auth.FirebaseAuth.instance.currentUser!;
  bool isFriend = false;
  ProfileScreen({super.key, required this.user}) {
    setIsFriend();
  }
  ProfileScreen.host({super.key}) {
    ishost = true;
    initializeUser(_user.uid);
  }

  void initializeUser(String userId) async {
    user = await _userDbService.getSpecificUser(userId);
  }

  void setIsFriend() async {
    final guest = await _userDbService.getSpecificUser(_user.uid) as User;
    if (guest.chattingFriends.contains(user!.userId)) {
      isFriend == true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: getProfilePictureURL(user!.userId),
                  builder: (context, snapshot) {
                    return CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(snapshot.data ??
                            "https://i.pinimg.com/564x/bd/cc/de/bdccde33dea7c9e549b325635d2c432e.jpg"));
                  }),
              const SizedBox(width: 30),
              Text(
                user!.userName,
                style: TextStyle(color: lightGreyTextColor, fontSize: 18),
              ),
              const SizedBox(width: 30),
              ishost
                  ? IconButton(
                      onPressed: () => _showSettings(context),
                      icon: const Icon(Icons.more_vert))
                  : const SizedBox(),
              isFriend
                  ? removeFromFriendsButton(context, _user.uid, user!.userId)
                  : sendFriendRequestButton(context, _user.uid, user!.userId)
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildPostsGrid(context))
        ],
      ),
    );
  }

  Widget profileMenuButton(
      Widget content, BuildContext context, void Function() onPressedMethod) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey))),
      child: TextButton(
        onPressed: onPressedMethod,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: const Size(300, 50),
          foregroundColor: const Color.fromARGB(255, 206, 201, 201),
        ),
        child: content,
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: darkBackGroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  profileMenuButton(const Text("SignOut"), context,
                      () => AuthenticationService.logOut()),
                  profileMenuButton(const Text("Settings"), context,
                      () => AuthenticationService.logOut()),
                  profileMenuButton(const Text("Upload Image"), context,
                      () async {
                    File? file = await getImageFromGallery(context);
                    if (file != null) {
                      final isSuccess = await uploadPost(file);
                      if (isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Image posted!")));
                      } else {
                        print("An error occured!");
                      }
                    }
                  }),
                  profileMenuButton(
                      const Text("Change Profile Picture"), context, () async {
                    File? file = await getImageFromGallery(context);
                    if (file != null) {
                      addOrChangeProfilePicture(file);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "An error occured. Please try again later.")));
                    }
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostsGrid(BuildContext context) {
    final postsdbservice = PostsDbService();
    return StreamBuilder(
      stream: postsdbservice.getSpecificUsersPosts(user!.userId),
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
                            builder: (context) =>
                                ViewPostsScreen(initialPostIndex: index)));
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
          await _userDbService.sendFriendRequest(_user.uid, user!.userId);
        },
        child:
            Text("Send request", style: TextStyle(color: lightGreyTextColor)));
  }

  Widget removeFromFriendsButton(
      BuildContext context, String senderuserId, String receiverUserId) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () async {},
        child:
            Text("Remove friend", style: TextStyle(color: lightGreyTextColor)));
  }
}

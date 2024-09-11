import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/profile_picture.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/screens/view_posts_screen.dart';
import 'package:gym_application/services/post_db_service.dart';
import 'package:gym_application/services/user_db_service.dart';

// ignore: must_be_immutable
class ViewProfileScreen extends StatelessWidget {
  final User profileOwner;
  final _userDbService = UserDbService();
  final _guest = auth.FirebaseAuth.instance.currentUser!;
  bool isFriend = false;
  ViewProfileScreen({super.key, required this.profileOwner}) {
    if (profileOwner.friends.contains(_guest.uid)) isFriend = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackGroundColor,
      appBar: AppBar(
          iconTheme: IconThemeData(color: lightGreyHeaderColor),
          backgroundColor: darkBackGroundColor,
          title: Text(profileOwner.userName, style: lightGreyHeadertStyle)),
      body: Expanded(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildUpperProfile(context),
            const SizedBox(height: 20),
            Expanded(child: _buildPostsGrid(context))
          ],
        ),
      ),
    );
  }

  Widget _buildUpperProfile(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProfilePicture(userId: profileOwner.userId, radius: 50),
              const SizedBox(width: 50),
              Text(
                "${profileOwner.friends.length}\nGymBuddies",
                textAlign: TextAlign.center,
                style: TextStyle(color: lightGreyTextColor, fontSize: 16),
              ),
              const SizedBox(width: 30),
              Text(
                "${profileOwner.friends.length}\nStreak",
                textAlign: TextAlign.center,
                style: TextStyle(color: lightGreyTextColor, fontSize: 16),
              ),
              const SizedBox(width: 10)
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _profileSideItems(context))
      ],
    );
  }

  Widget _buildPostsGrid(BuildContext context) {
    final postsdbservice = PostDbService();
    if (!isFriend) {
      return Center(
          child: Text("Send friend request to see posts.",
              textAlign: TextAlign.center,
              style: TextStyle(color: lightGreyHeaderColor, fontSize: 30)));
    }
    return StreamBuilder(
      stream: postsdbservice.getSpecificUsersPosts(profileOwner.userId),
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
                                ViewPostsScreen(postsOwner: profileOwner)));
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
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)))),
        onPressed: () async {
          await _userDbService.sendFriendRequest(
              _guest.uid, profileOwner.userId);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text("Add GymBuddy",
              textAlign: TextAlign.center,
              style: TextStyle(color: lightGreyTextColor, fontSize: 13)),
        ));
  }

  Widget removeFromFriendsButton(
      BuildContext context, String senderuserId, String receiverUserId) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)))),
        onPressed: () async {},
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text("Remove GymBuddy",
              textAlign: TextAlign.center,
              style: TextStyle(color: lightGreyTextColor, fontSize: 13)),
        ));
  }

  Widget _profileSideItems(BuildContext context) {
    if (isFriend) {
      return removeFromFriendsButton(context, _guest.uid, profileOwner.userId);
    }
    if (!isFriend) {
      return sendFriendRequestButton(context, _guest.uid, profileOwner.userId);
    }
    return const SizedBox();
  }
}

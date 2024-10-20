import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/profile_picture.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/providers/ui_provider.dart';
import 'package:gym_application/screens/view_posts_screen.dart';
import 'package:gym_application/services/post_db_service.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ViewProfileScreen extends StatefulWidget {
  final User profileOwner;
  const ViewProfileScreen({super.key, required this.profileOwner});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _userDbService = UserDbService();
  final _guest = auth.FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UIProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: provider.backgroundColor,
      appBar: AppBar(
          iconTheme: IconThemeData(color: lightGreyHeaderColor),
          backgroundColor: Colors.transparent,
          title:
              Text(widget.profileOwner.userName, style: lightGreyHeadertStyle)),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ProfilePicture(userId: widget.profileOwner.userId, radius: 50),
              Text(
                "${widget.profileOwner.friends.length}\nGym Partners",
                textAlign: TextAlign.center,
                style: TextStyle(color: lightGreyTextColor, fontSize: 16),
              ),
              Text(
                "${widget.profileOwner.friends.length}\nStreak",
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
    final isFriend = widget.profileOwner.friends.contains(_guest.uid);
    if (!isFriend) {
      return Center(
          child: Text("Send friend request to see the progress.",
              textAlign: TextAlign.center,
              style: TextStyle(color: lightGreyHeaderColor, fontSize: 30)));
    }
    return StreamBuilder(
      stream: postsdbservice.getSpecificUsersPosts(widget.profileOwner.userId),
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
                                postsOwner: widget.profileOwner)));
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

  Widget friendOperationsButton(
      Function buttonFunc, Color buttonColor, String buttonText) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)))),
        onPressed: () async => buttonFunc,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Text(buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(color: lightGreyTextColor, fontSize: 14)),
        ));
  }

  Widget _profileSideItems(BuildContext context) {
    final isFriend = widget.profileOwner.friends.contains(_guest.uid);
    if (isFriend) {
      return friendOperationsButton(
          () async => _userDbService.removeFromFriends(
              _guest.uid, widget.profileOwner.userId),
          Colors.redAccent,
          "Remove from friends");
    } else {
      return friendOperationsButton(
          () async => _userDbService.addToFriends(
              _guest.uid, widget.profileOwner.userId),
          Colors.blueAccent,
          "Send friend request");
    }
  }
}

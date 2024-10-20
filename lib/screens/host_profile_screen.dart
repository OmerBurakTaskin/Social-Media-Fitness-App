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

class HostProfileScreen extends StatefulWidget {
  const HostProfileScreen({super.key});

  @override
  State<HostProfileScreen> createState() => _HostProfileScreenState();
}

class _HostProfileScreenState extends State<HostProfileScreen> {
  final _userDbService = UserDbService();
  final _user = auth.FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        User user = (await _userDbService.getSpecificUser(_user.uid))!;
        Provider.of<UIProvider>(context, listen: false)
            .changeHostTitle(user.userName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userDbService.getSpecificUser(_user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final host = snapshot.data!;
            return Expanded(
              child: Column(
                children: [
                  _buildUpperProfile(context, host),
                  const SizedBox(height: 20),
                  Expanded(child: _buildPostsGrid(context, host))
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("An error occured. Please try again.",
                  style: TextStyle(color: Colors.white, fontSize: 22)),
            );
          }
        });
  }

  Widget _buildUpperProfile(BuildContext context, User host) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ProfilePicture(userId: host.userId, radius: 50),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: "${host.friends.length}\n",
              style: const TextStyle(fontSize: 19, height: 1.5)),
          const TextSpan(text: "Gym Partners", style: TextStyle(fontSize: 19)),
        ]),
      ),
      RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(children: [
          TextSpan(text: "12\n", style: TextStyle(fontSize: 19, height: 1.5)),
          TextSpan(text: "Streak", style: TextStyle(fontSize: 19)),
        ]),
      )
    ]);
  }

  Widget _buildPostsGrid(BuildContext context, User host) {
    final postsdbservice = PostDbService();
    return StreamBuilder(
      stream: postsdbservice.getSpecificUsersPosts(host.userId),
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
                                  postsOwner: host,
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
}

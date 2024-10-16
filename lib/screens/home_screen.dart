import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:gym_application/custom_colors.dart";
import "package:gym_application/custom_widgets/post_view.dart";
import "package:gym_application/models/post.dart";
import "package:gym_application/services/post_db_service.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostDbService _postsDbService = PostDbService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(child: _buildFeed());
  }

  Widget _buildFeed() {
    return StreamBuilder(
      stream: _postsDbService.getFeedOfUser(_auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<Post> posts = snapshot.data!.docs
              .map((e) => Post.fromJson(e.data() as Map<String, dynamic>))
              .toList();
          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostView(post: posts[index]);
              });
        }
        return Center(
            child: Text("No posts yet!", style: lightGreyHeadertStyle));
      },
    );
  }
}

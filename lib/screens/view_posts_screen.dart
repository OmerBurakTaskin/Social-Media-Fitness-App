import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/post_view.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/services/post_db_service.dart';

class ViewPostsScreen extends StatefulWidget {
  int initialPostIndex = 0;
  User postsOwner;
  ViewPostsScreen({super.key, required this.postsOwner});

  @override
  State<ViewPostsScreen> createState() => _ViewPostsScreenState();
}

class _ViewPostsScreenState extends State<ViewPostsScreen> {
  late ScrollController _scrollController;
  final postsDbService = PostDbService();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(widget.initialPostIndex * 100.0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor1,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text(
          widget.postsOwner.userName,
          style: lightGreyHeadertStyle,
        ),
      ),
      body: Expanded(
        child: StreamBuilder(
            stream:
                postsDbService.getSpecificUsersPosts(widget.postsOwner.userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No posts found.");
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var post = snapshot.data!.docs[index].data();
                  return PostView(
                    post: Post.fromJson(post as Map<String, dynamic>),
                  );
                },
              );
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gym_application/custom_widgets/post_view.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/services/posts_db_service.dart';

class ViewPostsScreen extends StatefulWidget {
  int initialPostIndex;
  ViewPostsScreen({super.key, required this.initialPostIndex});

  @override
  State<ViewPostsScreen> createState() => _ViewPostsScreenState();
}

class _ViewPostsScreenState extends State<ViewPostsScreen> {
  late ScrollController _scrollController;
  final postsDbService = PostsDbService();

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
    return Expanded(
      child: StreamBuilder(
          stream: postsDbService.getPosts(),
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
                  post: post as Post,
                );
              },
            );
          }),
    );
  }
}

import "package:flutter/material.dart";
import "package:gym_application/services/posts_db_service.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostsDbService _postsDbService = PostsDbService();

  @override
  Widget build(BuildContext context) {
    return Center(child: _postListView());
  }

  Widget _postListView() {
    return StreamBuilder(
      stream: _postsDbService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw Exception("Oi Oi! Been an exception while getting posts m8!");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.white,
            ),
          );
        }
        List posts = snapshot.data?.docs ?? [];
        if (posts.isEmpty) {
          // post yoksa nothing to show yet göster
          return const Center(
            child: Text(
              "Nothing to show yet",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        /*return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Post post = posts[index].data();
              return Column(
                children: [Image.network(post.imageUrl)],
              );
            });*/
        return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              // Post post = Post(
              //     createdOn:
              //         Timestamp(DateTime.april, Duration.millisecondsPerMinute),
              //     imageURL:
              //         "https://live.staticflickr.com/5252/5403292396_0804de9bcf_b.jpg",
              //     likes: 0);

              return Placeholder();
            });
      },
    );
  }
}

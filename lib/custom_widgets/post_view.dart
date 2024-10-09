import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/under_post_elements.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/screens/comments_screen.dart';
import 'package:gym_application/screens/view_profile_screen.dart';
import 'package:gym_application/services/post_db_service.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:gym_application/utils.dart';

class PostView extends StatefulWidget {
  final Post post;
  PostView({super.key, required this.post});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final _userDbService = UserDbService();
  final _postDbService = PostDbService();
  bool isLiked = false;

  Future<List<dynamic>> _getFutures() {
    return Future.wait([
      getProfilePictureURL(widget.post.posterId),
      _userDbService.getSpecificUser(widget.post.posterId),
      _postDbService.isPostLiked(widget.post.postId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _getFutures(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error while loading posts!"));
        } else if (snapshot.hasData && snapshot.data != null) {
          final String ppUrl = snapshot.data![0];
          final User? user = snapshot.data![1];
          bool isLiked = snapshot.data![2];
          int likes = widget.post.likes;
          return Container(
            decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 75, 74, 74), width: 2))),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 12),
                  child: GestureDetector(
                    child: Row(
                      children: [
                        CircleAvatar(
                          minRadius: 20,
                          foregroundImage: NetworkImage(ppUrl),
                        ),
                        const SizedBox(width: 30),
                        Text(user == null ? "" : user.userName,
                            style: TextStyle(
                                color: lightGreyHeaderColor, fontSize: 18))
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewProfileScreen(profileOwner: user!)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      width: screenWidth,
                      fit: BoxFit.fitWidth,
                      widget.post.imageUrl,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                UnderPostElements(
                    isLiked: isLiked, likes: likes, post: widget.post)
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      //isScrollControlled: false,
      backgroundColor: Colors.transparent, // Arka planı transparan yapıyoruz
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color:
                  slightlyDarkBackgroundColor, // Arka plan rengini belirgin hale getiriyoruz
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: CommentsScreen(scrollController: ScrollController()),
          ),
        );
      },
    );
  }
}

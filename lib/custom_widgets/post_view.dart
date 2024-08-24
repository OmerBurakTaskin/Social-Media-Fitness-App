import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/screens/comments_screen.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:gym_application/utils.dart';

class PostView extends StatefulWidget {
  final Post post;
  const PostView({super.key, required this.post});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final userDbService = UserDbService();

  Future<List<dynamic>> _getFutures() {
    return Future.wait([
      getProfilePictureURL(widget.post.posterId),
      userDbService.getSpecificUser(widget.post.posterId)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _getFutures(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 500,
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              )));
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error while loading posts!"));
        } else if (snapshot.hasData && snapshot.data != null) {
          String ppUrl = snapshot.data![0];
          User? user = snapshot.data![1];
          return Container(
            decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 75, 74, 74), width: 2))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10),
                  child: GestureDetector(
                    child: Row(
                      children: [
                        CircleAvatar(
                          foregroundImage: NetworkImage(ppUrl),
                        ),
                        const SizedBox(width: 30),
                        Text(user == null ? "" : user.userName,
                            style: TextStyle(
                                color: lightGreyHeaderColor, fontSize: 18))
                      ],
                    ),
                    onTap: () {
                      //navigate to profile screen
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
              ],
            ),
          );
        } else {
          String ppUrl =
              "https://i.pinimg.com/564x/bd/cc/de/bdccde33dea7c9e549b325635d2c432e.jpg";
          return Container(
            decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 75, 74, 74), width: 2))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(ppUrl),
                      ),
                    ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.favorite_border,
                          color: lightGreyTextColor,
                        )),
                    Text(
                      widget.post.likes.toString(),
                      style: TextStyle(color: lightGreyTextColor, fontSize: 15),
                    ),
                    IconButton(
                        onPressed: () {
                          _showComments(context);
                        },
                        icon: Icon(Icons.insert_comment,
                            color: lightGreyTextColor)),
                    Text(
                      widget.post.likes.toString(),
                      style: TextStyle(color: lightGreyTextColor, fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Arka planı transparan yapıyoruz
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color:
                    slightlyDarkBackgroundColor, // Arka plan rengini belirgin hale getiriyoruz
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: CommentsScreen(scrollController: scrollController),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/services/post_db_service.dart';

class UnderPostElements extends StatelessWidget {
  final int likes;
  final bool isLiked;
  final Post post;
  UnderPostElements(
      {super.key,
      required this.isLiked,
      required this.likes,
      required this.post});

  final _postDbService = PostDbService();

  @override
  Widget build(BuildContext context) {
    return Row(
      // under post elements
      children: [
        IconButton(
            onPressed: () {
              _postDbService.togglePostLike(post);
            },
            icon: /*isLiked
              ? SvgPicture.asset(
                  "assets/icons/active_biceps_icon.svg",
                  height: 25,
                )
              : SvgPicture.asset(
                  "assets/icons/passive_biceps_icon.svg",
                  height: 25,
                ),*/
                isLiked
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border_outlined)),
        Text(
          likes.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        )
      ],
    );
  }
}

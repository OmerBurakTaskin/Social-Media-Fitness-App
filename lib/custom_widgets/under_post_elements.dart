import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/services/post_db_service.dart';

class UnderPostElements extends StatefulWidget {
  final Post post;
  const UnderPostElements({super.key, required this.post});

  @override
  State<UnderPostElements> createState() => _UnderPostElementsState();
}

class _UnderPostElementsState extends State<UnderPostElements> {
  final _postDbService = PostDbService();
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    int likes = widget.post.likes;
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              isLiked = !isLiked;
              widget.post.setLikes(
                  isLiked ? widget.post.likes + 1 : widget.post.likes - 1);
              likes = widget.post.likes;
              _postDbService.updatePostLikes(widget.post);
            });
          },
          icon: isLiked
              ? SvgPicture.asset(
                  "assets/icons/active_biceps_icon.svg",
                  height: 25,
                )
              : SvgPicture.asset(
                  "assets/icons/passive_biceps_icon.svg",
                  height: 25,
                ),
        ),
        Text(
          likes.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        )
      ],
    );
  }
}

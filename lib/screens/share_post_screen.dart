import 'package:flutter/material.dart';

class SharePostScreen extends StatefulWidget {
  const SharePostScreen({super.key});
  @override
  State<SharePostScreen> createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  // final post = Post(
  //     createdOn: Timestamp(DateTime.april, Duration.millisecondsPerMinute),
  //     imageURL:
  //         "https://live.staticflickr.com/5252/5403292396_0804de9bcf_b.jpg",
  //     likes: 0);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Placeholder(); //PostView(post: post);
        });
  }
}

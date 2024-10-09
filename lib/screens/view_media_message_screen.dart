import 'dart:io';

import 'package:flutter/material.dart';

class ViewMediaMessageScreen extends StatelessWidget {
  final File imageFile;
  const ViewMediaMessageScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "tag-1",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Media Message"),
        ),
        body: Center(child: Image.file(imageFile)),
      ),
    );
  }
}

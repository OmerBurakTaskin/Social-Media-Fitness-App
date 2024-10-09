import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';

class ProfileMenuButton extends StatelessWidget {
  final Widget content;
  final Function onPressedMethod;
  const ProfileMenuButton(
      {super.key, required this.content, required this.onPressedMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.sizeOf(context).width,
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: themeColor8))),
      child: TextButton(
        onPressed: () => onPressedMethod,
        style: TextButton.styleFrom(
          backgroundColor: themeColor3,
          minimumSize: const Size(300, 50),
          foregroundColor: const Color.fromARGB(255, 206, 201, 201),
        ),
        child: content,
      ),
    );
  }
}

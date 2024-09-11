// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:gym_application/custom_colors.dart";

class CustomTextField extends StatelessWidget {
  final String labelText;
  final double padding;
  final bool obscureText;
  CustomTextField(this.padding, this.labelText, this.obscureText, {super.key});
  final TextEditingController _textEditingController = TextEditingController();

  String getText() {
    return _textEditingController.text;
  }

  TextEditingController getTextEditingController() {
    return _textEditingController;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding),
        child: TextField(
          controller: _textEditingController,
          obscureText: obscureText,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeColor2)),
              border: UnderlineInputBorder(),
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
        ));
  }
}

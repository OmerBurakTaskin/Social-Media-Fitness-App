import "package:flutter/material.dart";

class CustomTextField extends StatefulWidget {
  String labelText;
  double padding;
  bool obscureText;
  CustomTextField(this.padding, this.labelText, this.obscureText, {super.key});
  TextEditingController _textEditingController = TextEditingController();

  String getText() {
    return _textEditingController.text;
  }

  TextEditingController getTextEditingController() {
    return _textEditingController;
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TextField(
        controller: widget._textEditingController,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: widget.labelText),
      ),
    );
  }
}

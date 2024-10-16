import 'package:flutter/material.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/comment_view.dart';
import 'package:gym_application/models/user.dart';

class CommentsScreen extends StatelessWidget {
  final ScrollController scrollController;

  // FocusNode tanımlıyoruz
  final FocusNode _focusNode = FocusNode();

  CommentsScreen({required this.scrollController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 20, // Örnek olarak 20 yorum gösteriyoruz
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: CommentView(
                      commentText: "deneme",
                      author: User(
                        email: "",
                        name: "",
                        surName: "",
                        userId: "",
                        userName: "",
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildChatTextField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTextField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            focusNode: _focusNode, // FocusNode'u TextField'a bağladık
            style: TextStyle(color: Colors.white), // Yazı rengini görünür yapın
            cursorColor: Colors.white, // İmleç rengini görünür yapın
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Comment...",
              hintStyle: lightGreyTextStyle,
            ),
            onTap: () {
              // FocusNode ile ilgili özel işlemler yapabilirsiniz
              _focusNode
                  .requestFocus(); // TextField’a odaklanır ve klavye açılır
            },
          ),
        ),
      ],
    );
  }
}

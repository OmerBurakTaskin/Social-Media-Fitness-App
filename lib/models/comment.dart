class Comment {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;

  Comment(
      {required this.id,
      required this.postId,
      required this.userId,
      required this.content,
      required this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        postId: json['postId'],
        userId: json['userId'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']));
  }
}

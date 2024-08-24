import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_application/models/comment.dart';

class Post {
  String _imageURL;
  Timestamp _createdOn;
  int _likes;
  String _posterId;
  List<Comment> _comments = [];
  Post({
    required String imageURL,
    required Timestamp createdOn,
    required int likes,
    required String posterId,
  })  : _likes = likes,
        _createdOn = createdOn,
        _imageURL = imageURL,
        _posterId = posterId;

  Post.fromJson(Map<String, Object?> json)
      : this(
            createdOn: json["createdOn"]! as Timestamp,
            imageURL: json["imageURL"]! as String,
            likes: json["likes"]! as int,
            posterId: json["posterId"]! as String);

  Map<String, Object?> toJson() {
    return {
      "imageURL": _imageURL,
      "createdOn": _createdOn,
      "likes": _likes,
      "posterId": _posterId
    };
  }

  String get imageUrl => _imageURL;
  Timestamp get createdOn => _createdOn;
  int get likes => _likes;
  String get posterId => _posterId;
}

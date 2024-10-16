import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/models/user.dart';

class PostDbService {
  final userId = auth.FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _postsRef;

  PostDbService() {
    initializePostCollection();
  }

  //POST OPERATIONS
  void initializePostCollection() {
    final String POST_COLLECTION_REF = "users/$userId/posts";
    _postsRef = _firestore.collection(POST_COLLECTION_REF).withConverter<Post>(
        fromFirestore: (snapshots, _) => Post.fromJson(snapshots.data()!),
        toFirestore: (post, _) => post.toJson());
  }

  Stream<QuerySnapshot> getHostPosts() {
    return _postsRef.snapshots();
  }

  Stream<QuerySnapshot> getFeedOfUser(String userId) {
    return _firestore.collection("users/$userId/friends-posts").snapshots();
  }

  Future<bool> uploadPost(File file, User sender) async {
    try {
      final postsRef =
          FirebaseStorage.instance.ref().child(userId).child("posts");
      final fileName = file.path.split('/').last;
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final uploadRef = postsRef.child("$timeStamp-$fileName");
      await uploadRef.putFile(file);
      final imageURL = await uploadRef.getDownloadURL();
      String postId = DateTime.now().microsecondsSinceEpoch.toString();
      final post = Post(
          imageURL: imageURL,
          createdOn: Timestamp.now(),
          likes: 0,
          posterId: userId,
          postId: postId);
      _postsRef.doc(postId).set(post);
      notifyFriendsOfPost(post, sender);
      return true;
    } catch (e) {
      return false;
    }
  }

  void notifyFriendsOfPost(Post post, User sender) async {
    for (String friendId in sender.friends) {
      final String friendPostRef = "users/$friendId/friends-posts";
      _firestore
          .collection(friendPostRef)
          .doc(post.postId)
          .set(post.toJson()); //post id is createdOn
    }
  }

  void addPost(Post post) async {
    String postId = DateTime.now().microsecondsSinceEpoch.toString();
    _postsRef.doc(postId).set(post);
  }

  Stream<QuerySnapshot> getSpecificUsersPosts(String userId) {
    final String userPostRef = "users/$userId/posts";
    return _firestore.collection(userPostRef).snapshots();
  }

  Future<void> deletePost(String postId) async {
    await _postsRef.doc(postId).delete();
  }

  Future<void> updatePostLikes(Post post) async {
    final postOwnerId = post.posterId;
    String collectionRef = "users/$postOwnerId/posts";
    try {
      await _firestore
          .collection(collectionRef)
          .doc(post.postId)
          .update({"likes": post.likes});
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isPostLiked(String postId) async {
    final likedPostsDoc = await _firestore
        .collection("users/$userId/likedPosts")
        .doc(postId)
        .get();
    return likedPostsDoc.exists;
  }

  Future<void> togglePostLike(Post post) async {
    final bool isLiked = await isPostLiked(post.postId);
    try {
      if (isLiked) {
        //remove liked post from user
        _firestore
            .collection("users/$userId/likedPosts")
            .doc(post.postId)
            .delete();
        // dicrement like from post
        _firestore
            .collection("users/${post.posterId}/posts")
            .doc(post.postId)
            .update({"likes": post.likes - 1});
      } else {
        _firestore
            .collection("users/$userId/likedPosts")
            .doc(post.postId)
            .set(post.toJson());
        _firestore
            .collection("users/${post.posterId}/posts")
            .doc(post.postId)
            .update({"likes": post.likes + 1});
      }
    } catch (e) {
      print(e);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_application/models/post.dart';

class PostsDbService {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _postsRef;

  PostsDbService() {
    initializePostCollection();
  }

  //POST OPERATIONS
  void initializePostCollection() {
    final String POST_COLLECTION_REF = "users/$userId/posts";
    _postsRef = _firestore.collection(POST_COLLECTION_REF).withConverter<Post>(
        fromFirestore: (snapshots, _) => Post.fromJson(snapshots.data()!),
        toFirestore: (post, _) => post.toJson());
  }

  Stream<QuerySnapshot> getPosts() {
    return _postsRef.snapshots();
  }

  void addPost(Post post) async {
    String postId = DateTime.now().microsecondsSinceEpoch.toString();
    _postsRef.doc(postId).set(post);
  }

  Stream<QuerySnapshot> getSpecificUsersPosts(String userId) {
    final String userPostRef = "users/$userId/posts";
    return _firestore.collection(userPostRef).snapshots();
  }
}

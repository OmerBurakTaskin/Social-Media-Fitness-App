import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_application/models/post.dart';
import 'package:gym_application/services/posts_db_service.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> getImageFromGallery(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  } catch (e) {
    print("GET IMAGE HATASI" + e.toString());
    return null;
  }
}

Future<bool> uploadPost(File file) async {
  final postsdbservice = PostsDbService();
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final postsRef =
        FirebaseStorage.instance.ref().child(userId).child("posts");
    final fileName = file.path.split('/').last;
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    final uploadRef = postsRef.child("$timeStamp-$fileName");
    await uploadRef.putFile(file);
    final imageURL = await uploadRef.getDownloadURL();
    final post = Post(
        imageURL: imageURL,
        createdOn: Timestamp.now(),
        likes: 0,
        posterId: userId);
    postsdbservice.addPost(post);
    return true;
  } catch (e) {
    print("UPLOAD HATASI" + e.toString());
    return false;
  }
}

Future<String?> getProfilePictureURL(String userId) async {
  try {
    final ppRef =
        FirebaseStorage.instance.ref().child(userId).child("profile-picture");
    final photoRefs = await ppRef.listAll();
    return photoRefs.items.last.getDownloadURL();
  } catch (e) {
    print("PROFIL FOTO INDIRME HATASI");
    return null;
  }
}

Future<bool> addOrChangeProfilePicture(File file) async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ppRef =
        FirebaseStorage.instance.ref().child(userId).child("profile-picture");
    final photoRefs = await ppRef.listAll();
    if (photoRefs.items.isNotEmpty) {
      for (var item in photoRefs.items) {
        await item.delete();
      }
    }
    ppRef.child("profilePicture").putFile(file);
    return true;
  } catch (e) {
    print("PROIL FOTO YUKLEME HATASI");
  }
  return false;
}

Widget? buildAccordingSnapshot(AsyncSnapshot snapshot) {
  if (snapshot.hasError) {
    return const Center(
      child: Text("En error occured!"),
    );
  } else if (snapshot.connectionState == ConnectionState.waiting) {
    return const CircularProgressIndicator(color: Colors.blue);
  }
  return null;
}

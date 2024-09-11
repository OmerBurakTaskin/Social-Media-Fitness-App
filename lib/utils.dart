import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

Future<String> getProfilePictureURL(String userId) async {
  try {
    final ppRef =
        FirebaseStorage.instance.ref().child(userId).child("profile-picture");
    final photoRefs = await ppRef.listAll();
    return photoRefs.items.last.getDownloadURL();
  } catch (e) {
    return "https://i.pinimg.com/564x/bd/cc/de/bdccde33dea7c9e549b325635d2c432e.jpg";
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

import 'dart:io';
import "package:firebase_storage/firebase_storage.dart";
import 'package:image_picker/image_picker.dart';

class StorageService {
  final storage = FirebaseStorage.instance;

  void uploadPhoto() async {
    var userPhotoRef = storage.ref().child("user-name").child("photos");
    var imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print("${file?.path}");
    if (file == null) return;
    try {
      //upload the photo
      await userPhotoRef.putFile(File(file.path));

      // if success, get download URL
      var imageUrl = await userPhotoRef.getDownloadURL();
    } catch (error) {
      print(error);
    }
  }
}

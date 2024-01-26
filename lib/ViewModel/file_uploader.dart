import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<List> uploadFilesToFirebase(List<File> files) async {
  List<dynamic> downloadLinks = [];

  for (var file in files) {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() async {
        String downloadURL = await storageReference.getDownloadURL();
        downloadLinks.add(downloadURL);
      });
    } catch (e) {
      // Handle any errors during the upload process
      print("Error uploading file: $e");
    }
  }

  return downloadLinks;
}
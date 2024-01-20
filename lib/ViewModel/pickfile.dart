import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_bloc.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_events.dart';

class PickFile {

  Future<List> pickMultiple(BuildContext context) async {

    final provider = BlocProvider.of<PickFileBloc>(context);

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      provider.add(PickFileEvents(isFilePicked: true, files: files));
      return files;
    } else {
      return [];
    }
  }

  Future<String> uploadToFireStore(FilePickerResult filePickerResult) async {
    Uint8List? fileBytes = filePickerResult.files.first.bytes;
    //String fileName = filePickerResult.files.first.name;

    Reference ref = FirebaseStorage.instance.ref().child(
        '${FirebaseAuth.instance.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}');

    UploadTask uploadTask = ref.putData(fileBytes!);
    TaskSnapshot snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } else {
      //messenger.showSnackBar(SnackBar(content: Text('An Error Occurred\n${snapshot.state}')));
      return '';
    }

  }
}

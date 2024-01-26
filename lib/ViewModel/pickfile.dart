import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_bloc.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_events.dart';

class PickFile {

  Future<List<File>> usingFilePicker(BuildContext context) async {
    final provider = BlocProvider.of<PickFileBloc>(context);

    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = [];
      for (PlatformFile file in result.files) {
        files.add(File(file.path!));
      }

      provider.add(PickFileEvents(isFilePicked: true, files: files, isPosting: false));
      return files;
    } else {
      return [];
    }
  }

  /*File compressedFile = await FileCompressor().compress(File(file.path!));
  files.add(compressedFile);*/

  Future<List> usingImagePicker(BuildContext context) async {

    final ImagePicker picker = ImagePicker();
    final provider = BlocProvider.of<PickFileBloc>(context);

    // Pick multiple images and videos.
    final List<XFile> result = await picker.pickMultiImage();

    List<File> files = [];//result.paths.map((path) => File(path!)).toList();

    for(int i=0; i<result.length; i++){

      //files.add(await FileCompressor().compress(File(result[i].path)));
      files.add(File(result[i].path));
    }

    provider.add(PickFileEvents(isFilePicked: true, files: files, isPosting: false));
    return files;

  }
}

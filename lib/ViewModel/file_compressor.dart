import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:superstate/ViewModel/filetype_extractor.dart';
import 'package:video_compress/video_compress.dart';

class FileCompressor {
  Future<File> compress(File file) async {
    if(fileTypeExtractor(file) == 'image'){
      File compressedFile = await FileCompressor().compressImage(file);

      return(compressedFile);
    }
    else if(fileTypeExtractor(file) == 'video'){
      File? compressedFile = await FileCompressor().compressVideo(file);

      print("Video Size Is: ${await compressedFile!.length()}");
      return(compressedFile);
    }
    else{
      return(file);
    }
  }

  Future<File> compressImage(File file) async {
    img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image != null) {
      img.Image compressedImage = img.copyResize(image, width: 1024);
      return File('${file.path}_compressed.jpg')..writeAsBytesSync(img.encodeJpg(compressedImage, quality: 70));
    } else {
      return file;
    }
  }

  Future<File?> compressVideo(File file) async {

    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );

    /*if(info!.path != null){
      return info.path;
    }else{
      return '';
    }*/

    if(info!.file != null){
      return info.file;
    }else{
      return file;
    }

  }
}
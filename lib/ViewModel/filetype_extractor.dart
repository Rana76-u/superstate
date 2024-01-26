import 'dart:io';

String  fileTypeExtractor(File file) {
  String fileExtension = file.path.split('.').last.toLowerCase();
  String fileType = '';
  if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
    fileType = 'image';
  }
  else if (fileExtension == 'mp4' || fileExtension == 'avi' || fileExtension == 'mov'){
    fileType = 'video';
  }
  else if (fileExtension == 'pdf') {
    fileType = 'pdf';
  }
  else if (fileExtension == 'gif'){
    fileType = 'gif';
  }
  else if (fileExtension == 'mp3' || fileExtension == 'wav') {
    fileType = 'audio';
  }

  return fileType;
}
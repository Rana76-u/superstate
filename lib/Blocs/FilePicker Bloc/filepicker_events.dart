
import 'dart:io';

class PickFileEvents{
  final bool isFilePicked;
  final List<File> files;
  final bool isPosting;

  const PickFileEvents({required this.isFilePicked, required this.files, required this.isPosting});
}
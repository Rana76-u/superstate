
import 'dart:io';
import 'package:equatable/equatable.dart';

class PickFileState extends Equatable {
  final bool isFilePicked;
  final List<File> files;
  final bool isPosting;

  const PickFileState({required this.isFilePicked, required this.files, required this.isPosting});

  @override
  List<Object?> get props => [isFilePicked, files, isPosting];
}
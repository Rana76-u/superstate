
import 'package:equatable/equatable.dart';

class PickFileState extends Equatable {
  final bool isFilePicked;
  final List files;

  const PickFileState({required this.isFilePicked, required this.files});

  @override
  List<Object?> get props => [isFilePicked, files];
}
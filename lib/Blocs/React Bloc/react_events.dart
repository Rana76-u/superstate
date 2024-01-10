import 'package:equatable/equatable.dart';

abstract class ReactEvent extends Equatable {
  final int index;

  const ReactEvent({required this.index});
}

class LikeEvent extends ReactEvent {
  const LikeEvent({required super.index});

  @override
  List<Object?> get props => [index]; //throw UnimplementedError()
/*  final int react;

  LikeEvent({required this.react});*/
}

class NeutralEvent extends ReactEvent {
  const NeutralEvent({required super.index});
  @override
  List<Object?> get props => [index];
}

class DislikeEvent extends ReactEvent {
  const DislikeEvent({required super.index});
  @override
  List<Object?> get props => [index];
}

class NewPostEvent extends ReactEvent {
  const NewPostEvent({required super.index});

  @override
  List<Object?> get props => [index];
}
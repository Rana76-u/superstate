import 'package:equatable/equatable.dart';

class ReactState extends Equatable{
  final List<int> reactList;

  const ReactState({required this.reactList,});

  @override
  List<Object?> get props => [reactList];
}
import 'package:equatable/equatable.dart';

class YoutubePlayerStates extends Equatable {
  final bool isMute;

  const YoutubePlayerStates({required this.isMute});

  @override
  List<Object?> get props => [isMute];
}
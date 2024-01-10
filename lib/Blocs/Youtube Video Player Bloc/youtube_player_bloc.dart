import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/Blocs/Youtube%20Video%20Player%20Bloc/youtube_player_events.dart';
import 'package:superstate/Blocs/Youtube%20Video%20Player%20Bloc/youtube_player_states.dart';

class YoutubePlayerBloc extends Bloc<YoutubePlayerEvents, YoutubePlayerStates>{
  YoutubePlayerBloc() : super(const YoutubePlayerStates(isMute: true)){
    on<YoutubePlayerEvents>((event, emit) {
      if(event is YoutubePlayerMuteEvent){
        emit(const YoutubePlayerStates(isMute: true));
      }
      else if(event is YoutubePlayerUnMuteEvent){
        emit(const YoutubePlayerStates(isMute: false));
      }
    });
  }
}
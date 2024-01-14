import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/Blocs/React%20Bloc/react_events.dart';
import 'package:superstate/Blocs/React%20Bloc/react_states.dart';

class ReactBloc extends Bloc<ReactEvent, ReactState> {
  ReactBloc() : super(const ReactState(reactList: [])) {
    on<ReactEvent>((event, emit) {
      if(event is LikeEvent){
        final List<int> updatedList = List.from(state.reactList);
        if(event.index >= 0 && updatedList.length <= event.index){
          updatedList.add(1);
        }
        else{
          updatedList[event.index] = 1;
        }
        emit(ReactState(reactList: updatedList));
      }
      else if(event is NeutralEvent){
        final List<int> updatedList = List.from(state.reactList);
        if(event.index >= 0 && updatedList.length <= event.index){
          updatedList.add(0);
        }
        else{
          updatedList[event.index] = 0;
        }
        emit(ReactState(reactList: updatedList));
      }
      else if(event is DislikeEvent){
        final List<int> updatedList = List.from(state.reactList);
        if(event.index >= 0 && updatedList.length <= event.index){
          updatedList.add(-1);
        }
        else{
          updatedList[event.index] = -1;
        }
        emit(ReactState(reactList: updatedList));
      }
      else if(event is NewPostEvent){
        final List<int> updatedList = List.from(state.reactList)..add(0);
        emit(ReactState(reactList: updatedList));
      }
    });
  }
}
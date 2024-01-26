import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_events.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_states.dart';

class PickFileBloc extends Bloc<PickFileEvents, PickFileState> {
  PickFileBloc() : super(const PickFileState(isFilePicked: false, files: [], isPosting: false)) {
    on<PickFileEvents>((event, emit) {
      emit(PickFileState(isFilePicked: !event.isFilePicked, files: event.files, isPosting: event.isPosting));
    });
  }
}
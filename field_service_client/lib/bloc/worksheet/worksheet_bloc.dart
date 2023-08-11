import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'worksheet_event.dart';
part 'worksheet_state.dart';

class WorksheetBloc extends Bloc<WorksheetEvent, WorksheetState> {
  WorksheetBloc() : super(WorksheetLoading()) {
    on<GetWorksheet>((event, emit) {
      emit(WorksheetLoaded(worksheet: event.worksheet));
    });
  }
}

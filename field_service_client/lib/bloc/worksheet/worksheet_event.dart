part of 'worksheet_bloc.dart';

sealed class WorksheetEvent extends Equatable {
  const WorksheetEvent();

  @override
  List<Object> get props => [];
}

class GetWorksheet extends WorksheetEvent {
  const GetWorksheet({this.worksheet = const []});

  final List<dynamic> worksheet;

  @override
  List<Object> get props => [worksheet];
}

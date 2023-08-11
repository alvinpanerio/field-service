part of 'worksheet_bloc.dart';

sealed class WorksheetState extends Equatable {
  const WorksheetState();

  @override
  List<Object> get props => [];
}

final class WorksheetInitial extends WorksheetState {}

final class WorksheetLoading extends WorksheetState {}

final class WorksheetLoaded extends WorksheetState {
  const WorksheetLoaded({required this.worksheet});

  final List<dynamic> worksheet;

  @override
  List<Object> get props => [worksheet];
}

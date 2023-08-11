part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTask extends TaskEvent {
  const GetTask({this.task = const []});

  final List<dynamic> task;

  @override
  List<Object> get props => [task];
}

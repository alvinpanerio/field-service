// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetName extends UserEvent {
  const GetName({
    required this.name,
  });

  final String name;

  @override
  List<Object> get props => [name];
}

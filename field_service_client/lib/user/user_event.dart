// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetName extends UserEvent {
  const GetName({
    this.user = const User(name: '', cookies: ''),
  });

  final User user;

  @override
  List<Object> get props => [user];
}

class SetUser extends UserEvent {
  const SetUser({
    required this.name,
    required this.cookies,
  });

  final String name;
  final String cookies;

  @override
  List<Object> get props => [name, cookies];
}

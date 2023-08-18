// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SetUser extends UserEvent {
  const SetUser({
    this.user = const User(name: "", cookies: ""),
  });

  final User user;

  @override
  List<Object> get props => [user];
}

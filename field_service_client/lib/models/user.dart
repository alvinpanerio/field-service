// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:equatable/equatable.dart";

class User extends Equatable {
  const User({
    required this.name,
  });

  final String name;

  @override
  List<Object> get props => [name];

  @override
  bool get stringify => true;

  User copyWith({
    String? name,
  }) {
    return User(
      name: name ?? this.name,
    );
  }
}

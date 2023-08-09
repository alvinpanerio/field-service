// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:equatable/equatable.dart";

class User extends Equatable {
  const User({required this.name, required this.cookies});

  final String name;
  final String cookies;

  @override
  List<Object> get props => [name, cookies];

  @override
  bool get stringify => true;

  User copyWith({
    String? name,
    cookies,
  }) {
    return User(
      name: name ?? this.name,
      cookies: cookies ?? this.cookies,
    );
  }
}

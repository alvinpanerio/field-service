import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetName>((event, emit) async {
      emit(UserLoaded(name: event.name));
    });
  }
}

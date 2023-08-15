import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

part 'camera_controller_event.dart';
part 'camera_controller_state.dart';

class CameraControllerBloc
    extends Bloc<CameraControllerEvent, CameraControllerState> {
  CameraControllerBloc() : super(CameraControllerLoading()) {
    on<GetController>((event, emit) {
      emit(CameraControllerLoaded(controller: event.controller));
    });
  }
}

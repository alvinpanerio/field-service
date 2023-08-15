part of 'camera_controller_bloc.dart';

sealed class CameraControllerEvent extends Equatable {
  const CameraControllerEvent();

  @override
  List<Object> get props => [];
}

class GetController extends CameraControllerEvent {
  const GetController({this.controller});

  final CameraController? controller;

  @override
  List<Object> get props => [jsonEncode(controller)];
}

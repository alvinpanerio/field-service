part of 'camera_controller_bloc.dart';

sealed class CameraControllerState extends Equatable {
  const CameraControllerState();

  @override
  List<Object> get props => [];
}

final class CameraControllerLoading extends CameraControllerState {}

final class CameraControllerLoaded extends CameraControllerState {
  const CameraControllerLoaded({required this.controller});

  final CameraController? controller;

  @override
  List<Object> get props => [jsonEncode(controller)];
}

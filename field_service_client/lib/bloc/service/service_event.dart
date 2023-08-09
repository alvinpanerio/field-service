part of 'service_bloc.dart';

sealed class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class GetServices extends ServiceEvent {
  const GetServices({this.service = const []});

  final List<dynamic> service;

  @override
  List<Object> get props => [service];
}

// class SetServices extends ServiceEvent {
//   const SetServices({
//     required this.name,
//     required this.projectId,
//     required this.userIds,
//   });

//   final String name;
//   final List<dynamic> projectId;
//   final List<dynamic> userIds;

//   @override
//   List<Object> get props => [
//         name,
//         projectId,
//         userIds,
//       ];
// }

class SetServices extends ServiceEvent {
  const SetServices({
    required this.services,
  });

  final List<dynamic> services;

  @override
  List<Object> get props => [services];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServiceLoading()) {
    on<GetServices>((event, emit) async {
      emit(ServiceLoaded(service: event.service));
    });
    on<SetServices>((event, emit) async {
      emit(
        ServiceLoaded(service: event.services),
      );
    });
  }
}

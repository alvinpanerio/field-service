import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'odoo_models_event.dart';
part 'odoo_models_state.dart';

class OdooModelsBloc extends Bloc<OdooModelsEvent, OdooModelsState> {
  OdooModelsBloc() : super(OdooModelsLoading()) {
    on<GetOdooModels>((event, emit) {
      emit(OdooModelsLoaded(partners: event.partners));
    });
  }
}

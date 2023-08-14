part of 'odoo_models_bloc.dart';

sealed class OdooModelsState extends Equatable {
  const OdooModelsState();

  @override
  List<Object> get props => [];
}

final class OdooModelsInitial extends OdooModelsState {}

final class OdooModelsLoading extends OdooModelsState {}

final class OdooModelsLoaded extends OdooModelsState {
  const OdooModelsLoaded({required this.partners});

  final List<dynamic> partners;

  @override
  List<Object> get props => [partners];
}

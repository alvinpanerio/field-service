part of 'odoo_models_bloc.dart';

sealed class OdooModelsState extends Equatable {
  const OdooModelsState();

  @override
  List<Object> get props => [];
}

final class OdooModelsInitial extends OdooModelsState {}

final class OdooModelsLoading extends OdooModelsState {}

final class OdooModelsLoaded extends OdooModelsState {
  const OdooModelsLoaded({
    required this.partners,
    required this.products,
  });

  final List<dynamic> partners;
  final List<dynamic> products;

  @override
  List<Object> get props => [
        partners,
        products,
      ];
}

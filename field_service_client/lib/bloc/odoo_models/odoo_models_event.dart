part of 'odoo_models_bloc.dart';

sealed class OdooModelsEvent extends Equatable {
  const OdooModelsEvent();

  @override
  List<Object> get props => [];
}

class GetOdooModels extends OdooModelsEvent {
  const GetOdooModels({
    this.partners = const [],
    this.products = const [],
  });

  final List<dynamic> partners;
  final List<dynamic> products;

  @override
  List<Object> get props => [
        partners,
        products,
      ];
}

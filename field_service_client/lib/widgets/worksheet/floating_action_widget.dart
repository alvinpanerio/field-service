import 'package:field_service_client/bloc/odoo_models/odoo_models_bloc.dart';
import 'package:field_service_client/utils/api_provider.dart';
import 'package:field_service_client/widgets/worksheet/fields_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/worksheet/worksheet_bloc.dart';
import 'fields_widget.dart';

class FloatingActionWidget extends StatefulWidget {
  const FloatingActionWidget({required this.state, Key? key}) : super(key: key);

  final GoRouterState state;

  @override
  State<FloatingActionWidget> createState() => _FloatingActionWidgetState();
}

class _FloatingActionWidgetState extends State<FloatingActionWidget> {
  FieldsValue fieldsValue = FieldsValue();
  ApiProvider apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WorksheetBloc, WorksheetState>(
          listener: (context, state) {},
        ),
        BlocListener<OdooModelsBloc, OdooModelsState>(
          listener: (context, state) {},
        ),
      ],
      child: FloatingActionButton.extended(
        onPressed: () async {
          final worksheetResponse =
              await apiProvider.getWorksheet(widget.state.params["id"]!);

          // ignore: use_build_context_synchronously
          context
              .read<WorksheetBloc>()
              .add(GetWorksheet(worksheet: worksheetResponse["worksheet"]));

          final modelsResponse = await apiProvider.getModels();

          // ignore: use_build_context_synchronously
          context.read<OdooModelsBloc>().add(GetOdooModels(
              partners: modelsResponse["models"]["partners"],
              products: modelsResponse["models"]["products"]));

          // ignore: use_build_context_synchronously
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            builder: (BuildContext context) {
              return BlocBuilder<WorksheetBloc, WorksheetState>(
                  builder: (context, state) {
                if (state is WorksheetLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is WorksheetLoaded) {
                  List<dynamic> worksheet = state.worksheet;
                  // print(worksheet);

                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.8,
                    maxChildSize: 1.0,
                    minChildSize: 0.6,
                    builder: (context, controller) => SingleChildScrollView(
                      controller: controller,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: worksheet.isEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FieldsWidget(
                                    isEmpty: worksheet.isEmpty,
                                    pathId: widget.state.params["id"]!,
                                    worksheetId: "",
                                    name: fieldsValue.worksheetNameController,
                                    manufacturer:
                                        fieldsValue.worksheetManufacturer,
                                    model: fieldsValue.worksheetModel,
                                    serialNo:
                                        fieldsValue.worksheetSerialNoController,
                                    description: fieldsValue
                                        .worksheetDescriptionController,
                                    interventionType:
                                        fieldsValue.interventionType,
                                    isChecked: fieldsValue.isChecked,
                                    date: fieldsValue.date,
                                    signature: fieldsValue.signature,
                                    picture: fieldsValue.picture,
                                  )
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: worksheet.length,
                                      itemBuilder: (v, i) {
                                        fieldsValue.setControllers(
                                          worksheet[i]["x_name"],
                                          worksheet[i]["x_manufacturer"],
                                          worksheet[i]["x_model"],
                                          worksheet[i]["x_serial_number"],
                                          worksheet[i]["x_intervention_type"],
                                          worksheet[i]["x_description"],
                                          worksheet[i]["x_checkbox"],
                                          worksheet[i]["x_date"],
                                          worksheet[i]["x_worker_signature"],
                                          worksheet[i]["x_studio_picture"] ??
                                              "",
                                        );
                                        return FieldsWidget(
                                          isEmpty: worksheet.isEmpty,
                                          pathId: widget.state.params["id"]!,
                                          worksheetId:
                                              worksheet[i]["id"].toString(),
                                          name: fieldsValue
                                              .worksheetNameController,
                                          manufacturer:
                                              fieldsValue.worksheetManufacturer,
                                          model: fieldsValue.worksheetModel,
                                          serialNo: fieldsValue
                                              .worksheetSerialNoController,
                                          description: fieldsValue
                                              .worksheetDescriptionController,
                                          interventionType:
                                              fieldsValue.interventionType,
                                          isChecked: fieldsValue.isChecked,
                                          date: fieldsValue.date,
                                          signature: fieldsValue.signature,
                                          picture: fieldsValue.picture,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                } else {
                  return const Text("went wrong");
                }
              });
            },
          );
        },
        label: const Text("Worksheet"),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}

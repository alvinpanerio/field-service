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
    return BlocListener<WorksheetBloc, WorksheetState>(
      listener: (context, state) {},
      child: FloatingActionButton.extended(
        onPressed: () async {
          final response =
              await apiProvider.getWorksheet(widget.state.params["id"]!);
          // ignore: use_build_context_synchronously
          context
              .read<WorksheetBloc>()
              .add(GetWorksheet(worksheet: response["worksheet"]));

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
                  print(worksheet);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: worksheet.isEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FieldsWidget(
                                isEmpty: worksheet.isEmpty,
                                pathId: widget.state.params["id"]!,
                                worksheetId: "",
                                name: fieldsValue.worksheetNameController,
                                manufacturer:
                                    fieldsValue.worksheetManufacturerController,
                                serialNo:
                                    fieldsValue.worksheetSerialNoController,
                                description:
                                    fieldsValue.worksheetDescriptionController,
                                interventionType: fieldsValue.interventionType,
                                isChecked: fieldsValue.isChecked,
                              )
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: worksheet.length,
                                itemBuilder: (v, i) {
                                  fieldsValue.setControllers(
                                    worksheet[i]["x_name"],
                                    worksheet[i]["x_manufacturer"],
                                    worksheet[i]["x_serial_number"],
                                    worksheet[i]["x_intervention_type"],
                                    worksheet[i]["x_description"],
                                    worksheet[i]["x_checkbox"],
                                  );
                                  return FieldsWidget(
                                    isEmpty: worksheet.isEmpty,
                                    pathId: widget.state.params["id"]!,
                                    worksheetId: worksheet[i]["id"].toString(),
                                    name: fieldsValue.worksheetNameController,
                                    manufacturer: fieldsValue
                                        .worksheetManufacturerController,
                                    serialNo:
                                        fieldsValue.worksheetSerialNoController,
                                    description: fieldsValue
                                        .worksheetDescriptionController,
                                    interventionType:
                                        fieldsValue.interventionType,
                                    isChecked: fieldsValue.isChecked,
                                  );
                                },
                              ),
                            ],
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

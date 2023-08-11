import 'package:field_service_client/bloc/worksheet/worksheet_bloc.dart';
import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SafeAreaWidget extends StatefulWidget {
  const SafeAreaWidget(this.screen, this.state, {Key? key}) : super(key: key);

  final Widget screen;
  final GoRouterState state;

  @override
  State<SafeAreaWidget> createState() => _SafeAreaWidgetState();
}

class _SafeAreaWidgetState extends State<SafeAreaWidget> {
  int currentPageIndex = 0;
  TextEditingController worksheetNameController = TextEditingController();
  TextEditingController worksheetManufacturerController =
      TextEditingController();
  TextEditingController worksheetSerialNoController = TextEditingController();
  // TextEditingController worksheetModelController = TextEditingController();
  TextEditingController worksheetDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    ApiProvider apiProvider = ApiProvider();
    return SafeArea(
      child: Scaffold(
        appBar: widget.state.path == "/task/:id"
            ? AppBar(
                leading: const BackButton(),
              )
            : null,
        floatingActionButton: widget.state.path == "/task/:id"
            ? BlocListener<WorksheetBloc, WorksheetState>(
                listener: (context, state) {},
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    final response = await apiProvider
                        .getWorksheet(widget.state.params["id"]!);
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
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: worksheet.length,
                                    itemBuilder: (v, i) {
                                      worksheetNameController.text =
                                          worksheet[i]["x_name"].toString();
                                      worksheetManufacturerController.text =
                                          worksheet[i]["x_manufacturer"][1]
                                              .toString();
                                      worksheetSerialNoController.text =
                                          worksheet[i]["x_serial_number"]
                                              .toString();
                                      worksheetDescriptionController.text =
                                          worksheet[i]["x_description"]
                                              .toString();
                                      return Column(
                                        children: [
                                          TextField(
                                            controller: worksheetNameController,
                                            obscureText: false,
                                            decoration: const InputDecoration(
                                              labelText: "Name",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller:
                                                worksheetManufacturerController,
                                            obscureText: false,
                                            decoration: const InputDecoration(
                                              labelText: "Manufacturer",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller:
                                                worksheetSerialNoController,
                                            obscureText: false,
                                            decoration: const InputDecoration(
                                              labelText: "Serial No.",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller:
                                                worksheetDescriptionController,
                                            obscureText: false,
                                            decoration: const InputDecoration(
                                              labelText: "Description",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('Close BottomSheet'),
                                    onPressed: () => Navigator.pop(context),
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
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: widget.screen,
        ),
      ),
    );
  }
}

import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/odoo_models/odoo_models_bloc.dart';
import 'fields_value.dart';

class FieldsWidget extends StatefulWidget {
  FieldsWidget(
      {required this.isEmpty,
      required this.pathId,
      required this.worksheetId,
      required this.name,
      required this.manufacturer,
      required this.model,
      required this.serialNo,
      required this.description,
      required this.interventionType,
      required this.isChecked,
      required this.date,
      Key? key})
      : super(key: key);

  final String pathId;
  final String worksheetId;
  final bool isEmpty;

  final TextEditingController name;
  final List<dynamic> manufacturer;
  final List<dynamic> model;
  final TextEditingController serialNo;
  final TextEditingController description;

  final String interventionType;
  final bool isChecked;

  String date;

  @override
  State<FieldsWidget> createState() => _FieldsWidgetState();
}

class _FieldsWidgetState extends State<FieldsWidget> {
  ApiProvider apiProvider = ApiProvider();

  FieldsValue fieldsValue = FieldsValue();

  bool isChecked = false;

  String interventionType = "";

  TextEditingController manufacturerController = TextEditingController();
  TextEditingController modelController = TextEditingController();

  @override
  void initState() {
    if (widget.manufacturer.isEmpty || widget.model.isEmpty) {
      widget.manufacturer.add(0);
      widget.manufacturer.add("");
      widget.model.add(0);
      widget.model.add("");
    }

    if (!widget.isEmpty) {
      isChecked = widget.isChecked;
      interventionType = widget.interventionType;
      manufacturerController.text = widget.manufacturer[1].toString();
      modelController.text = widget.model[1].toString();
    }
    super.initState();
  }

  void openCalendarPicker() async {
    final response = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime.now());
    setState(() {
      widget.date = DateFormat('yyyy-MM-dd').format(response!);
    });
    print(widget.date);
  }

  void createWorksheetInformation() async {
    await apiProvider.createWorksheet(
      widget.pathId,
      widget.name.text,
      widget.manufacturer,
      widget.model,
      widget.serialNo.text,
      interventionType,
      widget.description.text,
      isChecked,
      widget.date,
    );
  }

  void updateWorksheetInformation() async {
    await apiProvider.setWorksheet(
      widget.worksheetId,
      widget.name.text,
      widget.manufacturer,
      widget.model,
      widget.serialNo.text,
      interventionType,
      widget.description.text,
      isChecked,
      widget.date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OdooModelsBloc, OdooModelsState>(
      builder: (context, state) {
        if (state is OdooModelsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.name,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownMenu(
                controller: manufacturerController,
                label: const Text('Manufacturer'),
                width: MediaQuery.of(context).size.width - 40,
                dropdownMenuEntries:
                    state.partners.map<DropdownMenuEntry<String>>((value) {
                  return DropdownMenuEntry<String>(
                      label: value["commercial_partner_id"][1],
                      value:
                          "${value['id']},${value['commercial_partner_id'][1]}");
                }).toList(),
                onSelected: (String? value) {
                  setState(() {
                    List<dynamic> valueArray = value!.split(',');

                    widget.manufacturer[0] = int.parse(valueArray[0]);
                    widget.manufacturer[1] = valueArray[1];
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownMenu(
                controller: modelController,
                label: const Text('Model'),
                width: MediaQuery.of(context).size.width - 40,
                dropdownMenuEntries:
                    state.products.map<DropdownMenuEntry<String>>((value) {
                  return DropdownMenuEntry<String>(
                      label: value["product_variant_id"][1],
                      value:
                          "${value['id']},${value['product_variant_id'][1]}");
                }).toList(),
                onSelected: (String? value) {
                  print(widget.model);

                  setState(() {
                    List<dynamic> valueArray = value!.split(',');

                    widget.model[0] = int.parse(valueArray[0]);
                    widget.model[1] = valueArray[1];
                  });
                  print(widget.model);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: widget.serialNo,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: "Serial No.",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text("Intervention Type"),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: fieldsValue.interventionTypes.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(
                                fieldsValue.convertInterventionTypeType(
                                  fieldsValue.interventionTypes[i],
                                ),
                              ),
                              leading: Radio(
                                value: fieldsValue.interventionTypes[i],
                                groupValue: interventionType,
                                onChanged: (value) {
                                  setState(() {
                                    interventionType = value.toString();
                                  });
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: widget.description,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(""),
              CheckboxListTile(
                value: isChecked,
                title: const Text(
                    "I hereby certify that this device meets the requirements of an acceptable device at the time of testing."),
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              FilledButton.tonal(
                onPressed: openCalendarPicker,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "DATE",
                                  style: TextStyle(fontSize: 10),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 15,
                                ),
                              ],
                            ),
                            Text(
                              widget.date == ""
                                  ? "Choose Date"
                                  : widget.date.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (widget.isEmpty) {
                    createWorksheetInformation();
                  } else {
                    updateWorksheetInformation();
                  }
                },
                child: const Text("Save"),
              )
            ],
          );
        } else {
          return const Text("went wrong");
        }
      },
    );
  }
}

import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';

import 'fields_value.dart';

class FieldsWidget extends StatefulWidget {
  const FieldsWidget(
      {required this.isEmpty,
      required this.pathId,
      required this.worksheetId,
      required this.name,
      required this.manufacturer,
      required this.serialNo,
      required this.description,
      required this.interventionType,
      required this.isChecked,
      Key? key})
      : super(key: key);

  final String pathId;
  final String worksheetId;
  final bool isEmpty;

  final TextEditingController name;
  final TextEditingController manufacturer;
  final TextEditingController serialNo;
  final TextEditingController description;

  final String interventionType;
  final bool isChecked;

  @override
  State<FieldsWidget> createState() => _FieldsWidgetState();
}

class _FieldsWidgetState extends State<FieldsWidget> {
  ApiProvider apiProvider = ApiProvider();

  FieldsValue fieldsValue = FieldsValue();

  bool isChecked = false;

  String interventionType = "";

  @override
  void initState() {
    if (!widget.isEmpty) {
      isChecked = widget.isChecked;
      interventionType = widget.interventionType;
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
      fieldsValue.date = response;
    });
  }

  void createWorksheetInformation() async {
    final response = await apiProvider.createWorksheet(
      widget.pathId,
      widget.name.text,
      widget.manufacturer.text,
      widget.serialNo.text,
      interventionType,
      widget.description.text,
      isChecked,
      fieldsValue.date,
    );
  }

  void updateWorksheetInformation() async {
    final response = await apiProvider.setWorksheet(
      widget.worksheetId,
      widget.name.text,
      widget.manufacturer.text,
      widget.serialNo.text,
      interventionType,
      widget.description.text,
      isChecked,
      fieldsValue.date,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        TextField(
          controller: widget.manufacturer,
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
                        fieldsValue.date == null
                            ? "Choose Date"
                            : fieldsValue.date.toString(),
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
  }
}

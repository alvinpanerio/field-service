import 'package:flutter/material.dart';

import 'fields_value.dart';

class FieldsWidget extends StatefulWidget {
  const FieldsWidget(
      {required this.worksheetNameController,
      required this.worksheetManufacturerController,
      required this.worksheetSerialNoController,
      required this.interventionTypes,
      required this.worksheetDescriptionController,
      Key? key})
      : super(key: key);

  final TextEditingController worksheetNameController;
  final TextEditingController worksheetManufacturerController;
  final TextEditingController worksheetSerialNoController;
  final TextEditingController worksheetDescriptionController;

  final List<String> interventionTypes;

  @override
  State<FieldsWidget> createState() => _FieldsWidgetState();
}

class _FieldsWidgetState extends State<FieldsWidget> {
  FieldsValue fieldsValue = FieldsValue();
  String interventionType = "";
  bool isChecked = false;
  DateTime? date;

  void openCalendarPicker() async {
    final response = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime.now());
    setState(() {
      date = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.worksheetNameController,
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
          controller: widget.worksheetManufacturerController,
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
          controller: widget.worksheetSerialNoController,
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
                    itemCount: widget.interventionTypes.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(
                          fieldsValue.convertInterventionTypeType(
                            widget.interventionTypes[i],
                          ),
                        ),
                        leading: Radio(
                          value: widget.interventionTypes[i],
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
          controller: widget.worksheetDescriptionController,
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
                        date == null ? "Choose Date" : date.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

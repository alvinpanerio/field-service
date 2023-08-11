import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

class FieldsValue {
  FieldsValue({
    this.interventionTypes = const [
      "first_installation",
      "technical_maintenance"
    ],
  });

  final List<String> interventionTypes;

  TextEditingController worksheetNameController = TextEditingController();
  TextEditingController worksheetManufacturerController =
      TextEditingController();
  TextEditingController worksheetSerialNoController = TextEditingController();
  // TextEditingController worksheetModelController = TextEditingController();
  TextEditingController worksheetDescriptionController =
      TextEditingController();

  String interventionType = "";

  bool isChecked = false;

  DateTime? date;

  void setControllers(
      name, manufacturer, serialNo, intervention, description, isCheck) {
    worksheetNameController.text = name == false ? "" : name.toString();
    worksheetManufacturerController.text =
        manufacturer == false ? "" : manufacturer[1].toString();
    worksheetSerialNoController.text =
        serialNo == false ? "" : serialNo.toString();
    interventionType = intervention == false ? "" : intervention.toString();
    worksheetDescriptionController.text =
        description == false ? "" : description.toString();
    isChecked = isCheck;
  }

  String convertInterventionTypeType(String value) {
    String converted = value.replaceAllMapped(RegExp(r'_\w'), (match) {
      return ' ${match.group(0)![1].toUpperCase()}';
    });
    return StringUtils.capitalize(converted.toString());
  }
}

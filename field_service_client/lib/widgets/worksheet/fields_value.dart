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

  void setControllers(name, manufacturer, serialNo, description) {
    worksheetNameController.text = name;
    worksheetManufacturerController.text = manufacturer;
    worksheetSerialNoController.text = serialNo;
    worksheetDescriptionController.text = description;
  }

  String convertInterventionTypeType(String value) {
    String converted = value.replaceAllMapped(RegExp(r'_\w'), (match) {
      return ' ${match.group(0)![1].toUpperCase()}';
    });
    return StringUtils.capitalize(converted.toString());
  }
}

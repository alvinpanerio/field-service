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

  List<dynamic> worksheetManufacturer = [];
  List<dynamic> worksheetModel = [];

  TextEditingController worksheetSerialNoController = TextEditingController();

  TextEditingController worksheetDescriptionController =
      TextEditingController();

  List<Map<String, dynamic>> manufacturers = [];

  String interventionType = "";

  bool isChecked = false;

  String date = "";

  String signature = "";

  String picture = "";

  void setControllers(name, manufacturer, model, serialNo, intervention,
      description, isCheck, dateValue, signatureValue, pictureValue) {
    worksheetNameController.text = name == false ? "" : name.toString();
    worksheetManufacturer = manufacturer == false ? [0, ""] : manufacturer;
    worksheetModel = model == false ? [0, ""] : model;
    worksheetSerialNoController.text =
        serialNo == false ? "" : serialNo.toString();
    interventionType = intervention == false ? "" : intervention.toString();
    worksheetDescriptionController.text =
        description == false ? "" : description.toString();
    isChecked = isCheck;
    date = dateValue == false ? "" : dateValue;
    signature = signatureValue == false ? "" : signatureValue;
    picture = pictureValue == false ? "" : pictureValue;
  }

  String convertInterventionTypeType(String value) {
    String converted = value.replaceAllMapped(RegExp(r'_\w'), (match) {
      return ' ${match.group(0)![1].toUpperCase()}';
    });
    return converted.toString();
    // StringUtils.capitalize(converted.toString());
  }
}

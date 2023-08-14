import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:field_service_client/bloc/worksheet/worksheet_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiProvider {
  final Dio dio = Dio();

  Future _get(String res) async {
    try {
      dio.options.extra['withCredentials'] = true;
      final response = await dio.get(
        "${dotenv.env['API_URL']}" "$res",
      );

      return response;
    } catch (err) {
      return;
    }
  }

  Future _post(String res, [Map<String, dynamic>? data]) async {
    try {
      dio.options.extra['withCredentials'] = true;

      final response = await dio.post(
        "${dotenv.env['API_URL']}" "$res",
        data: data,
      );
      return response;
    } catch (err) {
      return err;
    }
  }

  Future login(String email, String password, context) async {
    final rawResponse = await _post(
      "/login",
      {
        'email': email,
        'password': password,
      },
    );

    Map<String, dynamic> response = jsonDecode(rawResponse.toString());

    return response;
  }

  Future getAllTasks() async {
    final rawResponse = await _get(
      "/all-tasks",
    );

    Map<String, dynamic> response = jsonDecode(rawResponse.toString());

    return response;
  }

  Future getMyTasks() async {
    final rawResponse = await _get(
      "/my-tasks",
    );

    Map<String, dynamic> response = jsonDecode(rawResponse.toString());

    return response;
  }

  Future getTask(String id) async {
    final rawResponse = await _get(
      "/task?id=$id",
    );

    Map<String, dynamic> response = jsonDecode(rawResponse.toString());

    return response;
  }

  Future getWorksheet(String id) async {
    final rawResponse = await _get(
      "/worksheet?id=$id",
    );

    Map<String, dynamic> response = jsonDecode(rawResponse.toString());

    return response;
  }

  Future setWorksheet(
    String id,
    String name,
    List<dynamic> manufacturer,
    String serialNo,
    String interventionType,
    String description,
    bool isChecked,
    DateTime? date,
  ) async {
    final rawResponse = await _post(
      "/update-worksheet?id=$id",
      {
        'name': name,
        'manufacturer': manufacturer,
        'serial_no': serialNo,
        'intervention_type': interventionType,
        'description': description,
        'is_checked': isChecked,
        'date': date,
      },
    );

    bool response = jsonDecode(rawResponse.toString());

    return response;
  }

  Future createWorksheet(
    String id,
    String name,
    List<dynamic> manufacturer,
    String serialNo,
    String interventionType,
    String description,
    bool? isChecked,
    DateTime? date,
  ) async {
    final rawResponse = await _post(
      "/create-worksheet?id=$id",
      {
        'name': name,
        'manufacturer': manufacturer,
        'serial_no': serialNo,
        'intervention_type': interventionType,
        'description': description,
        'is_checked': isChecked,
        'date': date,
      },
    );

    int response = jsonDecode(rawResponse.toString());

    return response;
  }

  Future getModels() async {
    final rawResponse = await _get(
      "/models",
    );

    Map<String, dynamic> response = jsonDecode(rawResponse.toString());

    return response;
  }
}

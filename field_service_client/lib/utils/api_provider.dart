import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:field_service_client/bloc/worksheet/worksheet_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:requests/requests.dart';

class ApiProvider {
  final Dio dio = Dio();

  Future _get(String res) async {
    try {
      dio.options.extra['withCredentials'] = true;
      final response = await Requests.get(
        "http://localhost:5000" "$res",
        bodyEncoding: RequestBodyEncoding.JSON,
      );

      print(response.json());

      return response.json();
    } catch (err) {
      return;
    }
  }

  Future _post(String res, [Map<String, dynamic>? data]) async {
    try {
      // dio.options.extra['withCredentials'] = true;

      final response = await Requests.post(
        "http://localhost:5000" "$res",
        body: data,
        bodyEncoding: RequestBodyEncoding.JSON,
      );

      print(response.json());

      return response.json();
    } catch (err) {
      return err;
    }
  }

  Future login(String email, String password, context) async {
    final rawResponse = await _post(
      "/login",
      // {
      //   'email': email,
      //   'password': password,
      // },
      {
        'email': "alvin.panerio@achievewithoutborders.com",
        'password': "alvinpanerio",
      },
    );

    final response = rawResponse;

    return response;
  }

  Future getAllTasks() async {
    final rawResponse = await _get(
      "/all-tasks",
    );

    final response = rawResponse;

    return response;
  }

  Future getMyTasks() async {
    final rawResponse = await _get(
      "/my-tasks",
    );

    final response = rawResponse;

    return response;
  }

  Future getTask(String id) async {
    final rawResponse = await _get(
      "/task?id=$id",
    );

    final response = rawResponse;

    return response;
  }

  Future getWorksheet(String id) async {
    final rawResponse = await _get(
      "/worksheet?id=$id",
    );

    final response = rawResponse;

    return response;
  }

  Future setWorksheet(
    String id,
    String name,
    List<dynamic> manufacturer,
    List<dynamic> model,
    String serialNo,
    String interventionType,
    String description,
    bool isChecked,
    String date,
    String signature,
    String picture,
  ) async {
    final rawResponse = await _post(
      "/update-worksheet?id=$id",
      {
        'name': name,
        'manufacturer': manufacturer,
        'model': model,
        'serial_no': serialNo,
        'intervention_type': interventionType,
        'description': description,
        'is_checked': isChecked,
        'date': date,
        'signature': signature,
        'picture': picture,
      },
    );

    final response = rawResponse;

    return response;
  }

  Future createWorksheet(
    String id,
    String name,
    List<dynamic> manufacturer,
    List<dynamic> model,
    String serialNo,
    String interventionType,
    String description,
    bool? isChecked,
    String date,
    String signature,
    String picture,
  ) async {
    final rawResponse = await _post(
      "/create-worksheet?id=$id",
      {
        'name': name,
        'manufacturer': manufacturer,
        'model': model,
        'serial_no': serialNo,
        'intervention_type': interventionType,
        'description': description,
        'is_checked': isChecked,
        'date': date,
        'signature': signature,
        'picture': picture,
      },
    );

    final response = rawResponse;

    return response;
  }

  Future getModels() async {
    final rawResponse = await _get(
      "/models",
    );

    final response = rawResponse;

    return response;
  }
}

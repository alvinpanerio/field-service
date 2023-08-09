import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class ApiProvider {
  final Dio dio = Dio();

  Future _get(String res) async {
    try {
      dio.options.extra['withCredentials'] = true;
      final response = await dio.get(
        "${dotenv.env['API_URL']}" "$res",
      );
      print(response);
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
    return response["name"];
  }
}
